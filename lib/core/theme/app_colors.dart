import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF18457C);
  static const Color secondary = Color(0xFF009DDB);

  static const Color amber = Color(0xFFFFA726);
  static const Color amberDeep = Color(0xFFF57C00);
  static const Color sky = Color(0xFF00C2D1);
  static const Color dusk = Color(0xFF0B1220);

  static const Color background = Color(0xFFF1F4F9);
  static const Color card = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFE7EAF2);

  static const Color textPrimary = Color(0xFF10172A);
  static const Color textSecondary = Color(0xFF80879A);
  static const Color textOnDark = Color(0xFFEDEFF5);

  static const Color ledBackground = Color(0xFF0B1220);
  static const Color ledText = Color(0xFFFFB300);

  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);

  static const List<Color> headerGradient = [primary, secondary];
  static const List<Color> statusGradient = [
    Color(0xFF10305A),
    primary,
    secondary,
  ];
  static const List<Color> amberGradient = [Color(0xFFFFC24B), amberDeep];
  static const List<Color> heroButtonGradient = [secondary, primary];
}
