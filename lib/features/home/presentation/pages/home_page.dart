import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/enums/theme_type.dart';
import '../../../../core/widgets/glassmorphic_container.dart';
import '../../../../core/widgets/premium_button.dart';
import '../../../../core/widgets/coin_display.dart';
import '../controllers/home_controller.dart';
import '../widgets/home_background.dart';
import '../widgets/animated_bird_preview.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Premium Themed Background
          Obx(() => HomeBackground(theme: controller.currentThemeData)),

          // Content
          SafeArea(
            child: Column(
              children: [
                // Top Bar
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  child: Row(
                    children: [
                      GlassmorphicContainer(
                        borderRadius: 18,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: AppColors.primaryGradient,
                              ),
                              child: const Icon(Icons.person_rounded,
                                  color: Colors.white, size: 20),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Fluttery',
                                    style: AppTextStyles.labelSmall
                                        .copyWith(color: Colors.white70)),
                                Obx(() => Text(
                                    'Best ${controller.highScore.value}',
                                    style: AppTextStyles.titleMedium.copyWith(
                                        color: Colors.white, height: 1))),
                              ],
                            ),
                          ],
                        ),
                      ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2),
                      const Spacer(),
                      Obx(() =>
                          CoinDisplay(coins: controller.totalCoins.value)),
                      const SizedBox(width: 10),
                      IconGlassButton(
                        icon: Icons.settings_rounded,
                        onPressed: () => Get.toNamed(AppRoutes.settings),
                      ),
                    ],
                  ),
                ),

                const Spacer(flex: 2),

                // Logo & Bird Preview
                Column(
                  children: [
                    Text(
                      'FLUTTERY\nWINGS',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.displayLarge.copyWith(
                        fontSize: 48,
                        height: 0.92,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1.2,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                              color: Colors.black.withOpacity(0.35),
                              offset: const Offset(0, 5),
                              blurRadius: 14),
                          Shadow(
                              color: AppColors.primary.withOpacity(0.45),
                              offset: const Offset(0, 0),
                              blurRadius: 26),
                        ],
                      ),
                    ).animate().fadeIn(duration: 600.ms).scale(
                        begin: const Offset(0.9, 0.9),
                        curve: Curves.elasticOut),

                    const SizedBox(height: 22),

                    Obx(() => AnimatedBirdPreview(
                          character: controller.currentCharacterData,
                          size: 118,
                        )),

                    const SizedBox(height: 20),

                    // Fixed theme selector - visible on light & dark
                    Obx(() {
                      return GlassmorphicContainer(
                        borderRadius: 24,
                        blur: 16,
                        opacity: 0.18,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        // Dark tint so white dots are always visible
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.18),
                            Colors.black.withOpacity(0.08),
                          ],
                        ),
                        borderColor: Colors.white.withOpacity(0.18),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: GameThemeCatalog.all.map((t) {
                            final isSel =
                                controller.selectedTheme.value == t.type;
                            return GestureDetector(
                              onTap: () => controller.selectTheme(t.type),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOutBack,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                width: isSel ? 28 : 9,
                                height: 9,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9),
                                  color: isSel
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.42),
                                  border: Border.all(
                                    color: isSel
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.2),
                                    width: 1,
                                  ),
                                  boxShadow: isSel
                                      ? [
                                          BoxShadow(
                                            color: t.accent.withOpacity(0.7),
                                            blurRadius: 10,
                                            spreadRadius: 1,
                                          ),
                                          BoxShadow(
                                            color:
                                                Colors.white.withOpacity(0.5),
                                            blurRadius: 4,
                                          ),
                                        ]
                                      : [],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    }),
                  ],
                ),

                const Spacer(flex: 3),

                // Action Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      PremiumButton(
                        text: 'PLAY NOW',
                        icon: Icons.play_arrow_rounded,
                        isExpanded: true,
                        height: 64,
                        onPressed: () => Get.toNamed(AppRoutes.game),
                      )
                          .animate()
                          .slideY(
                              begin: 0.3,
                              duration: 500.ms,
                              curve: Curves.easeOutBack)
                          .fadeIn(),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: PremiumButton(
                              text: 'SHOP',
                              icon: Icons.shopping_bag_rounded,
                              variant: PremiumButtonVariant.secondary,
                              onPressed: () => Get.toNamed(AppRoutes.shop),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: PremiumButton(
                              text: 'REWARD',
                              icon: Icons.card_giftcard_rounded,
                              variant: PremiumButtonVariant.secondary,
                              onPressed: () =>
                                  Get.toNamed(AppRoutes.dailyReward),
                            ),
                          ),
                        ],
                      ).animate().slideY(begin: 0.25, delay: 100.ms).fadeIn(),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _BottomGlassAction(
                            icon: Icons.emoji_events_rounded,
                            label: 'ACHIEVEMENTS',
                            onTap: () => Get.toNamed(AppRoutes.achievements),
                          ),
                          const SizedBox(width: 10),
                          _BottomGlassAction(
                            icon: Icons.leaderboard_rounded,
                            label: 'LEADERBOARD',
                            onTap: () => Get.toNamed(AppRoutes.leaderboard),
                          ),
                          const SizedBox(width: 10),
                          Obx(() {
                            final canClaim = controller.canClaimDaily.value;
                            return _BottomGlassAction(
                              icon: Icons.local_fire_department_rounded,
                              label:
                                  '${controller.dailyStreak.value} DAY STREAK',
                              isHighlight: canClaim,
                              badge: canClaim,
                              onTap: () => Get.toNamed(AppRoutes.dailyReward),
                            );
                          }),
                        ],
                      ).animate().slideY(begin: 0.2, delay: 180.ms).fadeIn(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomGlassAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isHighlight;
  final bool badge;

  const _BottomGlassAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isHighlight = false,
    this.badge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GlassmorphicContainer(
          borderRadius: 18,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
          onTap: onTap,
          // Highlight only when canClaim - subtle gold
          gradient: isHighlight
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.gold.withOpacity(0.28),
                    AppColors.goldDark.withOpacity(0.16),
                  ],
                )
              : null,
          borderColor: isHighlight
              ? AppColors.gold.withOpacity(0.4)
              : Colors.white.withOpacity(0.16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isHighlight
                    ? AppColors.goldLight
                    : Colors.white.withOpacity(0.92),
                size: 22,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: AppTextStyles.labelSmall.copyWith(
                  color: Colors.white,
                  fontSize: 8.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        if (badge)
          Positioned(
            top: -3,
            right: -3,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                      color: AppColors.error.withOpacity(0.5), blurRadius: 6),
                ],
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                duration: 900.ms,
                begin: const Offset(1, 1),
                end: const Offset(1.18, 1.18)),
          ),
      ],
    );
  }
}
