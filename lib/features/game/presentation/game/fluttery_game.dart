import 'dart:async' as async;
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/enums/character_type.dart';
import '../../../../core/enums/theme_type.dart';
import '../../../../core/utils/helpers.dart';
import 'components/bird_component.dart';
import 'components/coin_component.dart';
import 'components/ground_component.dart';
import 'components/parallax_background.dart';
import 'components/pipe_component.dart';

/// Callback interfaces for UI layer.

class GameCallbacks {
  final void Function(int score) onScore;
  final void Function(int coins) onCoinCollected;
  final void Function(int finalScore, int coinsCollected) onGameOver;
  final VoidCallback? onFlap;
  final VoidCallback? onGameStarted; // NEW: Fixes TAP TO FLAP not hiding

  GameCallbacks({
    required this.onScore,
    required this.onCoinCollected,
    required this.onGameOver,
    this.onFlap,
    this.onGameStarted,
  });
}

class FlutteryGame extends FlameGame
    with HasCollisionDetection, TapDetector, HasGameRef {
  // Configuration
  CharacterData character;
  GameThemeData theme;
  GameCallbacks callbacks;

  FlutteryGame({
    required this.character,
    required this.theme,
    required this.callbacks,
    super.camera,
  });

  // Components
  late BirdComponent bird;
  late GroundComponent ground;
  late ParallaxBackground background;

  // State
  bool isPlaying = false;
  bool isGameOver = false;
  bool _isResumeFromPausePending =
      false; // For Pause -> RESUME -> TAP TO FLAP -> tap -> resume flow
  int score = 0;
  int coinsCollected = 0;
  double worldSpeed = AppConstants.baseWorldSpeed;
  double _pipeSpawnTimer = 0;
  double _difficultyTimer = 0;

  final List<PipePair> _activePipes = [];
  final List<CoinComponent> _activeCoins = [];

  // Bird start position
  Vector2 get _birdStartPos => Vector2(size.x * 0.28, size.y * 0.45);

  @override
  Color backgroundColor() => theme.skyBottom;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Camera viewport - safe guard for older Flame versions
    try {
      camera.viewfinder.anchor = Anchor.topLeft;
    } catch (_) {
      // Flame <1.20 uses different camera API, ignore
    }

    await _initWorld();
  }

  Future<void> _initWorld() async {
    // Ensure size is valid (Flame may call onLoad before size known)
    if (size.x <= 10 || size.y <= 10) {
      // Defer until size ready
      await Future.delayed(const Duration(milliseconds: 100));
      if (size.x <= 10) return;
    }

    // Background
    try {
      background = ParallaxBackground(theme: theme, gameSize: size);
      await add(background);
    } catch (e) {
      debugPrint('Background add failed $e');
    }

    // Ground
    try {
      ground = GroundComponent(
        size: Vector2(size.x, AppConstants.groundHeight),
        position: Vector2(0, size.y - AppConstants.groundHeight),
        theme: theme,
        worldSpeed: worldSpeed,
      );
      await add(ground);
    } catch (e) {
      debugPrint('Ground add failed $e');
    }

    // Bird
    try {
      bird = BirdComponent(
        character: character,
        initialPosition: _birdStartPos.clone(),
        onCollided: _handleCollision,
      );
      await add(bird);
    } catch (e) {
      debugPrint('Bird add failed $e');
    }

    // Initial pipes delayed
    _pipeSpawnTimer = 1.2;
  }

  void startGame() {
    if (isPlaying) return;
    isPlaying = true;
    isGameOver = false;
    score = 0;
    coinsCollected = 0;
    worldSpeed = AppConstants.baseWorldSpeed;
    _pipeSpawnTimer = 1.0;
    // Clear pipes/coins
    for (final p in _activePipes) {
      p.removeFromParent();
    }
    _activePipes.clear();
    for (final c in _activeCoins) {
      c.removeFromParent();
    }
    _activeCoins.clear();

    bird.reset(_birdStartPos.clone());
    bird.setPlaying(true);
    ground.updateSpeed(worldSpeed);

    // Notify UI to hide READY overlay / TAP TO FLAP
    callbacks.onGameStarted?.call();
  }

  void resetToReady() {
    // Used for new game after ad: clear world, ready state, score 0
    isPlaying = false;
    isGameOver = false;
    score = 0;
    coinsCollected = 0;
    worldSpeed = AppConstants.baseWorldSpeed;
    _pipeSpawnTimer = 1.2;
    for (final p in _activePipes) {
      p.removeFromParent();
    }
    _activePipes.clear();
    for (final c in _activeCoins) {
      c.removeFromParent();
    }
    _activeCoins.clear();
    bird.reset(_birdStartPos.clone());
    bird.setPlaying(false);
    ground.updateSpeed(worldSpeed);
    try {
      pauseEngine();
    } catch (_) {}
  }

  void prepareResumeTapToFlap() {
    // For Pause -> RESUME flow: keep score & pipes, show TAP TO FLAP then tap to resume
    isPlaying = false;
    isGameOver = false;
    _isResumeFromPausePending = true;
    bird.setHoverAtCurrentPos();
    ground.updateSpeed(0);
    for (final p in _activePipes) {
      p.updateSpeed(0);
    }
    resumeEngine();
  }

  void prepareReviveTapToFlapAfterAd() {
    // For Die -> WATCH AD -> TAP TO FLAP -> tap -> resume at same score (e.g., 3)
    isPlaying = false;
    isGameOver = false;
    _isResumeFromPausePending = true; // next tap resumes, not restarts
    // Remove dangerous pipes near bird for safe respawn
    _activePipes.removeWhere((p) {
      final tooClose = p.position.x < bird.position.x + 180 &&
          p.position.x + AppConstants.pipeWidth > bird.position.x - 150;
      if (tooClose) {
        p.removeFromParent();
        return true;
      }
      return false;
    });
    // Reset bird to safe start position, hovering
    bird.reset(_birdStartPos.clone());
    bird.setHoverAtCurrentPos();
    ground.updateSpeed(0);
    for (final p in _activePipes) {
      p.updateSpeed(0);
    }
    resumeEngine();
  }

  void _gameOver() {
    if (isGameOver) return;
    isGameOver = true;
    isPlaying = false;
    bird.die();
    callbacks.onGameOver(score, coinsCollected);
  }

  @override
  void onTap() {
    if (isGameOver) return;
    if (!isPlaying) {
      // If resuming from pause, keep score and pipes
      if (_isResumeFromPausePending) {
        _isResumeFromPausePending = false;
        resumeGame();
        callbacks.onGameStarted?.call(); // update UI to playing
        _flap();
        return;
      }
      // Otherwise new game
      startGame();
      _flap();
      return;
    }
    _flap();
  }

  @override
  bool onTapDown(TapDownInfo info) {
    onTap();
    return true;
  }

  void _flap() {
    if (!isPlaying || isGameOver) return;
    bird.flap();
    callbacks.onFlap?.call();
  }

  void _handleCollision(PositionComponent other) {
    if (isGameOver) return;
    // FIX 1: Coins must NEVER trigger game over
    if (other is CoinComponent) return;
    // If the hitbox parent is coin, ignore
    if (other.parent is CoinComponent) return;
    // Only pipes & ground should kill
    if (other is SinglePipe || other is GroundComponent) {
      _gameOver();
    } else if (other.parent is SinglePipe || other.parent is GroundComponent) {
      _gameOver();
    } else {
      // For any other unknown collision, check type name to avoid coin
      final typeName = other.runtimeType.toString();
      if (typeName.toLowerCase().contains('coin')) return;
      _gameOver();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!isPlaying || isGameOver) return;

    // Difficulty ramp
    _difficultyTimer += dt;
    if (_difficultyTimer > 1.2) {
      _difficultyTimer = 0;
      worldSpeed = (AppConstants.baseWorldSpeed +
              score * AppConstants.speedIncrementPerScore)
          .clamp(AppConstants.baseWorldSpeed, AppConstants.maxWorldSpeed);
      ground.updateSpeed(worldSpeed);
      for (final p in _activePipes) {
        p.updateSpeed(worldSpeed);
      }
    }

    // Spawn pipes
    _pipeSpawnTimer -= dt;
    if (_pipeSpawnTimer <= 0) {
      _spawnPipePair();
      _pipeSpawnTimer = _computeNextSpawnInterval();
    }

    // Check scoring & collisions
    _checkPipePassing();
    _checkOutOfBounds();
    _checkCollisionManually();

    // Cleanup off-screen
    _activePipes.removeWhere((p) {
      if (p.isOffScreen) {
        p.removeFromParent();
        return true;
      }
      return false;
    });
    _activeCoins.removeWhere((c) {
      if (c.isOffScreen || c.collected) {
        if (!c.collected) c.removeFromParent();
        return true;
      }
      return false;
    });
  }

  double _computeNextSpawnInterval() {
    // interval = distance / speed
    final dist = AppConstants.pipeSpacing;
    final interval = dist / worldSpeed;
    return interval.clamp(1.0, 2.2);
  }

  void _spawnPipePair() {
    // FIX 2: Generate ONE topHeight and reuse for pipe + coin -> coin always in gap center, never on pipe
    final double minH = AppConstants.pipeMinHeight;
    final double maxH = size.y -
        AppConstants.groundHeight -
        AppConstants.pipeGap -
        AppConstants.pipeMinHeight;
    final double topHeight =
        GameHelpers.randomDouble(minH, maxH.clamp(minH + 10, size.y));

    final pair = PipePair(
      initialPosition: Vector2(size.x + AppConstants.pipeSpawnXOffset, 0),
      gap: AppConstants.pipeGap,
      themeData: theme,
      gameHeight: size.y,
      worldSpeed: worldSpeed,
      overrideTopHeight: topHeight, // ensures coin aligns
    );
    add(pair);
    _activePipes.add(pair);

    // Spawn coin SAFELY inside gap, never on pipe
    if (GameHelpers.chance(AppConstants.coinSpawnChance)) {
      // Safe margins inside gap so coin never touches pipe caps
      const double safeMargin = 28.0;
      final double gapTopSafe = topHeight + safeMargin;
      final double gapBottomSafe =
          topHeight + AppConstants.pipeGap - safeMargin;
      // Clamp to ensure coin stays in visible gap
      if (gapBottomSafe > gapTopSafe) {
        final double coinY =
            GameHelpers.randomDouble(gapTopSafe, gapBottomSafe);
        // Place coin slightly AFTER pipe center so player sees it coming, not inside pipe X
        final double coinX = size.x +
            AppConstants.pipeSpawnXOffset +
            AppConstants.pipeWidth +
            26;

        final coin = CoinComponent(
          initialPosition: Vector2(coinX, coinY),
          worldSpeed: worldSpeed,
        );
        add(coin);
        _activeCoins.add(coin);
      }
    }
  }

  void _checkPipePassing() {
    for (final pipe in _activePipes) {
      if (!pipe.hasScored &&
          pipe.position.x + AppConstants.pipeWidth < bird.position.x) {
        pipe.hasScored = true;
        score += AppConstants.scorePerPipe;
        callbacks.onScore(score);
      }
    }
  }

  void _checkOutOfBounds() {
    if (bird.position.y < -bird.size.y * 0.5 ||
        bird.position.y >
            size.y - AppConstants.groundHeight + bird.size.y * 0.5) {
      _gameOver();
    }
  }

  void _checkCollisionManually() {
    // Better than relying solely on collision callbacks due to performance
    // Check bird against pipes using simple AABB circle rect
    final birdPos = bird.position;
    final birdR = AppConstants.birdRadius * 0.72;

    // Ground
    if (birdPos.y + birdR > size.y - AppConstants.groundHeight) {
      _gameOver();
      return;
    }

    // Pipes
    for (final pipePair in _activePipes) {
      // Quick X check
      if (birdPos.x + birdR < pipePair.position.x ||
          birdPos.x - birdR > pipePair.position.x + AppConstants.pipeWidth) {
        continue;
      }
      // Need to check both top and bottom pipes
      for (final child in pipePair.children.whereType<SinglePipe>()) {
        final pipeRect = Rect.fromLTWH(
          pipePair.position.x,
          pipePair.position.y + child.position.y,
          child.size.x,
          child.size.y,
        );
        if (_circleRectCollision(birdPos, birdR, pipeRect)) {
          _gameOver();
          return;
        }
      }
    }

    // Coin collection
    for (final coin in _activeCoins) {
      if (coin.collected) continue;
      final dist = birdPos.distanceTo(coin.position);
      if (dist < birdR + AppConstants.coinSize * 0.4) {
        coin.collect();
        coin.removeFromParent();
        coinsCollected += AppConstants.coinValue;
        callbacks.onCoinCollected(coinsCollected);
      }
    }
  }

  bool _circleRectCollision(Vector2 circlePos, double radius, Rect rect) {
    final closestX = circlePos.x.clamp(rect.left, rect.right);
    final closestY = circlePos.y.clamp(rect.top, rect.bottom);
    final dx = circlePos.x - closestX;
    final dy = circlePos.y - closestY;
    return (dx * dx + dy * dy) < (radius * radius);
  }

  // External controls
  void updateCharacter(CharacterData newChar) {
    character = newChar;
    // Recreate bird if needed - here just remove & add new one preserving position
    final pos = bird.position.clone();
    bird.removeFromParent();
    bird = BirdComponent(
      character: newChar,
      initialPosition: pos,
    );
    add(bird);
  }

  void updateTheme(GameThemeData newTheme) {
    theme = newTheme;
    // Update existing components
    ground.theme;
    // For simplicity recreate background and ground theme reliance via new instances would be ideal but we update reference
    // We'll recreate background
    background.removeFromParent();
    background = ParallaxBackground(theme: newTheme, gameSize: size);
    add(background);
    ground.removeFromParent();
    ground = GroundComponent(
      size: Vector2(size.x, AppConstants.groundHeight),
      position: Vector2(0, size.y - AppConstants.groundHeight),
      theme: newTheme,
      worldSpeed: worldSpeed,
    );
    add(ground);
    // Re-add bird on top
    bird.removeFromParent();
    add(bird);
  }

  void pauseGame() {
    if (!isPlaying) return;
    pauseEngine();
  }

  void resumeGame() {
    resumeEngine();
    isPlaying = true;
    isGameOver = false;
    bird.setPlaying(true);
    ground.updateSpeed(worldSpeed);
    for (final p in _activePipes) {
      p.updateSpeed(worldSpeed);
    }
  }

  // NEW: Revive after watching ad - keeps score, removes dangerous pipes
  void revive() {
    // Keep score, coins, worldSpeed as is
    isGameOver = false;
    isPlaying = true;
    _pipeSpawnTimer = 1.0;

    // Remove pipes that are too close to bird (within 150px) to give safe respawn
    _activePipes.removeWhere((p) {
      final tooClose = p.position.x < bird.position.x + 140 &&
          p.position.x + AppConstants.pipeWidth > bird.position.x - 120;
      if (tooClose) {
        p.removeFromParent();
        return true;
      }
      return false;
    });

    // Reset bird to safe start pos but keep game running
    bird.reset(_birdStartPos.clone());
    bird.setPlaying(true);
    ground.updateSpeed(worldSpeed);
    resumeEngine();
  }
}
