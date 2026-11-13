import 'package:blog_rivaan/core/error/failures.dart';
import 'package:blog_rivaan/core/usecase/usecase.dart';
import 'package:blog_rivaan/features/auth/domain/entity/user.dart';
import 'package:blog_rivaan/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';


class UserLogIn implements UseCase<User, UserLogInParams> {
  final AuthRepository authRepository;

  const UserLogIn({required this.authRepository});

  @override
  Future<Either<Failure, User>> call(UserLogInParams params) {
    return authRepository.loginWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );
  }

 
}

class UserLogInParams {
  final String email;
  final String password;

  UserLogInParams({required this.email, required this.password});
}
