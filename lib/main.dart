import 'package:blog_rivaan/core/theme/app_theme.dart';
import 'package:blog_rivaan/features/auth/presentation/pages/sign_up_page.dart';
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
      home: SignUpPage(),
    );
  }
}

