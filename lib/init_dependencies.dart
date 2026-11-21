import 'package:blog_rivaan/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_rivaan/core/network/connection_checker.dart';
import 'package:blog_rivaan/core/secrets/app_secrets.dart';
import 'package:blog_rivaan/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_rivaan/features/auth/data/repository/auth_repository_impl.dart';
import 'package:blog_rivaan/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_rivaan/features/auth/domain/usecases/current_user.dart';
import 'package:blog_rivaan/features/auth/domain/usecases/user_log_in.dart';
import 'package:blog_rivaan/features/auth/domain/usecases/user_sign_up.dart';
import 'package:blog_rivaan/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_rivaan/features/blog/data/datasources/blog_local_data_source.dart';
import 'package:blog_rivaan/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:blog_rivaan/features/blog/data/repository/blog_repository_impl.dart';
import 'package:blog_rivaan/features/blog/domain/repository/blog_repository.dart';
import 'package:blog_rivaan/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blog_rivaan/features/blog/domain/usecases/upload_blog.dart';
import 'package:blog_rivaan/features/blog/presentation/bloc/bloc/blog_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;
Future<void> initDependencies() async {
  _initAuth();
  _initBlog();
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  final blogsBox = Hive.isBoxOpen('blogs')
    ? Hive.box('blogs')
    : await Hive.openBox('blogs');
  serviceLocator.registerLazySingleton<Box>(() => blogsBox);
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    publishableKey: AppSecrets.supabasePubKey,
  );

  serviceLocator.registerLazySingleton(() => supabase.client);

  ///core
  serviceLocator.registerLazySingleton(() => AppUserCubit());
  serviceLocator.registerFactory(() => InternetConnection());
  serviceLocator.registerFactory<InternetConnectionChecker>(
    () => InternetConnectionCheckerImpl(internetConnection: serviceLocator()),
  );
}

void _initAuth() {
  serviceLocator
    // data sources
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(supabaseClient: serviceLocator()),
    )
    // repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: serviceLocator(),
        internetConnectionChecker: serviceLocator(),
      ),
    )
    //usecases
    ..registerFactory(() => UserSignUp(serviceLocator()))
    ..registerFactory(() => UserLogIn(authRepository: serviceLocator()))
    ..registerFactory(() => CurrentUser(serviceLocator()))
    //bloc
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userLogIn: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}

void _initBlog() {
  serviceLocator
    // data sources
    ..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(supabaseClient: serviceLocator()),
    )
    ..registerFactory<BlogLocalDataSource>(
      () => BlogLocalDataSourceImpl(box: serviceLocator()),
    )
    //repository
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(
        blogRemoteDataSource: serviceLocator(),
        blogLocalDataSource: serviceLocator(),
        internetConnectionChecker: serviceLocator(),
      ),
    )
    //use cases
    ..registerFactory(() => UploadBlog(blogRepository: serviceLocator()))
    ..registerFactory(() => GetAllBlogs(blogRepository: serviceLocator()))
    //bloc
    ..registerLazySingleton(
      () =>
          BlogBloc(uploadBLog: serviceLocator(), getAllBlogs: serviceLocator()),
    );
}
