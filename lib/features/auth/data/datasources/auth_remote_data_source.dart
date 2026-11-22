import 'dart:io';

import 'package:blog_rivaan/core/error/exceptions.dart';
import 'package:blog_rivaan/features/auth/data/model/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Session? get userCurrentSession;
  Future<UserModel> signupWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<UserModel?> getCurrentUserData();

  Future<void> logOut();

  Future<UserModel> uploadProfileImage({
    required File image,
    required String userId,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;
  AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Session? get userCurrentSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        password: password,
        email: email,
      );
      if (response.user == null) {
        throw ServerExceptions('User is null');
      }
      return UserModel.fromJson(response.user!.toJson()).copyWith();
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }

  @override
  Future<UserModel> signupWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        password: password,
        email: email,
        data: {'name': name},
      );
      if (response.user == null) {
        throw ServerExceptions('User is null');
      }
      return UserModel.fromJson(response.user!.toJson()).copyWith();
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (userCurrentSession != null) {
        final userData = await supabaseClient
            .from('profiles')
            .select()
            .eq('id', userCurrentSession!.user.id);

        final metadata = userCurrentSession!.user.userMetadata;
        final profileImageUrl = (userData.isNotEmpty
                ? (userData.first['profile_image'] ?? userData.first['avatar_url'])
                : null) ??
            metadata?['profile_image'] ??
            metadata?['avatar_url'];

        if (userData.isNotEmpty) {
          return UserModel.fromJson(userData.first).copyWith(
            email: userCurrentSession!.user.email,
            profileImage: profileImageUrl as String?,
          );
        }

        return UserModel(
          id: userCurrentSession!.user.id,
          name: metadata?['name'] ?? '',
          email: userCurrentSession!.user.email ?? '',
          profileImage: profileImageUrl as String?,
        );
      }
      return null;
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }

  @override
  Future<void> logOut() async {
    try {
      await supabaseClient.auth.signOut();
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }

  @override
  Future<UserModel> uploadProfileImage({
    required File image,
    required String userId,
  }) async {
    try {
      final imagePath = 'profiles/$userId.jpg';
      await supabaseClient.storage.from('blog_images').upload(
        imagePath,
        image,
        fileOptions: const FileOptions(upsert: true),
      );

      final imageUrl = supabaseClient.storage
          .from('blog_images')
          .getPublicUrl(imagePath);

      // Try updating profiles table
      try {
        await supabaseClient.from('profiles').update({
          'profile_image': imageUrl,
        }).eq('id', userId);
      } catch (_) {
        // Table might not have profile_image column yet, fallback to user metadata
      }

      // Update auth user metadata
      final userResponse = await supabaseClient.auth.updateUser(
        UserAttributes(data: {'profile_image': imageUrl}),
      );

      final currentUser = await getCurrentUserData();
      if (currentUser != null) {
        return currentUser.copyWith(profileImage: imageUrl);
      }

      return UserModel(
        id: userId,
        name: userResponse.user?.userMetadata?['name'] ?? '',
        email: userResponse.user?.email ?? '',
        profileImage: imageUrl,
      );
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }
}
