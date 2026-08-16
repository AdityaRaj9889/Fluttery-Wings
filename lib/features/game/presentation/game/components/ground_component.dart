import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/enums/theme_type.dart';

/// Infinite scrolling ground with collision.

class GroundComponent extends PositionComponent with CollisionCallbacks {
  final GameThemeData theme;
  double _worldSpeed;
  double _scrollOffset = 0;

  GroundComponent({
    required Vector2 size,
    required Vector2 position,
    required this.theme,
    required double worldSpeed,
  })  : _worldSpeed = worldSpeed,
        super(size: size, position: position, anchor: Anchor.topLeft, priority: 8);

  void updateSpeed(double newSpeed) {
    _worldSpeed = newSpeed;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox(
      size: size,
      position: Vector2.zero(),
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    _scrollOffset = (_scrollOffset + _worldSpeed * dt) % 40;
  }

  @override
  void render(Canvas canvas) {
    // Base
    final baseRect = Rect.fromLTWH(0, 0, size.x, size.y);
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        theme.groundPrimary,
        theme.groundSecondary,
      ],
    ).createShader(baseRect);
    canvas.drawRect(baseRect, Paint()..shader = gradient);

    // Top highlight strip - grass edge
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, 10),
      Paint()
        ..color = Color.lerp(theme.groundPrimary, Colors.white, 0.22)!
        ..style = PaintingStyle.fill,
    );

    // Bottom shadow
    canvas.drawRect(
      Rect.fromLTWH(0, size.y - 6, size.x, 6),
      Paint()..color = Colors.black.withOpacity(0.18),
    );

    // Pattern - scrolling tiles
    final patternPaint = Paint()
      ..color = Colors.black.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Vertical lines
    for (double x = -_scrollOffset; x < size.x; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.y), patternPaint);
    }

    // Dots / texture
    final dotPaint = Paint()..color = Colors.white.withOpacity(0.08);
    for (double x = -_scrollOffset; x < size.x; x += 40) {
      for (double y = 14; y < size.y; y += 22) {
        canvas.drawCircle(Offset(x + 18, y), 2.2, dotPaint);
      }
    }

    // Top edge shine
    canvas.drawLine(
      Offset(0, 0.5),
      Offset(size.x, 0.5),
      Paint()
        ..color = Colors.white.withOpacity(0.25)
        ..strokeWidth = 1,
    );
  }
}
