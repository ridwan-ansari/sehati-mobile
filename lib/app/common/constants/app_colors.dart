import 'package:flutter/material.dart';

class AppColors {
  static const Color yellowLight = Color(0xFFFFD84E);
  static const Color orangeLight = Color(0xFFFF9A3D);
  static const Color gold = Color(0xFFF9C94C);
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
}

class AppTheme {
  static ThemeData light = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.orangeLight),
    timePickerTheme: TimePickerThemeData(
      backgroundColor: Colors.white,
      hourMinuteTextColor: AppColors.orangeLight,
      dialHandColor: AppColors.orangeLight,
      entryModeIconColor: AppColors.orangeLight,
    ),
    primaryColor: AppColors.orangeLight,
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        color: AppColors.black,
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: TextStyle(fontSize: 18, color: AppColors.white),
    ),
  );
}
