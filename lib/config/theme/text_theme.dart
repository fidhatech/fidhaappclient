import 'package:dating_app/config/theme/app_color.dart';
import 'package:flutter/material.dart';

class AppTextTheme {
  static TextTheme light = const TextTheme(
    headlineLarge: TextStyle(
      fontFamily: 'Inter',
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AppColor.primaryText,
    ),

    bodyMedium: TextStyle(fontSize: 14),
  );

  static TextTheme dark = const TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AppColor.secondaryText,
    ),
    bodyMedium: TextStyle(fontSize: 14),
  );
}
