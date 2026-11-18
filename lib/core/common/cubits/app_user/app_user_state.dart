part of 'app_user_cubit.dart';

@immutable
sealed class AppUserState {}

final class AppUserInitial extends AppUserState {}

final class AppUserLoggeIn extends AppUserState {
  final User user;
  AppUserLoggeIn(this.user);
}

///core cannot depend on others deature
///other features can depend on core
