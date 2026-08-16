import 'dart:math' as math;
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/enums/theme_type.dart';
import '../../../../../core/utils/helpers.dart';

enum PipePosition { top, bottom }

/// Premium pipe pair with procedural visuals and pooling support.
/// Spawns as a pair (top + bottom) but managed as one logical entity for scoring.

class PipePair extends PositionComponent with HasGameRef {
  final double gap;
  final GameThemeData themeData;
  final double gameHeight;
  final double? overrideTopHeight; // FIX: allow coin to align with actual gap

  bool hasScored = false;
  double _worldSpeed;
  late double _actualTopHeight;

  double get actualTopHeight => _actualTopHeight;
  double get gapCenterY => _actualTopHeight + gap / 2;

  PipePair({
    required Vector2 initialPosition,
    required this.gap,
    required this.themeData,
    required this.gameHeight,
    required double worldSpeed,
    this.overrideTopHeight,
    super.size,
  })  : _worldSpeed = worldSpeed,
        super(position: initialPosition, anchor: Anchor.topLeft);

  double get right => position.x + AppConstants.pipeWidth;
  bool get isOffScreen => right < -20;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    size = Vector2(AppConstants.pipeWidth,
        gameHeight); // full height for collision grouping

    // Create top and bottom pipes as children
    final topHeight = overrideTopHeight ?? _randomTopHeight();
    _actualTopHeight = topHeight;

    // Top Pipe
    final topPipe = SinglePipe(
      position: Vector2(0, 0),
      size: Vector2(AppConstants.pipeWidth, topHeight),
      isTop: true,
      theme: themeData,
    );
    add(topPipe);

    // Bottom Pipe
    final bottomY = topHeight + gap;
    final bottomHeight = gameHeight - bottomY;
    final bottomPipe = SinglePipe(
      position: Vector2(0, bottomY),
      size: Vector2(AppConstants.pipeWidth, bottomHeight),
      isTop: false,
      theme: themeData,
    );
    add(bottomPipe);
  }

  double _randomTopHeight() {
    final minH = AppConstants.pipeMinHeight;
    final maxH = gameHeight -
        AppConstants.groundHeight -
        gap -
        AppConstants.pipeMinHeight;
    return GameHelpers.randomDouble(minH, maxH.clamp(minH + 10, gameHeight));
  }

  void updateSpeed(double newSpeed) {
    _worldSpeed = newSpeed;
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= _worldSpeed * dt;
  }
}

class SinglePipe extends PositionComponent with CollisionCallbacks {
  final bool isTop;
  final GameThemeData theme;

  SinglePipe({
    required super.position,
    required super.size,
    required this.isTop,
    required this.theme,
  }) : super(anchor: Anchor.topLeft);

  late ShapeHitbox hitbox;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    hitbox = RectangleHitbox(
      size: size,
      position: Vector2.zero(),
    )..collisionType = CollisionType.passive;
    add(hitbox);

    priority = 2;
  }

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);

    // Main gradient body
    final gradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        theme.pipePrimary,
        Color.lerp(theme.pipePrimary, theme.pipeSecondary, 0.5)!,
        theme.pipeSecondary,
      ],
      stops: const [0.0, 0.5, 1.0],
    ).createShader(rect);

    final paint = Paint()..shader = gradient;

    final rRect = RRect.fromRectAndCorners(
      rect,
      topLeft: isTop ? Radius.zero : const Radius.circular(8),
      topRight: isTop ? Radius.zero : const Radius.circular(8),
      bottomLeft: isTop ? const Radius.circular(8) : Radius.zero,
      bottomRight: isTop ? const Radius.circular(8) : Radius.zero,
    );

    canvas.drawRRect(rRect, paint);

    // Highlight edge - AAA bevel
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawLine(Offset(4, 0), Offset(4, size.y), highlightPaint);

    // Shadow edge
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawLine(
        Offset(size.x - 3, 0), Offset(size.x - 3, size.y), shadowPaint);

    // Cap - the wider rim
    final capHeight = 28.0;
    final capOverhang = 6.0;
    final capRect = isTop
        ? Rect.fromLTWH(-capOverhang, size.y - capHeight,
            size.x + capOverhang * 2, capHeight)
        : Rect.fromLTWH(-capOverhang, 0, size.x + capOverhang * 2, capHeight);

    final capGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        theme.pipePrimary,
        theme.pipeSecondary,
      ],
    ).createShader(capRect);

    canvas.drawRRect(
      RRect.fromRectAndRadius(capRect, const Radius.circular(6)),
      Paint()..shader = capGradient,
    );

    // Inner highlight on cap
    canvas.drawRRect(
      RRect.fromRectAndRadius(capRect.deflate(1.5), const Radius.circular(5)),
      Paint()
        ..color = Colors.white.withOpacity(0.12)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    // Decorative bolts for premium look
    if (size.y > 80) {
      final boltPaint = Paint()..color = Colors.black.withOpacity(0.18);
      final boltCount = (size.y / 45).floor().clamp(2, 6);
      for (int i = 0; i < boltCount; i++) {
        final y =
            isTop ? size.y - capHeight - 12 - i * 42 : capHeight + 12 + i * 42;
        if (y < 8 || y > size.y - 8) continue;
        canvas.drawCircle(Offset(12, y.toDouble()), 3, boltPaint);
        canvas.drawCircle(Offset(size.x - 12, y.toDouble()), 3, boltPaint);
        // bolt highlight
        canvas.drawCircle(Offset(11, (y - 1).toDouble()), 1,
            Paint()..color = Colors.white.withOpacity(0.24));
      }
    }
  }
}
