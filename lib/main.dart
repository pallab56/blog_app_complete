import 'package:blog_rivaan/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_rivaan/core/route/app_routes.dart';
import 'package:blog_rivaan/core/theme/app_theme.dart';
import 'package:blog_rivaan/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_rivaan/features/auth/presentation/pages/log_in_page.dart';
import 'package:blog_rivaan/features/blog/presentation/pages/blog_pages.dart';
import 'package:blog_rivaan/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<AppUserCubit>()),
        BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blog_App',
      theme: AppTheme.darkThemeMode,
      home: BlocSelector<AppUserCubit, AppUserState, bool>(
        selector: (state) {
          return state is AppUserLoggeIn;
        },
        builder: (context, isloggedIn) {
          if (isloggedIn) {
            return BlogPage();
          }
          return LogInPage();
        },
      ),
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
