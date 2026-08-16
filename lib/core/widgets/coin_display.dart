import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import 'glassmorphic_container.dart';

class CoinDisplay extends StatelessWidget {
  final int coins;
  final double size;
  final bool showBackground;
  final bool animate;

  const CoinDisplay({
    super.key,
    required this.coins,
    this.size = 16,
    this.showBackground = true,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size + 12,
          height: size + 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFFFFD700), Color(0xFFFFA600)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFFD700).withOpacity(0.4),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(Icons.monetization_on_rounded,
              size: size, color: const Color(0xFF7A4A00)),
        ),
        const SizedBox(width: 8),
        Text(
          coins.toString(),
          style: AppTextStyles.coin.copyWith(fontSize: size + 2),
        ),
      ],
    );

    if (!showBackground) {
      return animate
          ? content.animate(key: ValueKey(coins)).scale(duration: 260.ms, curve: Curves.elasticOut)
          : content;
    }

    final wrapped = GlassmorphicContainer(
      borderRadius: 24,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      blur: 12,
      child: content,
    );

    return animate
        ? wrapped.animate(key: ValueKey(coins)).scale(duration: 260.ms, curve: Curves.elasticOut)
        : wrapped;
  }
}

class ScoreDisplay extends StatelessWidget {
  final int score;
  final int? best;
  final bool compact;

  const ScoreDisplay({
    super.key,
    required this.score,
    this.best,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Text(
        '$score',
        style: AppTextStyles.score.copyWith(fontSize: 52, color: Colors.white,
          shadows: [
            Shadow(color: Colors.black.withOpacity(0.4), offset: const Offset(0,3), blurRadius: 8),
            Shadow(color: AppColors.primary.withOpacity(0.4), offset: const Offset(0,0), blurRadius: 16),
          ]),
      ).animate().scale(duration: 200.ms);
    }

    return Column(
      children: [
        Text('$score',
            style: AppTextStyles.score.copyWith(
              color: Colors.white,
              shadows: [
                Shadow(color: Colors.black.withOpacity(0.5), offset: const Offset(0,4), blurRadius: 10),
              ],
            )).animate().scale(curve: Curves.elasticOut, duration: 400.ms),
        if (best != null && best! > 0) ...[
          const SizedBox(height: 4),
          GlassmorphicContainer(
            borderRadius: 12,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Text('BEST $best',
                style: AppTextStyles.caption.copyWith(color: Colors.white70, letterSpacing: 1.2)),
          ),
        ],
      ],
    );
  }
}
