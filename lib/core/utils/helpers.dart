import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

/// Game helpers and math utilities.

class GameHelpers {
  GameHelpers._();

  static final math.Random random = math.Random();

  static double lerp(double a, double b, double t) => a + (b - a) * t;

  static double clampDouble(double v, double min, double max) =>
      v < min ? min : (v > max ? max : v);

  static double randomDouble(double min, double max) =>
      min + random.nextDouble() * (max - min);

  static int randomInt(int min, int max) => min + random.nextInt(max - min + 1);

  static bool chance(double probability) => random.nextDouble() < probability;

  static double mapRange(
      double value, double inMin, double inMax, double outMin, double outMax) {
    return outMin + (outMax - outMin) * ((value - inMin) / (inMax - inMin));
  }

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static bool isYesterday(DateTime last, DateTime now) {
    final yesterday = now.subtract(const Duration(days: 1));
    return isSameDay(last, yesterday);
  }

  static ColorsHSL shiftHSL(Color color,
      {double hue = 0, double sat = 0, double light = 0}) {
    final hsl = HSLColor.fromColor(color);
    return ColorsHSL(
      hsl: hsl
          .withHue((hsl.hue + hue) % 360)
          .withSaturation((hsl.saturation + sat).clamp(0, 1))
          .withLightness((hsl.lightness + light).clamp(0, 1)),
    );
  }
}

class ColorsHSL {
  final HSLColor hsl;
  ColorsHSL({required this.hsl});
  Color get color => hsl.toColor();
}

extension IntFormatting on int {
  String get formatted {
    if (this >= 1000000) return '${(this / 1000000).toStringAsFixed(1)}M';
    if (this >= 1000) return '${(this / 1000).toStringAsFixed(1)}K';
    return toString();
  }
}
