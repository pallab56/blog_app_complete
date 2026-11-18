import 'package:blog_rivaan/core/secrets/app_secrets.dart';
import 'package:blog_rivaan/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_rivaan/features/auth/data/repository/auth_repository_impl.dart';
import 'package:blog_rivaan/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_rivaan/features/auth/domain/usecases/current_user.dart';
import 'package:blog_rivaan/features/auth/domain/usecases/user_log_in.dart';
import 'package:blog_rivaan/features/auth/domain/usecases/user_sign_up.dart';
import 'package:blog_rivaan/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;
Future<void> initDependencies() async {
  _initAuth();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    publishableKey: AppSecrets.supabasePubKey,
  );

  serviceLocator.registerLazySingleton(() => supabase.client);
}

void _initAuth() {
  serviceLocator
  
  // data sources
  ..registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(supabaseClient: serviceLocator()),
  )
  // repository
  ..registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: serviceLocator()),
  ) 
  //usecases
  ..registerFactory(() => UserSignUp(serviceLocator()))
  
  ..registerFactory(() => UserLogIn(authRepository:serviceLocator()))

  ..registerFactory(() => CurrentUser(serviceLocator()))
  //bloc
  ..registerLazySingleton(
    () => AuthBloc(userSignUp: serviceLocator(),userLogIn: serviceLocator(),currentUser: serviceLocator()),
  );
}
