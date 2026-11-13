import 'package:blog_rivaan/core/error/exceptions.dart';
import 'package:blog_rivaan/core/error/failures.dart';
import 'package:blog_rivaan/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_rivaan/features/auth/data/model/user_model.dart';
import 'package:blog_rivaan/features/auth/domain/entity/user.dart';
import 'package:blog_rivaan/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, User>> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    // TODO: implement loginWithEmailAndPassword
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, User>> signupWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.signupWithEmailPassword(
        name: name,
        email: email,
        password: password,
      );

      return right(user);
    } on ServerExceptions catch (e) {
      return left(Failure(msg:e.msg));
    }
  }
}
