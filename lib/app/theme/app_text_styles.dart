import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Premium Typography System - OFFLINE SAFE, no google_fonts network fetch.
/// Uses system fonts with AAA weights to prevent crash when offline (fixes your log).

class AppTextStyles {
  AppTextStyles._();

  // Base - system font, no network call
  static const TextStyle _base = TextStyle(
    fontFamily: 'Roboto',
    fontFamilyFallback: ['SF Pro', 'Inter', 'system-ui'],
    package: null,
  );

  // static TextStyle get _base => GoogleFonts.poppins();

  static TextStyle get displayLarge => _base.copyWith(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
        color: AppColors.onBackground,
        height: 1.1,
      );

  static TextStyle get displayMedium => _base.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        color: AppColors.onBackground,
        height: 1.15,
      );

  static TextStyle get displaySmall => _base.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.onBackground,
        height: 1.2,
      );

  static TextStyle get headlineLarge => _base.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.onBackground,
      );

  static TextStyle get headlineMedium => _base.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.onBackground,
      );

  static TextStyle get titleLarge => _base.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.onBackground,
      );

  static TextStyle get titleMedium => _base.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface,
      );

  static TextStyle get bodyLarge => _base.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.onSurface,
        height: 1.5,
      );

  static TextStyle get bodyMedium => _base.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.onSurfaceVariant,
        height: 1.5,
      );

  static TextStyle get bodySmall => _base.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.onSurfaceVariant,
        height: 1.4,
      );

  static TextStyle get caption => _base.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: AppColors.onSurfaceVariant,
      );

  static TextStyle get button => _base.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
        color: Colors.white,
      );

  // Score - heavy, no GoogleFonts, offline safe
  static TextStyle get score => _base.copyWith(
        fontSize: 72,
        fontWeight: FontWeight.w800,
        color: Colors.white,
        letterSpacing: 1,
        shadows: [
          const Shadow(
              color: Colors.black54, offset: Offset(0, 4), blurRadius: 8),
        ],
      );

  static TextStyle get coin => _base.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      );

  static TextStyle get gameOver => _base.copyWith(
        fontSize: 42,
        fontWeight: FontWeight.w900,
        color: Colors.white,
        letterSpacing: 1,
      );

  static TextStyle get labelSmall => _base.copyWith(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: AppColors.onSurfaceVariant,
      );
}
