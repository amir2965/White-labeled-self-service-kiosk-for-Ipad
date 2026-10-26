import 'package:flutter/material.dart';

/// Minimal color palette: Black, Blue, White
class AppColors {
  AppColors._();

  // Primary Colors
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color blue = Color(0xFF007AFF); // iOS-style blue

  // Grays
  static const Color gray50 = Color(0xFFFAFAFA);
  static const Color gray100 = Color(0xFFF5F5F5);
  static const Color gray200 = Color(0xFFEEEEEE);
  static const Color gray300 = Color(0xFFE0E0E0);
  static const Color gray400 = Color(0xFFBDBDBD);
  static const Color gray500 = Color(0xFF9E9E9E);
  static const Color gray600 = Color(0xFF757575);
  static const Color gray700 = Color(0xFF616161);
  static const Color gray800 = Color(0xFF424242);
  static const Color gray900 = Color(0xFF212121);

  // Transparent
  static const Color transparent = Color(0x00000000);

  // Functional Colors
  static const Color success = Color(0xFF34C759);
  static const Color error = Color(0xFFFF3B30);
  static const Color warning = Color(0xFFFF9500);
  static const Color info = Color(0xFF007AFF);

  // Background & Surface
  static const Color background = white;
  static const Color surface = white;
  static const Color surfaceElevated = gray50;

  // Text
  static const Color textPrimary = black;
  static const Color textSecondary = gray700;
  static const Color textTertiary = gray500;
  static const Color textOnDark = white;

  // Borders & Dividers
  static const Color border = gray300;
  static const Color divider = gray200;

  // Interactive States
  static const Color hover = gray100;
  static const Color pressed = gray200;
  static const Color disabled = gray300;
  static const Color disabledText = gray400;
}
