import 'package:blog_rivaan/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static border([Color color = AppPallete.borderColor]) => OutlineInputBorder(
    borderSide: BorderSide(color: color, width: 3),
    borderRadius: BorderRadius.circular(10),
  );
  static final darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppPallete.backgroundColor,

    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.all(15),
      enabledBorder: border(),
      focusedBorder: border(AppPallete.gradient2),
    ),
  );
}
