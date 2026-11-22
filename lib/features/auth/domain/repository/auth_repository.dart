import 'dart:io';

import 'package:blog_rivaan/core/error/failures.dart';
import 'package:blog_rivaan/core/common/entity/user.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> signupWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> currentUser();

  Future<Either<Failure, void>> logOut();

  Future<Either<Failure, User>> uploadProfileImage({
    required File image,
    required String userId,
  });

  Future<Either<Failure, User>> updateUserName({
    required String userId,
    required String name,
  });
}
