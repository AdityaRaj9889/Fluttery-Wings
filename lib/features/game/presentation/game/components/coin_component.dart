import 'dart:math' as math;
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_constants.dart';

class CoinComponent extends PositionComponent with CollisionCallbacks {
  final double worldSpeed;
  double _bobTimer = 0;
  double _baseY;
  bool collected = false;

  CoinComponent({
    required Vector2 initialPosition,
    required this.worldSpeed,
  })  : _baseY = initialPosition.y,
        super(
          position: initialPosition,
          size: Vector2.all(AppConstants.coinSize),
          anchor: Anchor.center,
          priority: 5,
        );

  bool get isOffScreen => position.x < -size.x - 20;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // FIX: Passive + isSolid false so it NEVER triggers game over via collision callback
    // We use manual distance check for collection (more reliable)
    add(CircleHitbox(
      radius: size.x * 0.45,
      anchor: Anchor.center,
      position: size / 2,
      collisionType: CollisionType.passive,
      isSolid: false,
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (collected) return;
    position.x -= worldSpeed * dt;
    _bobTimer += dt * 3.2;
    position.y = _baseY + math.sin(_bobTimer) * 6;

    // Rotate scale for 3D effect
    final scaleX = (math.sin(_bobTimer * 1.6).abs() * 0.4 + 0.6);
    scale = Vector2(scaleX, 1);
  }

  void collect() {
    if (collected) return;
    collected = true;
    // Animate out - will be removed by game
  }

  @override
  void render(Canvas canvas) {
    if (collected) return;
    final center = Offset(size.x / 2, size.y / 2);
    final radius = size.x / 2;

    // Outer glow
    final glowPaint = Paint()
      ..color = const Color(0xFFFFD700).withOpacity(0.35)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(center, radius + 4, glowPaint);

    // Shadow
    canvas.drawCircle(
      center + const Offset(1.5, 2),
      radius,
      Paint()..color = Colors.black.withOpacity(0.22),
    );

    // Gold gradient coin face
    final goldGradient = RadialGradient(
      center: const Alignment(-0.3, -0.4),
      colors: [
        const Color(0xFFFFF3A0),
        const Color(0xFFFFD700),
        const Color(0xFFFFA600),
      ],
      stops: const [0.0, 0.55, 1.0],
    ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, Paint()..shader = goldGradient);

    // Inner ring
    canvas.drawCircle(
      center,
      radius * 0.72,
      Paint()
        ..color = const Color(0xFF7A4A00).withOpacity(0.22)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    // $ / star icon
    final textPainter = TextPainter(
      text: TextSpan(
        text: '\$',
        style: TextStyle(
          fontSize: radius * 0.9,
          fontWeight: FontWeight.w900,
          color: const Color(0xFF7A4A00),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
        canvas, center - Offset(textPainter.width / 2, textPainter.height / 2));

    // Highlight
    canvas.drawCircle(
      center + Offset(-radius * 0.2, -radius * 0.22),
      radius * 0.18,
      Paint()..color = Colors.white.withOpacity(0.5),
    );
  }
}
