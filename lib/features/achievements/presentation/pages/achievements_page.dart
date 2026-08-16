import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/glassmorphic_container.dart';
import '../../../game/domain/entities/achievement.dart';
import '../controllers/achievements_controller.dart';
import '../../../../features/game/presentation/controllers/game_controller.dart';
import '../../../../core/services/storage_service.dart';

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({super.key});

  @override
  State<AchievementsPage> createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  late AchievementsController ctrl;

  @override
  void initState() {
    super.initState();
    ctrl = Get.find<AchievementsController>();
    // Trigger evaluation with current stats
    final storage = Get.find<StorageService>();
    final gameCtrl =
        Get.isRegistered<GameController>() ? Get.find<GameController>() : null;
    ctrl.evaluate(
      bestScore: storage.highScore,
      totalCoins: storage.totalCoins,
      gamesPlayed: storage.totalGamesPlayed,
      totalFlaps: storage.totalFlaps,
    );
  }

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
                        icon: Icons.arrow_back_rounded,
                        onPressed: () => Get.back()),
                    const SizedBox(width: 12),
                    Text('ACHIEVEMENTS',
                        style: AppTextStyles.headlineMedium
                            .copyWith(color: Colors.white)),
                    const Spacer(),
                    Obx(() => GlassmorphicContainer(
                          borderRadius: 14,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          child: Text(
                              '${(ctrl.completionPercent * 100).toInt()}%',
                              style: AppTextStyles.titleMedium
                                  .copyWith(color: Colors.white)),
                        )),
                  ],
                ),
              ),

              // Progress bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Obx(() => ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: ctrl.completionPercent,
                        minHeight: 8,
                        backgroundColor: Colors.white.withOpacity(0.12),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.primary),
                      ),
                    )),
              ),

              const SizedBox(height: 14),

              Expanded(
                child: ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: AchievementCatalog.all.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final ach = AchievementCatalog.all[i];
                    final prog = ctrl.progressList.firstWhere(
                        (p) => p.id == ach.id,
                        orElse: () => AchievementProgress(
                            id: ach.id, current: 0, unlocked: false));
                    return _AchievementTile(ach: ach, prog: prog, index: i);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AchievementTile extends StatelessWidget {
  final Achievement ach;
  final AchievementProgress prog;
  final int index;

  const _AchievementTile(
      {required this.ach, required this.prog, required this.index});

  @override
  Widget build(BuildContext context) {
    final isUnlocked = prog.unlocked;
    return GlassmorphicContainer(
      borderRadius: 18,
      blur: isUnlocked ? 14 : 8,
      borderColor: isUnlocked
          ? ach.tierColor.withOpacity(0.4)
          : Colors.white.withOpacity(0.1),
      gradient: isUnlocked
          ? LinearGradient(colors: [
              ach.tierColor.withOpacity(0.22),
              ach.tierColor.withOpacity(0.06)
            ])
          : null,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [
                ach.tierColor,
                Color.lerp(ach.tierColor, Colors.black, 0.2)!
              ]),
              boxShadow: isUnlocked
                  ? [
                      BoxShadow(
                          color: ach.tierColor.withOpacity(0.4), blurRadius: 12)
                    ]
                  : [],
            ),
            child: Icon(ach.icon, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Text(ach.title,
                            style: AppTextStyles.titleMedium
                                .copyWith(color: Colors.white))),
                    if (isUnlocked)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                            color: ach.tierColor,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text('DONE',
                            style: AppTextStyles.labelSmall
                                .copyWith(color: Colors.white, fontSize: 8)),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(ach.description,
                    style: AppTextStyles.bodySmall
                        .copyWith(color: Colors.white70, fontSize: 11)),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: isUnlocked
                        ? 1
                        : (prog.current / ach.target).clamp(0, 1).toDouble(),
                    minHeight: 6,
                    backgroundColor: Colors.white.withOpacity(0.12),
                    valueColor: AlwaysStoppedAnimation<Color>(ach.tierColor),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${prog.current}/${ach.target}',
                        style: AppTextStyles.caption.copyWith(fontSize: 10)),
                    Row(
                      children: [
                        Icon(Icons.monetization_on_rounded,
                            size: 12, color: AppColors.gold),
                        const SizedBox(width: 3),
                        Text('+${ach.rewardCoins}',
                            style: AppTextStyles.caption
                                .copyWith(color: AppColors.gold)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: (index * 70).ms).slideX(begin: 0.12);
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
