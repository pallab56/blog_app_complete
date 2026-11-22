part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class AuthSignUp extends AuthEvent {
  final String email;
  final String password;
  final String name;

  AuthSignUp({required this.email, required this.password, required this.name});
}

class AuthLogIn extends AuthEvent {
  final String email;
  final String password;

  AuthLogIn({required this.email, required this.password});
}

class AuthIsUserLoggedIn extends AuthEvent {}

class AuthLogOut extends AuthEvent {}

class AuthUploadProfileImage extends AuthEvent {
  final File image;
  final String userId;

  AuthUploadProfileImage({
    required this.image,
    required this.userId,
  });
}

class AuthUpdateUserName extends AuthEvent {
  final String userId;
  final String name;

  AuthUpdateUserName({
    required this.userId,
    required this.name,
  });
}