import 'dart:io';

import 'package:blog_rivaan/core/common/entity/user.dart';
import 'package:blog_rivaan/core/error/failures.dart';
import 'package:blog_rivaan/core/usecase/usecase.dart';
import 'package:blog_rivaan/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UploadProfileImage implements UseCase<User, UploadProfileImageParams> {
  final AuthRepository authRepository;
  UploadProfileImage(this.authRepository);

  @override
  Future<Either<Failure, User>> call(UploadProfileImageParams params) async {
    return await authRepository.uploadProfileImage(
      image: params.image,
      userId: params.userId,
    );
  }
}

class UploadProfileImageParams {
  final File image;
  final String userId;

  UploadProfileImageParams({
    required this.image,
    required this.userId,
  });
}
