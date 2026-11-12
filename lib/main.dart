import 'package:blog_rivaan/core/route/app_routes.dart';
import 'package:blog_rivaan/core/route/route_name.dart';
import 'package:blog_rivaan/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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

