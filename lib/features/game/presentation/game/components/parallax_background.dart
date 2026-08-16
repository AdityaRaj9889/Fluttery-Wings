import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../../../../core/enums/theme_type.dart';
import '../../../../../core/utils/helpers.dart';

/// Procedural parallax background - no heavy textures, optimized rendering.
/// Layers: sky gradient, clouds, distant hills/city.

class ParallaxBackground extends Component with HasGameRef {
  final GameThemeData theme;
  final Vector2 gameSize;

  late List<_Cloud> _clouds;
  late List<_Hill> _hills;
  double _offset = 0;

  ParallaxBackground({
    required this.theme,
    required this.gameSize,
  }) : super(priority: -10);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Generate clouds
    _clouds = List.generate(6, (i) {
      return _Cloud(
        x: GameHelpers.randomDouble(0, gameSize.x),
        y: GameHelpers.randomDouble(20, gameSize.y * 0.45),
        scale: GameHelpers.randomDouble(0.7, 1.5),
        speedFactor: GameHelpers.randomDouble(0.15, 0.35),
        opacity: GameHelpers.randomDouble(0.6, 0.95),
      );
    });

    // Generate hills
    _hills = List.generate(4, (i) {
      return _Hill(
        baseX: i * gameSize.x * 0.6,
        height: GameHelpers.randomDouble(40, 90),
        width: GameHelpers.randomDouble(180, 320),
        speedFactor: 0.08,
      );
    });
  }

  @override
  void update(double dt) {
    _offset += dt * 20; // base scroll

    for (final c in _clouds) {
      c.x -= dt * 18 * c.speedFactor;
      if (c.x < -100) {
        c.x = gameSize.x + 80;
        c.y = GameHelpers.randomDouble(20, gameSize.y * 0.45);
      }
    }

    for (final h in _hills) {
      h.baseX -= dt * 22 * h.speedFactor;
      if (h.baseX < -h.width) {
        h.baseX = gameSize.x + 20;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    final size = gameSize;
    // Sky gradient
    final skyRect = Rect.fromLTWH(0, 0, size.x, size.y);
    final skyGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [theme.skyTop, theme.skyBottom],
    ).createShader(skyRect);
    canvas.drawRect(skyRect, Paint()..shader = skyGradient);

    // Subtle vignette
    final vignette = RadialGradient(
      center: const Alignment(0, -0.2),
      radius: 1.2,
      colors: [Colors.transparent, Colors.black.withOpacity(0.18)],
    ).createShader(skyRect);
    canvas.drawRect(skyRect, Paint()..shader = vignette);

    // Hills / parallax layer
    for (final hill in _hills) {
      final hillPath = Path()
        ..moveTo(hill.baseX, size.y * 0.72)
        ..quadraticBezierTo(
            hill.baseX + hill.width * 0.5,
            size.y * 0.72 - hill.height,
            hill.baseX + hill.width,
            size.y * 0.72)
        ..lineTo(hill.baseX + hill.width, size.y)
        ..lineTo(hill.baseX, size.y)
        ..close();

      final hillColor = Color.lerp(theme.groundPrimary, theme.skyBottom, 0.55)!
          .withOpacity(0.35);
      canvas.drawPath(
          hillPath,
          Paint()
            ..color = hillColor
            ..style = PaintingStyle.fill);
    }

    // Clouds - soft circles clustered
    for (final cloud in _clouds) {
      final paint = Paint()
        ..color = theme.cloudColor.withOpacity(cloud.opacity * 0.9)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5);

      // Cloud as 3 overlapping circles for AAA puff
      final base = Offset(cloud.x, cloud.y);
      final s = cloud.scale;
      canvas.drawCircle(base, 18 * s, paint);
      canvas.drawCircle(base + Offset(22 * s, 4 * s), 14 * s, paint);
      canvas.drawCircle(base + Offset(-20 * s, 6 * s), 13 * s, paint);
      canvas.drawCircle(base + Offset(8 * s, -8 * s), 12 * s, paint);
    }

    // Theme specific decorations - minimal for performance
    if (theme.type == GameThemeType.night) {
      // Stars
      final starPaint = Paint()..color = Colors.white.withOpacity(0.8);
      // Pseudo random but deterministic positions based on offset for twinkle
      for (int i = 0; i < 35; i++) {
        final sx = (i * 74.3 + _offset * 0.05) % size.x;
        final sy = (i * 37.7) % (size.y * 0.55);
        final twinkle = (math.sin(_offset * 0.001 + i) * 0.3 + 0.7).clamp(0.2, 1.0);
        canvas.drawCircle(Offset(sx, sy), 1.2 * twinkle, starPaint..color = Colors.white.withOpacity(twinkle));
      }
    }

    if (theme.type == GameThemeType.cyber) {
      // subtle grid lines for cyber
      final gridPaint = Paint()
        ..color = theme.accent.withOpacity(0.07)
        ..strokeWidth = 1;
      for (double y = size.y * 0.15; y < size.y * 0.7; y += 28) {
        canvas.drawLine(Offset(0, y), Offset(size.x, y), gridPaint);
      }
    }
  }
}

class _Cloud {
  double x, y, scale, speedFactor, opacity;
  _Cloud({required this.x, required this.y, required this.scale, required this.speedFactor, required this.opacity});
}

class _Hill {
  double baseX, height, width, speedFactor;
  _Hill({required this.baseX, required this.height, required this.width, required this.speedFactor});
}
