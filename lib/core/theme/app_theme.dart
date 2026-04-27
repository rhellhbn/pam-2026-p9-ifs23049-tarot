import 'package:flutter/material.dart';

class AppColors {
  // Mystical deep space palette
  static const deepVoid = Color(0xFF0A0612);
  static const cosmicPurple = Color(0xFF1A0A2E);
  static const nebulaPurple = Color(0xFF2D1B69);
  static const mysticIndigo = Color(0xFF4A2C8A);
  static const astraMauve = Color(0xFF7B5EA7);
  static const stardustPink = Color(0xFFD4A5FF);
  static const moonGlow = Color(0xFFF0E6FF);
  static const goldAccent = Color(0xFFFFD700);
  static const roseGold = Color(0xFFE8A87C);

  // Energy colors
  static const positive = Color(0xFF52D9A4);
  static const challenging = Color(0xFFFF6B6B);
  static const neutral = Color(0xFF89B4FA);
  static const transformative = Color(0xFFFFD700);

  // Card suit colors
  static const wands = Color(0xFFFF8C42);
  static const cups = Color(0xFF4ECDC4);
  static const swords = Color(0xFF89B4FA);
  static const pentacles = Color(0xFF52D9A4);
  static const major = Color(0xFFFFD700);
}

class AppTheme {
  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.deepVoid,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.stardustPink,
      secondary: AppColors.astraMauve,
      surface: AppColors.cosmicPurple,
    ),
    fontFamily: 'serif',
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.stardustPink,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.nebulaPurple.withValues(alpha: 0.3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.astraMauve),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.astraMauve.withValues(alpha: 0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.stardustPink, width: 2),
      ),
      labelStyle: const TextStyle(color: AppColors.astraMauve),
      hintStyle: TextStyle(color: AppColors.astraMauve.withValues(alpha: 0.6)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.mysticIndigo,
        foregroundColor: AppColors.moonGlow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.cosmicPurple,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      shadowColor: AppColors.nebulaPurple.withValues(alpha: 0.5),
    ),
  );
}
