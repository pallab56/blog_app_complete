part of 'init_dependencies.dart';

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
    ..registerFactory(() => UserLogOut(serviceLocator()))
    ..registerFactory(() => UploadProfileImage(serviceLocator()))
    ..registerFactory(() => UpdateUserName(serviceLocator()))
    //bloc
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userLogIn: serviceLocator(),
        currentUser: serviceLocator(),
        userLogOut: serviceLocator(),
        uploadProfileImage: serviceLocator(),
        updateUserName: serviceLocator(),
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
