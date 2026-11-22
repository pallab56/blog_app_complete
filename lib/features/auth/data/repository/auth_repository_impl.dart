import 'dart:io';

import 'package:blog_rivaan/core/error/exceptions.dart';
import 'package:blog_rivaan/core/error/failures.dart';
import 'package:blog_rivaan/core/network/connection_checker.dart';
import 'package:blog_rivaan/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_rivaan/core/common/entity/user.dart';
import 'package:blog_rivaan/features/auth/data/model/user_model.dart';
import 'package:blog_rivaan/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final InternetConnectionChecker internetConnectionChecker;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.internetConnectionChecker,
  });

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      if (!await (internetConnectionChecker.isConnected)) {
        final session = remoteDataSource.userCurrentSession;
        if (session == null) {
          return left(Failure(msg: 'User Not Logged In!!!'));
        }
        return right(
          UserModel(id: session.user.id, name: '', email: session.user.email ?? ''),
        );
      }
      final user = await remoteDataSource.getCurrentUserData();
      if (user == null) {
        return left(Failure(msg: 'User Not Logged In!!!'));
      }
      return right(user);
    } on ServerExceptions catch (e) {
      return left(Failure(msg: e.msg));
    }
  }

  @override
  Future<Either<Failure, User>> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await remoteDataSource.loginWithEmailPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, User>> signupWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await remoteDataSource.signupWithEmailPassword(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> logOut() async {
    try {
      if (!await (internetConnectionChecker.isConnected)) {
        return left(Failure(msg: 'No Internet Connection'));
      }
      await remoteDataSource.logOut();
      return right(null);
    } on ServerExceptions catch (e) {
      return left(Failure(msg: e.msg));
    }
  }

  @override
  Future<Either<Failure, User>> uploadProfileImage({
    required File image,
    required String userId,
  }) async {
    try {
      if (!await (internetConnectionChecker.isConnected)) {
        return left(Failure(msg: 'No Internet Connection'));
      }
      final user = await remoteDataSource.uploadProfileImage(
        image: image,
        userId: userId,
      );
      return right(user);
    } on sb.StorageException catch (e) {
      return left(Failure(msg: e.message));
    } on ServerExceptions catch (e) {
      return left(Failure(msg: e.msg));
    }
  }

  @override
  Future<Either<Failure, User>> updateUserName({
    required String userId,
    required String name,
  }) async {
    try {
      if (!await (internetConnectionChecker.isConnected)) {
        return left(Failure(msg: 'No Internet Connection'));
      }
      final user = await remoteDataSource.updateUserName(
        userId: userId,
        name: name,
      );
      return right(user);
    } on sb.AuthException catch (e) {
      return left(Failure(msg: e.message));
    } on ServerExceptions catch (e) {
      return left(Failure(msg: e.msg));
    }
  }

  Future<Either<Failure, User>> _getUser(Future<User> Function() fn) async {
    try {
      if (!await (internetConnectionChecker.isConnected)) {
        return left(Failure(msg: 'No Internet Connection'));
      }
      final user = await fn();

      return right(user);
    } on sb.AuthException catch (e) {
      return left(Failure(msg: e.message));
    } on ServerExceptions catch (e) {
      return left(Failure(msg: e.msg));
    }
  }
}
