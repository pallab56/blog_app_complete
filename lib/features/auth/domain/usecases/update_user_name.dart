import 'package:blog_rivaan/core/common/entity/user.dart';
import 'package:blog_rivaan/core/error/failures.dart';
import 'package:blog_rivaan/core/usecase/usecase.dart';
import 'package:blog_rivaan/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateUserName implements UseCase<User, UpdateUserNameParams> {
  final AuthRepository authRepository;
  UpdateUserName(this.authRepository);

  @override
  Future<Either<Failure, User>> call(UpdateUserNameParams params) async {
    return await authRepository.updateUserName(
      userId: params.userId,
      name: params.name,
    );
  }
}

class UpdateUserNameParams {
  final String userId;
  final String name;

  UpdateUserNameParams({
    required this.userId,
    required this.name,
  });
}
