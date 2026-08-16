import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/glassmorphic_container.dart';
import '../../../../core/widgets/premium_button.dart';

class ShopItemCard extends StatelessWidget {
  final String title;
  final String description;
  final int price;
  final IconData icon;
  final Color color;
  final List<Color>? gradientColors;
  final bool isUnlocked;
  final bool isSelected;
  final VoidCallback onTap;

  const ShopItemCard({
    super.key,
    required this.title,
    required this.description,
    required this.price,
    required this.icon,
    required this.color,
    this.gradientColors,
    required this.isUnlocked,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      borderRadius: 20,
      padding: EdgeInsets.zero,
      borderColor: isSelected
          ? Colors.white.withOpacity(0.5)
          : Colors.white.withOpacity(0.14),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          isSelected ? color.withOpacity(0.35) : Colors.white.withOpacity(0.08),
          isSelected ? color.withOpacity(0.12) : Colors.white.withOpacity(0.03),
        ],
      ),
      child: Stack(
        children: [
          // Top color preview
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 92,
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                gradient: LinearGradient(
                  colors: gradientColors ??
                      [color, Color.lerp(color, Colors.black, 0.25)!],
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(icon, size: 46, color: Colors.white.withOpacity(0.95)),
                  if (isSelected)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        child:
                            Icon(Icons.check_rounded, size: 14, color: color),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Content
          Positioned.fill(
            top: 92,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Text(title,
                      style: AppTextStyles.titleMedium
                          .copyWith(color: Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(description,
                      style: AppTextStyles.bodySmall
                          .copyWith(fontSize: 10, color: Colors.white70),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center),
                  const Spacer(),
                  if (isUnlocked)
                    PremiumButton(
                      text: isSelected ? 'EQUIPPED' : 'EQUIP',
                      variant: isSelected
                          ? PremiumButtonVariant.success
                          : PremiumButtonVariant.primary,
                      height: 41,
                      borderRadius: 12,
                      isExpanded: true,
                      onPressed: isSelected ? null : onTap,
                    )
                  else
                    PremiumButton(
                      text: '$price',
                      icon: Icons.monetization_on_rounded,
                      variant: PremiumButtonVariant.ghost,
                      height: 41,
                      borderRadius: 12,
                      isExpanded: true,
                      onPressed: onTap,
                    ),
                ],
              ),
            ),
          ),

          if (!isUnlocked)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white.withOpacity(0.15)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock_rounded,
                        size: 10, color: Colors.white.withOpacity(0.9)),
                    const SizedBox(width: 3),
                    Text('$price',
                        style: AppTextStyles.labelSmall
                            .copyWith(color: Colors.white, fontSize: 9)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
