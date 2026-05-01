import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF007AFF);
  static const secondary = Color(0xFF6C757D);
  static const success = Color(0xFF28A745);
  static const gray = Color(0xFF6C757D);
  static const grayLight = Color(0xFFEFEFEF);
  static const white = Color(0xFFFFFFFF);
  static const danger = Color(0xFFFF3B30);
  static const background = Color(0xFFF8F9FA);
}

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 40;
}

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.gray,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),
        useMaterial3: true,
      );
}
