import 'dart:math' as math;
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/enums/character_type.dart';

/// High-performance bird with physics, rotation, collisions.

class BirdComponent extends PositionComponent
    with CollisionCallbacks, HasGameRef {
  final CharacterData character;
  final void Function(PositionComponent other)? onCollided;

  BirdComponent({
    required this.character,
    this.onCollided,
    required Vector2 initialPosition,
  }) : super(
          position: initialPosition,
          size: Vector2.all(AppConstants.birdRadius * 2),
          anchor: Anchor.center,
          priority: 10,
        );

  // Physics
  double _velocityY = 0;
  double _rotation = 0;
  bool _isDead = false;
  bool _isPlaying = false; // FIX: prevents auto-fall on ready screen
  double _wingFlapTimer = 0;
  bool _wingUp = false;
  double _hoverTimer = 0;
  late Vector2 _initialPos;

  bool get isDead => _isDead;
  double get velocityY => _velocityY;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _initialPos = position.clone();

    // Collision shape - tighter for premium feel
    add(CircleHitbox(
      radius: AppConstants.birdRadius * 0.78,
      anchor: Anchor.center,
      position: size / 2,
      collisionType: CollisionType.active,
    ));

    // Pre-cache
    _velocityY = 0;
  }

  void setPlaying(bool playing) {
    _isPlaying = playing;
    if (playing) _hoverTimer = 0;
  }

  void setHoverAtCurrentPos() {
    _initialPos = position.clone();
    _isPlaying = false;
    _hoverTimer = 0;
  }

  void flap() {
    if (_isDead) return;
    if (!_isPlaying)
      return; // Don't flap in ready state, game will handle start
    _velocityY = AppConstants.flapImpulse * character.flapBoost;
    _wingUp = true;
    _wingFlapTimer = 0;
  }

  void die() {
    if (_isDead) return;
    _isDead = true;
    _isPlaying = false;
  }

  void reset(Vector2 newPos) {
    position = newPos;
    _initialPos = newPos.clone();
    _velocityY = 0;
    _rotation = 0;
    _isDead = false;
    _isPlaying = false;
    _hoverTimer = 0;
    angle = 0;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_isDead) {
      // Still fall when dead
      _velocityY += AppConstants.gravity * dt * character.gravityModifier;
      _velocityY = math.min(_velocityY, AppConstants.maxFallVelocity * 1.2);
      position.y += _velocityY * dt;
      // Rotate down fast
      angle = lerpDouble(angle, AppConstants.maxDownRotation, dt * 6) ?? angle;
      return;
    }

    if (!_isPlaying) {
      // READY STATE - Hover, no gravity, no game over
      _hoverTimer += dt * 2.2;
      position.y = _initialPos.y + math.sin(_hoverTimer) * 8;
      angle = math.sin(_hoverTimer * 0.9) * 0.12;
      // Wing flap slowly
      _wingFlapTimer += dt * 6;
      if (_wingFlapTimer > math.pi) {
        _wingFlapTimer = 0;
        _wingUp = !_wingUp;
      }
      return;
    }

    // PLAYING PHYSICS
    _velocityY += AppConstants.gravity * dt * character.gravityModifier;
    _velocityY = math.min(_velocityY, AppConstants.maxFallVelocity);
    position.y += _velocityY * dt;

    // Rotation based on velocity
    final targetRot = _velocityY < 0
        ? AppConstants.maxUpRotation
        : AppConstants.maxDownRotation *
            (_velocityY / AppConstants.maxFallVelocity).clamp(0, 1);
    _rotation = lerpDouble(
            _rotation, targetRot, dt * AppConstants.rotationLerpFactor) ??
        _rotation;
    angle = _rotation;

    // Wing animation
    _wingFlapTimer += dt * (_velocityY < 0 ? 18 : 8);
    if (_wingFlapTimer > math.pi) {
      _wingFlapTimer = 0;
      _wingUp = !_wingUp;
    }
  }

  @override
  void render(Canvas canvas) {
    // Premium procedurally drawn bird - looks AAA without external assets
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    canvas.save();
    canvas.translate(size.x / 2, size.y / 2);

    // Shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.22)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(Offset(2, size.y * 0.28), size.x * 0.42, shadowPaint);

    // Body gradient
    final bodyPath = Path()
      ..addOval(Rect.fromCenter(
          center: Offset.zero, width: size.x * 0.95, height: size.y * 0.75));
    final bodyGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [character.primaryColor, character.secondaryColor],
    ).createShader(Rect.fromLTWH(-size.x / 2, -size.y / 2, size.x, size.y));
    canvas.drawPath(bodyPath, Paint()..shader = bodyGradient);

    // Belly
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(0, size.y * 0.1),
          width: size.x * 0.55,
          height: size.y * 0.48),
      Paint()..color = Colors.white.withOpacity(0.92),
    );

    // Wing
    final wingOffset = _wingUp ? -size.y * 0.08 : size.y * 0.06;
    final wingPath = Path()
      ..moveTo(-size.x * 0.1, wingOffset)
      ..quadraticBezierTo(-size.x * 0.05, wingOffset - size.y * 0.18,
          size.x * 0.15, wingOffset - size.y * 0.05)
      ..quadraticBezierTo(
          size.x * 0.05, wingOffset + size.y * 0.22, -size.x * 0.1, wingOffset);
    canvas.drawPath(
      wingPath,
      Paint()
        ..color = character.primaryColor
            .withBlue((character.primaryColor.blue * 0.8).toInt())
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      wingPath,
      Paint()
        ..color = Colors.black.withOpacity(0.1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    // Eye white
    canvas.drawCircle(
      Offset(size.x * 0.18, -size.y * 0.12),
      size.x * 0.16,
      Paint()..color = Colors.white,
    );
    // Pupil - looks at direction
    final pupilShift =
        (_velocityY / AppConstants.maxFallVelocity).clamp(-0.5, 0.8) * 3;
    canvas.drawCircle(
      Offset(size.x * 0.22, -size.y * 0.08 + pupilShift),
      size.x * 0.07,
      Paint()..color = const Color(0xFF1A1A2E),
    );
    // Highlight
    canvas.drawCircle(
      Offset(size.x * 0.24, -size.y * 0.14 + pupilShift),
      size.x * 0.025,
      Paint()..color = Colors.white,
    );

    // Beak
    final beakPath = Path()
      ..moveTo(size.x * 0.35, -size.y * 0.05)
      ..lineTo(size.x * 0.58, 0)
      ..lineTo(size.x * 0.35, size.y * 0.08)
      ..close();
    canvas.drawPath(
      beakPath,
      Paint()
        ..shader =
            const LinearGradient(colors: [Color(0xFFFFD700), Color(0xFFFF8C00)])
                .createShader(Rect.fromLTWH(0, 0, size.x, size.y)),
    );

    // Blush / detail for premium
    canvas.drawCircle(
      Offset(size.x * 0.08, size.y * 0.04),
      size.x * 0.045,
      Paint()..color = const Color(0xFFFF6B8A).withOpacity(0.35),
    );

    canvas.restore();
  }

  double? lerpDouble(double a, double b, double t) => a + (b - a) * t;

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (_isDead) return;
    onCollided?.call(other);
  }
}
