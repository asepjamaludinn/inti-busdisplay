import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.card,
        error: AppColors.danger,
      ),
      textTheme: GoogleFonts.dmSansTextTheme(),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
    );
  }

  static BoxDecoration get cardDecoration => BoxDecoration(
    color: AppColors.card,
    borderRadius: BorderRadius.circular(28),
    boxShadow: [
      BoxShadow(
        color: AppColors.textPrimary.withValues(alpha: 0.04),
        blurRadius: 32,
        spreadRadius: 0,
        offset: const Offset(0, 12),
      ),
    ],
  );

  static BoxDecoration coloredCardDecoration(
    Color color, {
    double radius = 28,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: color.withValues(alpha: 0.25),
          blurRadius: 28,
          spreadRadius: -4,
          offset: const Offset(0, 12),
        ),
      ],
    );
  }

  static BoxDecoration gradientCardDecoration(
    List<Color> colors, {
    double radius = 28,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: colors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: colors.last.withValues(alpha: 0.25),
          blurRadius: 28,
          spreadRadius: -4,
          offset: const Offset(0, 12),
        ),
      ],
    );
  }
}
