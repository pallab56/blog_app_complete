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
        return UserModel.fromJson(userData.first)
            .copyWith(email: userCurrentSession!.user.email);
      }
      return null;
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }
}
