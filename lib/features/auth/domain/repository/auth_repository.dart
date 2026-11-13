import 'package:blog_rivaan/core/error/failures.dart';
import 'package:blog_rivaan/features/auth/domain/entity/user.dart';
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
}
