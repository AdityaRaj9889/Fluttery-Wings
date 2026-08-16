import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/enums/character_type.dart';
import '../../../../core/enums/theme_type.dart';
import '../../../../core/widgets/glassmorphic_container.dart';
import '../../../../core/widgets/premium_button.dart';
import '../../../../core/widgets/coin_display.dart';
import '../controllers/shop_controller.dart';
import '../widgets/shop_item_card.dart';

class ShopPage extends GetView<ShopController> {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    IconGlassButton(
                      icon: Icons.arrow_back_rounded,
                      onPressed: () => Get.back(),
                    ),
                    const SizedBox(width: 12),
                    Text('SHOP', style: AppTextStyles.headlineMedium.copyWith(color: Colors.white)),
                    const Spacer(),
                    Obx(() => CoinDisplay(coins: controller.totalCoins.value)),
                  ],
                ),
              ),

              // Tabs
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Obx(() => Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white.withOpacity(0.12)),
                      ),
                      child: Row(
                        children: [
                          _tabButton('CHARACTERS', 0, Icons.flutter_dash_rounded),
                          _tabButton('THEMES', 1, Icons.palette_rounded),
                        ],
                      ),
                    )),
              ),

              const SizedBox(height: 8),

              // Content
              Expanded(
                child: Obx(() {
                  if (controller.isCharacterTab) {
                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.78,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: CharacterCatalog.all.length,
                      itemBuilder: (context, i) {
                        final data = CharacterCatalog.all[i];
                        return Obx(() => ShopItemCard(
                              title: data.name,
                              description: data.description,
                              price: data.price,
                              icon: data.icon,
                              color: data.primaryColor,
                              isUnlocked: controller.isCharacterUnlocked(data.type),
                              isSelected: controller.selectedCharacter.value == data.type,
                              onTap: () async {
                                final ok = await controller.buyCharacter(data.type);
                                if (!ok && context.mounted) {
                                  Get.snackbar('Not enough coins',
                                      'Keep playing to earn more!',
                                      backgroundColor: AppColors.surfaceBright,
                                      colorText: Colors.white);
                                }
                              },
                            )
                                .animate()
                                .fadeIn(delay: (i * 60).ms)
                                .slideY(begin: 0.15));
                      },
                    );
                  } else {
                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.82,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: GameThemeCatalog.all.length,
                      itemBuilder: (context, i) {
                        final data = GameThemeCatalog.all[i];
                        return Obx(() => ShopItemCard(
                              title: data.name,
                              description: 'Sky: ${data.type.name}',
                              price: data.price,
                              icon: Icons.landscape_rounded,
                              color: data.accent,
                              gradientColors: [data.skyTop, data.skyBottom],
                              isUnlocked: controller.isThemeUnlocked(data.type),
                              isSelected: controller.selectedTheme.value == data.type,
                              onTap: () async {
                                final ok = await controller.buyTheme(data.type);
                                if (!ok && context.mounted) {
                                  Get.snackbar('Not enough coins',
                                      'Keep playing to earn more!',
                                      backgroundColor: AppColors.surfaceBright,
                                      colorText: Colors.white);
                                }
                              },
                            )
                                .animate()
                                .fadeIn(delay: (i * 60).ms)
                                .slideY(begin: 0.15));
                      },
                    );
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabButton(String label, int index, IconData icon) {
    final isSel = controller.tabIndex.value == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.setTab(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSel ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSel
                ? [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 12,
                        offset: const Offset(0, 4))
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 18,
                  color: isSel ? AppColors.background : Colors.white70),
              const SizedBox(width: 6),
              Text(label,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: isSel ? AppColors.background : Colors.white70,
                    fontWeight: FontWeight.w700,
                  )),
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
  final double size;
  final Color? color;

  const IconGlassButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 48,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: (color ?? Colors.white).withOpacity(0.14),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: Icon(icon, color: Colors.white, size: size * 0.5),
        ),
      ),
    );
  }
}
