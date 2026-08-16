import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/glassmorphic_container.dart';
import '../../../game/presentation/controllers/game_controller.dart';
import '../../../game/domain/entities/score_entry.dart';

class LeaderboardPage extends GetView<GameController> {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scores = controller.getLeaderboard();
    scores.sort((a, b) => b.score.compareTo(a.score));

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
                    Text('LEADERBOARD',
                        style: AppTextStyles.headlineMedium
                            .copyWith(color: Colors.white)),
                    const Spacer(),
                    Icon(Icons.emoji_events_rounded, color: AppColors.gold),
                  ],
                ),
              ),

              // Top 3 podium
              if (scores.isNotEmpty)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (scores.length > 1) _podium(scores[1], 2, 110),
                      if (scores.isNotEmpty) _podium(scores[0], 1, 140),
                      if (scores.length > 2) _podium(scores[2], 3, 98),
                    ],
                  ),
                ),

              const SizedBox(height: 8),

              Expanded(
                child: scores.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.leaderboard_rounded,
                                size: 56,
                                color: Colors.white.withOpacity(0.18)),
                            const SizedBox(height: 12),
                            Text('No scores yet',
                                style: AppTextStyles.titleMedium
                                    .copyWith(color: Colors.white54)),
                            const SizedBox(height: 6),
                            Text('Play a game to see your best runs here',
                                style: AppTextStyles.bodySmall
                                    .copyWith(color: Colors.white38)),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        itemCount: scores.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, i) {
                          final entry = scores[i];
                          return _scoreRow(entry, i + 1)
                              .animate()
                              .fadeIn(delay: (i * 40).ms)
                              .slideY(begin: 0.12);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _podium(ScoreEntry entry, int place, double height) {
    Color color;
    IconData icon;
    switch (place) {
      case 1:
        color = AppColors.gold;
        icon = Icons.emoji_events_rounded;
        break;
      case 2:
        color = const Color(0xFFB0B0B0);
        icon = Icons.military_tech_rounded;
        break;
      default:
        color = const Color(0xFFCD7F32);
        icon = Icons.workspace_premium_rounded;
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                      colors: [color, Color.lerp(color, Colors.black, 0.2)!])),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text('${entry.score}',
                style:
                    AppTextStyles.headlineMedium.copyWith(color: Colors.white)),
            const SizedBox(height: 6),
            GlassmorphicContainer(
              borderRadius: 14,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  Text('#$place',
                      style: AppTextStyles.labelSmall.copyWith(color: color)),
                  SizedBox(height: height * 0.15),
                  Container(
                      height: height * 0.55,
                      width: double.infinity,
                      color: color.withOpacity(0.2)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _scoreRow(ScoreEntry entry, int rank) {
    return GlassmorphicContainer(
      borderRadius: 14,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: rank <= 3
                  ? AppColors.primary.withOpacity(0.25)
                  : Colors.white.withOpacity(0.08),
            ),
            child: Center(
                child: Text('#$rank',
                    style: AppTextStyles.labelSmall.copyWith(
                        color:
                            rank <= 3 ? AppColors.primaryLight : Colors.white70,
                        fontWeight: FontWeight.w800))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${entry.score} pts',
                    style: AppTextStyles.titleMedium
                        .copyWith(color: Colors.white)),
                Text(DateFormat('MMM dd, HH:mm').format(entry.date),
                    style: AppTextStyles.caption
                        .copyWith(fontSize: 10, color: Colors.white54)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
                color: AppColors.gold.withOpacity(0.18),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.monetization_on_rounded,
                    size: 12, color: AppColors.gold),
                const SizedBox(width: 3),
                Text('${entry.coinsCollected}',
                    style:
                        AppTextStyles.caption.copyWith(color: AppColors.gold)),
              ],
            ),
          ),
        ],
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
