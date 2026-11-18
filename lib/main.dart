import 'package:blog_rivaan/core/route/app_routes.dart';
import 'package:blog_rivaan/core/route/route_name.dart';
import 'package:blog_rivaan/core/theme/app_theme.dart';
import 'package:blog_rivaan/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_rivaan/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (_) => serviceLocator<AuthBloc>())],
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
      initialRoute: RouteName.login_page,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
