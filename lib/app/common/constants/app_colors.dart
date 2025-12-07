import 'package:flutter/material.dart';

class AppColors {
  static const Color yellowLight = Color(0xFFFFD84E);
  static const Color orangeLight = Color(0xFFFF9A3D);
  static const Color gold = Color(0xFFF9C94C);
  static const Color brownDark = Color(0xFF4B3621);
  static const Color brownLight = Color(0xFFF5EBDD);
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
}

class AppTheme {
  static ThemeData light = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.orangeLight,
      primary: AppColors.orangeLight,
      secondary: AppColors.yellowLight,
    ),
    timePickerTheme: TimePickerThemeData(
      backgroundColor: AppColors.white,
      hourMinuteTextColor: AppColors.orangeLight,
      dialHandColor: AppColors.orangeLight,
      entryModeIconColor: AppColors.orangeLight,
    ),
    primaryColor: AppColors.orangeLight,
    scaffoldBackgroundColor: AppColors.brownLight,
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        color: AppColors.brownDark, // lebih kontras di background coklat muda
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: TextStyle(
        fontSize: 18,
        color: AppColors.brownDark, // teks utama
      ),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColors.orangeLight,
      textTheme: ButtonTextTheme.primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.orangeLight,
        foregroundColor: AppColors.white,
      ),
    ),
  );
}
