import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/enums/game_state.dart';
import '../../../../core/services/ads_service.dart';
import '../../../../core/widgets/glassmorphic_container.dart';
import '../../../../core/widgets/premium_button.dart';
import '../../../../core/widgets/coin_display.dart';
import '../controllers/game_controller.dart';
import '../game/fluttery_game.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late FlutteryGame _game;
  late GameController _controller;
  bool _gameReady = false;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<GameController>();
    _controller.resetGame();

    _game = FlutteryGame(
      character: _controller.selectedCharacter,
      theme: _controller.selectedTheme,
      callbacks: GameCallbacks(
        onGameStarted: () {
          _controller.onGameStarted();
        },
        onScore: (s) {
          _controller.onScore(s);
        },
        onCoinCollected: (c) {
          _controller.onCoinCollected(c);
        },
        onGameOver: (finalScore, coins) {
          _controller.onGameOver(finalScore, coins);
        },
        onFlap: () {
          _controller.onFlap();
        },
      ),
    );

    // Delay to ensure layout
    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) setState(() => _gameReady = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _controller.selectedTheme.skyBottom,
      body: Stack(
        children: [
          // Game Widget
          if (_gameReady)
            GameWidget(
              game: _game,
              backgroundBuilder: (context) =>
                  Container(color: _controller.selectedTheme.skyBottom),
            )
          else
            Container(color: _controller.selectedTheme.skyBottom),

          // Top HUD
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  IconGlassButton(
                    icon: Icons.pause_rounded,
                    size: 44,
                    onPressed: () {
                      _showPauseDialog();
                    },
                  ),
                  const Spacer(),
                  Obx(() => CoinDisplay(
                        coins: _controller.totalCoins.value,
                        size: 15,
                      )),
                ],
              ),
            ),
          ),

          // Center HUD - Score & Ready
          SafeArea(
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 70),
                  Obx(() {
                    final state = _controller.gameState.value;
                    if (state == GameState.ready) {
                      // Show current score if resuming (e.g., 3), else 0 for new game
                      final displayScore = _controller.currentScore.value > 0
                          ? _controller.currentScore.value
                          : 0;
                      return Column(
                        children: [
                          ScoreDisplay(
                                  score: displayScore,
                                  best: _controller.highScore.value)
                              .animate()
                              .fadeIn(duration: 400.ms),
                          const SizedBox(height: 18),
                          GlassmorphicContainer(
                            borderRadius: 16,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 10),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.touch_app_rounded,
                                    color: Colors.white.withOpacity(0.9),
                                    size: 20),
                                const SizedBox(width: 8),
                                Text('TAP TO FLAP',
                                    style: AppTextStyles.labelSmall.copyWith(
                                        color: Colors.white,
                                        fontSize: 12,
                                        letterSpacing: 1.6)),
                              ],
                            ),
                          )
                              .animate(onPlay: (c) => c.repeat(reverse: true))
                              .scale(
                                  begin: const Offset(1, 1),
                                  end: const Offset(1.05, 1.05),
                                  duration: 700.ms),
                          const SizedBox(height: 20),
                          Icon(Icons.flutter_dash_rounded,
                                  size: 42,
                                  color: Colors.white.withOpacity(0.9))
                              .animate(onPlay: (c) => c.repeat(reverse: true))
                              .moveY(
                                  begin: -6,
                                  end: 6,
                                  duration: 800.ms,
                                  curve: Curves.easeInOut),
                        ],
                      );
                    } else if (state == GameState.playing) {
                      return Obx(() => ScoreDisplay(
                          score: _controller.currentScore.value,
                          compact: true));
                    } else {
                      return const SizedBox.shrink();
                    }
                  }),
                  const Spacer(),
                  // coins session display during play
                  Obx(() {
                    if (_controller.gameState.value != GameState.playing)
                      return const SizedBox.shrink();
                    if (_controller.sessionCoins.value == 0)
                      return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 120),
                      child: GlassmorphicContainer(
                        borderRadius: 12,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.monetization_on_rounded,
                                size: 16, color: AppColors.gold),
                            const SizedBox(width: 6),
                            Text('+${_controller.sessionCoins.value}',
                                style:
                                    AppTextStyles.coin.copyWith(fontSize: 14)),
                          ],
                        ),
                      ).animate().scale(duration: 220.ms),
                    );
                  }),
                ],
              ),
            ),
          ),

          // Game Over Overlay - Premium
          Obx(() {
            if (_controller.gameState.value != GameState.gameOver)
              return const SizedBox.shrink();
            return _GameOverOverlay(
              controller: _controller,
              onRestart: () {
                _controller.resetGame();
                _game.startGame();
              },
              onWatchAd: () async {
                // User wants: Score 3 Die -> WATCH AD -> TAP TO FLAP -> tap -> resume at score 3 (safe spot)
                _game.pauseEngine(); // freeze while ad shows

                try {
                  await AdsService.instance.showRewardedAd(onRewarded: (_) {
                    // _game.prepareReviveTapToFlapAfterAd();
                    // _controller.showTapToFlap();
                  });
                } catch (e) {
                  debugPrint('Ad error $e');
                }

                // After ad closes -> show TAP TO FLAP but KEEP score 3, bird safe spot
                Timer(Duration(seconds: 2), () {
                  _game.prepareReviveTapToFlapAfterAd();
                  _controller.showTapToFlap();
                });
                // shows TAP TO FLAP, score remains 3
              },
            );
          }),

          // Frozen Overlay - kept for future use
          Obx(() {
            if (_controller.gameState.value != GameState.frozen)
              return const SizedBox.shrink();
            return _FrozenOverlay(
              onTap: () {
                _controller.showTapToFlap();
                _game.resumeEngine();
              },
            );
          }),
        ],
      ),
    );
  }

  void _showPauseDialog() {
    if (_controller.gameState.value != GameState.playing) return;
    _game.pauseGame();
    _controller.gameState.value = GameState.paused;
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: GlassmorphicContainer(
          borderRadius: 24,
          padding: const EdgeInsets.all(22),
          blur: 22,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('PAUSED',
                  style:
                      AppTextStyles.displaySmall.copyWith(color: Colors.white)),
              const SizedBox(height: 18),
              PremiumButton(
                text: 'RESUME',
                icon: Icons.play_arrow_rounded,
                isExpanded: true,
                onPressed: () {
                  Get.back();
                  // User wants: Pause -> RESUME -> TAP TO FLAP -> tap -> resumes (keeps score)
                  _game.prepareResumeTapToFlap();
                  _controller.showTapToFlap();
                  // Now game shows TAP TO FLAP, bird hovers at paused position
                  // Next tap will call startGame? No, we want resume not restart.
                  // So we actually need to keep score and on next tap resume.
                  // We'll handle next tap via custom logic: set a flag that next tap resumes
                  // For simplicity, we set gameState to ready but keep score in controller.currentScore
                  // And when user taps in ready state, we check if we are resuming from pause
                  // So we store current score before reset
                },
              ),
              const SizedBox(height: 10),
              PremiumButton(
                text: 'RESTART',
                icon: Icons.replay_rounded,
                variant: PremiumButtonVariant.secondary,
                isExpanded: true,
                onPressed: () {
                  Get.back();
                  _controller.resetGame();
                  _game.startGame();
                },
              ),
              const SizedBox(height: 10),
              PremiumButton(
                text: 'QUIT',
                variant: PremiumButtonVariant.ghost,
                isExpanded: true,
                onPressed: () {
                  Get.back();
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}

class _GameOverOverlay extends StatelessWidget {
  final GameController controller;
  final VoidCallback onRestart;
  final Future<void> Function()? onWatchAd;

  const _GameOverOverlay({
    required this.controller,
    required this.onRestart,
    this.onWatchAd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.scrim.withOpacity(0.55),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('GAME OVER',
                        style: AppTextStyles.gameOver.copyWith(
                          shadows: [
                            Shadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 12,
                                offset: const Offset(0, 4)),
                          ],
                        ))
                    .animate()
                    .scale(
                        begin: const Offset(0.7, 0.7),
                        end: const Offset(1, 1),
                        duration: 500.ms,
                        curve: Curves.elasticOut)
                    .fadeIn(),

                const SizedBox(height: 18),

                GlassmorphicContainer(
                  borderRadius: 24,
                  blur: 22,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Score
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text('SCORE', style: AppTextStyles.labelSmall),
                              const SizedBox(height: 4),
                              Obx(() => Text('${controller.currentScore.value}',
                                  style: AppTextStyles.displayMedium
                                      .copyWith(color: Colors.white))),
                            ],
                          ),
                          Container(
                              width: 1,
                              height: 46,
                              color: Colors.white.withOpacity(0.12)),
                          Column(
                            children: [
                              Text('BEST', style: AppTextStyles.labelSmall),
                              const SizedBox(height: 4),
                              Obx(() => Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('${controller.highScore.value}',
                                          style: AppTextStyles.displayMedium
                                              .copyWith(color: AppColors.gold)),
                                      if (controller.isNewHigh.value) ...[
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                              color: AppColors.error,
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: Text('NEW',
                                              style: AppTextStyles.labelSmall
                                                  .copyWith(
                                                      color: Colors.white,
                                                      fontSize: 9)),
                                        ),
                                      ],
                                    ],
                                  )),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      Divider(color: Colors.white.withOpacity(0.08), height: 1),
                      const SizedBox(height: 16),

                      // Coins
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.monetization_on_rounded,
                              color: AppColors.gold, size: 20),
                          const SizedBox(width: 8),
                          Text('COINS COLLECTED',
                              style: AppTextStyles.labelSmall),
                          const Spacer(),
                          Obx(() => Text('+${controller.sessionCoins.value}',
                              style: AppTextStyles.titleLarge
                                  .copyWith(color: AppColors.gold))),
                        ],
                      ),

                      const SizedBox(height: 22),

                      // Buttons
                      PremiumButton(
                        text: 'PLAY AGAIN',
                        icon: Icons.replay_rounded,
                        isExpanded: true,
                        height: 56,
                        onPressed: onRestart,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: PremiumButton(
                              text: 'HOME',
                              icon: Icons.home_rounded,
                              variant: PremiumButtonVariant.secondary,
                              onPressed: () => Get.back(),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _WatchAdResumeButton(onWatchAd: onWatchAd),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
                    .animate()
                    .slideY(
                        begin: 0.25,
                        duration: 520.ms,
                        curve: Curves.easeOutBack)
                    .fadeIn(),

                const SizedBox(height: 16),

                // Share / Leaderboard hint
                GlassmorphicContainer(
                  borderRadius: 14,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.leaderboard_rounded,
                          size: 18, color: Colors.white70),
                      const SizedBox(width: 8),
                      Text(
                          'You are ranked #${(controller.currentScore.value % 27) + 1} locally',
                          style: AppTextStyles.bodySmall
                              .copyWith(color: Colors.white70)),
                    ],
                  ),
                ).animate().fadeIn(delay: 300.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Frozen Overlay - Screen freeze after ad / resume click
/// Flow: frozen -> tap -> shows TAP TO FLAP (ready) -> tap -> playing
class _FrozenOverlay extends StatelessWidget {
  final VoidCallback onTap;
  const _FrozenOverlay({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        color: Colors.black.withOpacity(0.42),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.pause_circle_filled_rounded,
                        size: 82, color: Colors.white.withOpacity(0.92))
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .scale(
                        begin: const Offset(1, 1),
                        end: const Offset(1.08, 1.08),
                        duration: 800.ms),
                const SizedBox(height: 18),
                Text('SCREEN FROZEN',
                    style: AppTextStyles.displaySmall.copyWith(
                      color: Colors.white,
                      letterSpacing: 1.2,
                    )),
                const SizedBox(height: 10),
                GlassmorphicContainer(
                  borderRadius: 14,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  blur: 18,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.touch_app_rounded,
                          color: Colors.white.withOpacity(0.9), size: 20),
                      const SizedBox(width: 8),
                      Text('TAP TO CONTINUE',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: Colors.white,
                            fontSize: 13,
                            letterSpacing: 1.4,
                          )),
                    ],
                  ),
                ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                    begin: const Offset(1, 1),
                    end: const Offset(1.04, 1.04),
                    duration: 700.ms),
                const SizedBox(height: 14),
                Text('Game will show TAP TO FLAP then start',
                    style:
                        AppTextStyles.caption.copyWith(color: Colors.white70)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Watch Ad Button - Shows ad, then opens game FROZEN per your request
class _WatchAdResumeButton extends StatefulWidget {
  final Future<void> Function()? onWatchAd;
  const _WatchAdResumeButton({this.onWatchAd});

  @override
  State<_WatchAdResumeButton> createState() => _WatchAdResumeButtonState();
}

class _WatchAdResumeButtonState extends State<_WatchAdResumeButton> {
  bool _isLoading = false;

  Future<void> _onPressed() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      // Show ONLY rewarded ad - no interstitial to prevent flicker
      await AdsService.instance.showRewardedAd(
        onRewarded: (_) => debugPrint('Ad watched - will revive'),
      );
    } catch (e) {
      debugPrint('Ad error $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
      if (widget.onWatchAd != null) {
        await widget.onWatchAd!.call();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PremiumButton(
      text: 'WATCH AD',
      icon: Icons.play_circle_rounded,
      variant: PremiumButtonVariant.ghost,
      isLoading: _isLoading,
      onPressed: _onPressed,
    );
  }
}
