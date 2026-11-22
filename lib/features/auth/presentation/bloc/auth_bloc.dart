import 'dart:io';

import 'package:blog_rivaan/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_rivaan/core/usecase/usecase.dart';
import 'package:blog_rivaan/core/common/entity/user.dart';
import 'package:blog_rivaan/features/auth/domain/usecases/current_user.dart';
import 'package:blog_rivaan/features/auth/domain/usecases/upload_profile_image.dart';
import 'package:blog_rivaan/features/auth/domain/usecases/user_log_in.dart';
import 'package:blog_rivaan/features/auth/domain/usecases/user_log_out.dart';
import 'package:blog_rivaan/features/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogIn _userLogIn;
  final CurrentUser _currentUser;
  final UserLogOut _userLogOut;
  final UploadProfileImage _uploadProfileImage;
  final AppUserCubit _appUserCubit;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogIn userLogIn,
    required CurrentUser currentUser,
    required UserLogOut userLogOut,
    required UploadProfileImage uploadProfileImage,
    required AppUserCubit appUserCubit,
  }) : _userSignUp = userSignUp,
       _userLogIn = userLogIn,
       _currentUser = currentUser,
       _userLogOut = userLogOut,
       _uploadProfileImage = uploadProfileImage,
       _appUserCubit = appUserCubit,
       super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogIn>(_onAuthLogIn);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
    on<AuthLogOut>(_onAuthLogOut);
    on<AuthUploadProfileImage>(_onUploadProfileImage);
  }

  void _onAuthLogOut(AuthLogOut event, Emitter<AuthState> emit) async {
    final res = await _userLogOut(NoParams());
    res.fold(
      (failure) => emit(AuthFailure(msg: failure.msg)),
      (_) {
        _appUserCubit.updateUser(null);
        emit(AuthInitial());
      },
    );
  }

  void _onUploadProfileImage(
    AuthUploadProfileImage event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _uploadProfileImage(
      UploadProfileImageParams(
        image: event.image,
        userId: event.userId,
      ),
    );

    res.fold(
      (failure) => emit(AuthFailure(msg: failure.msg)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _isUserLoggedIn(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _currentUser(NoParams());

    res.fold((l) => emit(AuthFailure(msg: l.msg)), (r) {
      _emitAuthSuccess(r, emit);
    });
  }

  void _onAuthLogIn(AuthLogIn event, Emitter<AuthState> emit) async {
    

    final res = await _userLogIn(
      UserLogInParams(email: event.email, password: event.password),
    );

    res.fold(
      (failure) => emit(AuthFailure(msg: failure.msg)),
      (success) => _emitAuthSuccess(success, emit),
    );
  }

  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    print("${event.email} ${event.password}");
    
    final res = await _userSignUp(
      UserSignUpPrams(
        email: event.email,
        password: event.password,
        name: event.name,
      ),
    );

    res.fold(
      (failure) => emit(AuthFailure(msg: failure.msg)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user: user));
  }
}
