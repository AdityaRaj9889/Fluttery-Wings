import 'package:flutter/material.dart';

/// AAA Premium Color System - Material 3 + Game Aesthetic.

class AppColors {
  AppColors._();

  // Primary - Electric Purple AAA games use
  static const Color primary = Color(0xFF6C5CE7);
  static const Color primaryLight = Color(0xFFA29BFE);
  static const Color primaryDark = Color(0xFF4A3FB5);
  static const Color primaryContainer = Color(0xFFE8E5FF);

  static const Color secondary = Color(0xFF00CEC9);
  static const Color secondaryLight = Color(0xFF81ECEC);
  static const Color secondaryDark = Color(0xFF00B894);

  static const Color tertiary = Color(0xFFFF6B6B);
  static const Color tertiaryLight = Color(0xFFFFA8A8);
  static const Color tertiaryDark = Color(0xFFD63031);

  // Game specific
  static const Color success = Color(0xFF00B894);
  static const Color warning = Color(0xFFFDCB6E);
  static const Color error = Color(0xFFD63031);
  static const Color info = Color(0xFF0984E3);

  // Neutrals - Dark premium theme
  static const Color background = Color(0xFF0A0E21);
  static const Color backgroundLight = Color(0xFF141A33);
  static const Color surface = Color(0xFF1E2442);
  static const Color surfaceVariant = Color(0xFF2A335C);
  static const Color surfaceBright = Color(0xFF353E6A);

  static const Color onBackground = Color(0xFFEEF0FF);
  static const Color onSurface = Color(0xFFDEE1F5);
  static const Color onSurfaceVariant = Color(0xFF9CA3C0);

  // Glass / Overlay
  static const Color glass = Color(0x1AFFFFFF);
  static const Color glassBorder = Color(0x33FFFFFF);
  static const Color scrim = Color(0x880A0E21);
  static const Color scrimSoft = Color(0x660A0E21);

  // Coin/Gold
  static const Color gold = Color(0xFFFFD700);
  static const Color goldDark = Color(0xFFFFA600);
  static const Color goldLight = Color(0xFFFFE68A);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, Color(0xFF8B7BF8)],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondary, secondaryDark],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gold, goldDark],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [background, backgroundLight, Color(0xFF1B1F3B)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x22FFFFFF), Color(0x0DFFFFFF)],
  );

  // Pipe - to be overridden by theme
  static const Color pipeDefault = Color(0xFF4CAF50);
  static const Color pipeDefaultDark = Color(0xFF388E3C);

  // Bird shadow
  static const Color shadow = Color(0x40000000);
}
