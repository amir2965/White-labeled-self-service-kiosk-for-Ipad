import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Clean typography with strong hierarchy
class AppTypography {
  AppTypography._();

  // Font family: Inter for clean, modern look
  static TextTheme get textTheme => GoogleFonts.interTextTheme();

  // Display styles (large headers)
  static TextStyle display1 = GoogleFonts.inter(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static TextStyle display2 = GoogleFonts.inter(
    fontSize: 40,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  // Heading styles
  static TextStyle h1 = GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 1.25,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
  );

  static TextStyle h2 = GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.textPrimary,
    letterSpacing: -0.2,
  );

  static TextStyle h3 = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  static TextStyle h4 = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  // Body text
  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  // Button text
  static TextStyle buttonLarge = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.1,
  );

  static TextStyle buttonMedium = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.1,
  );

  static TextStyle buttonSmall = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.1,
  );

  // Labels & captions
  static TextStyle label = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  static TextStyle caption = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.3,
    color: AppColors.textTertiary,
  );

  // Price/number display
  static TextStyle price = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: AppColors.textPrimary,
    letterSpacing: -0.2,
  );

  static TextStyle priceLarge = GoogleFonts.inter(
    fontSize: 40,
    fontWeight: FontWeight.w700,
    height: 1.1,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );
}
