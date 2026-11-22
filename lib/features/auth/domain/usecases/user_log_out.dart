import 'package:blog_rivaan/core/error/failures.dart';
import 'package:blog_rivaan/core/usecase/usecase.dart';
import 'package:blog_rivaan/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserLogOut implements UseCase<void, NoParams> {
  final AuthRepository authRepository;
  UserLogOut(this.authRepository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await authRepository.logOut();
  }
}
