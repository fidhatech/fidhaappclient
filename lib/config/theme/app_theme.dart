import 'package:dating_app/config/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'app_color.dart';

class AppTheme {
  static ThemeData main = ThemeData(
    useMaterial3: true,

    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColor.primary,
      secondary: AppColor.secondary,

      surface: AppColor.secondary,
      onPrimary: AppColor.primaryText,
      onSecondary: AppColor.primaryText,

      onSurface: AppColor.primaryText,
      error: Colors.red,
      onError: Colors.white,
    ),

    textTheme: AppTextTheme.light,

    scaffoldBackgroundColor: Colors.transparent,
  );
}
