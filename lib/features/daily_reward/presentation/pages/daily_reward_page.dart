import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/glassmorphic_container.dart';
import '../../../../core/widgets/premium_button.dart';
import '../controllers/daily_reward_controller.dart';

class DailyRewardPage extends GetView<DailyRewardController> {
  const DailyRewardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    IconGlassButton(
                        icon: Icons.close_rounded, onPressed: () => Get.back()),
                    const SizedBox(width: 12),
                    Text('DAILY REWARD',
                        style: AppTextStyles.headlineMedium
                            .copyWith(color: Colors.white)),
                    const Spacer(),
                    Obx(() => GlassmorphicContainer(
                          borderRadius: 12,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          child: Row(
                            children: [
                              Icon(Icons.local_fire_department_rounded,
                                  size: 16, color: AppColors.warning),
                              const SizedBox(width: 4),
                              Text('${controller.streak.value} streak',
                                  style: AppTextStyles.labelSmall
                                      .copyWith(color: Colors.white)),
                            ],
                          ),
                        )),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Header Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GlassmorphicContainer(
                  borderRadius: 20,
                  gradient: LinearGradient(colors: [
                    AppColors.gold.withOpacity(0.28),
                    AppColors.goldDark.withOpacity(0.12)
                  ]),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppColors.goldGradient,
                              boxShadow: [
                                BoxShadow(
                                    color: AppColors.gold.withOpacity(0.4),
                                    blurRadius: 12)
                              ],
                            ),
                            child: const Icon(Icons.card_giftcard_rounded,
                                color: Color(0xFF7A4A00), size: 28),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(() {
                                  if (controller.canClaim.value) {
                                    return Text('Reward Available!',
                                        style: AppTextStyles.titleLarge
                                            .copyWith(color: Colors.white));
                                  } else {
                                    return Text('Come back tomorrow',
                                        style: AppTextStyles.titleMedium
                                            .copyWith(color: Colors.white));
                                  }
                                }),
                                const SizedBox(height: 2),
                                Obx(() => Text(
                                    controller.canClaim.value
                                        ? 'Claim ${controller.todayReward.value} coins now'
                                        : 'You claimed today. Keep your streak!',
                                    style: AppTextStyles.bodySmall
                                        .copyWith(color: Colors.white70))),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Obx(() => PremiumButton(
                            text: controller.canClaim.value
                                ? 'CLAIM ${controller.todayReward.value} COINS'
                                : 'CLAIMED TODAY',
                            icon: controller.canClaim.value
                                ? Icons.monetization_on_rounded
                                : Icons.check_circle_rounded,
                            isExpanded: true,
                            variant: controller.canClaim.value
                                ? PremiumButtonVariant.primary
                                : PremiumButtonVariant.ghost,
                            onPressed: controller.canClaim.value
                                ? () async {
                                    final reward = await controller.claim();
                                    if (reward > 0) {
                                      _showRewardDialog(reward);
                                    }
                                  }
                                : null,
                          )),
                    ],
                  ),
                ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95)),
              ),

              const SizedBox(height: 18),

              // 7-day grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.90,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: 7,
                  itemBuilder: (context, i) {
                    final reward = controller.rewardForDay(i);
                    final isClaimed = i < (controller.streak.value % 7) ||
                        (controller.streak.value >= 7 &&
                            !controller.canClaim.value &&
                            i < 7);
                    final isToday =
                        controller.isToday(i) && controller.canClaim.value;
                    final isFuture = i > (controller.streak.value % 7);

                    return GlassmorphicContainer(
                      borderRadius: 16,
                      borderColor: isToday
                          ? AppColors.gold.withOpacity(0.6)
                          : Colors.white.withOpacity(0.12),
                      gradient: isToday
                          ? LinearGradient(colors: [
                              AppColors.gold.withOpacity(0.28),
                              AppColors.goldDark.withOpacity(0.12)
                            ])
                          : (isClaimed
                              ? LinearGradient(colors: [
                                  AppColors.success.withOpacity(0.2),
                                  AppColors.success.withOpacity(0.06)
                                ])
                              : null),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('DAY ${i + 1}',
                              style: AppTextStyles.labelSmall.copyWith(
                                  color: isToday
                                      ? AppColors.goldLight
                                      : Colors.white70,
                                  fontSize: 9)),
                          const SizedBox(height: 6),
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isClaimed
                                  ? AppColors.success.withOpacity(0.18)
                                  : AppColors.gold
                                      .withOpacity(isFuture ? 0.12 : 0.22),
                              border: Border.all(
                                  color: isToday
                                      ? AppColors.gold
                                      : Colors.white.withOpacity(0.14)),
                            ),
                            child: Icon(
                              isClaimed
                                  ? Icons.check_rounded
                                  : Icons.monetization_on_rounded,
                              size: 18,
                              color: isClaimed
                                  ? AppColors.success
                                  : AppColors.gold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('$reward',
                              style: AppTextStyles.titleMedium.copyWith(
                                  color:
                                      isFuture ? Colors.white54 : Colors.white,
                                  fontWeight: FontWeight.w700)),
                          Text('coins',
                              style: AppTextStyles.caption.copyWith(
                                  fontSize: 9, color: Colors.white54)),
                        ],
                      ),
                    ).animate().fadeIn(delay: (i * 60).ms).scale(
                        begin: const Offset(0.9, 0.9), delay: (i * 60).ms);
                  },
                ),
              ),

              const Spacer(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Text('Keep your streak to get up to 500 coins on Day 7!',
                    style:
                        AppTextStyles.caption.copyWith(color: Colors.white54),
                    textAlign: TextAlign.center),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRewardDialog(int reward) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: GlassmorphicContainer(
          borderRadius: 24,
          blur: 22,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, gradient: AppColors.goldGradient),
                child: const Icon(Icons.monetization_on_rounded,
                    size: 44, color: Color(0xFF7A4A00)),
              )
                  .animate()
                  .scale(duration: 600.ms, curve: Curves.elasticOut)
                  .shimmer(duration: 1200.ms),
              const SizedBox(height: 14),
              Text('You got $reward coins!',
                  style: AppTextStyles.headlineMedium
                      .copyWith(color: Colors.white),
                  textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text('Come back tomorrow for more',
                  style:
                      AppTextStyles.bodySmall.copyWith(color: Colors.white70)),
              const SizedBox(height: 18),
              PremiumButton(
                  text: 'AWESOME',
                  isExpanded: true,
                  onPressed: () => Get.back()),
            ],
          ),
        ),
      ),
    );
  }
}

class IconGlassButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  const IconGlassButton({super.key, required this.icon, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.12),
          border: Border.all(color: Colors.white.withOpacity(0.18))),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }
}
