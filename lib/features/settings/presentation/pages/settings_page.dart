import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/glassmorphic_container.dart';
import '../../../../core/widgets/premium_button.dart';
import '../controllers/settings_controller.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    IconGlassButton(icon: Icons.arrow_back_rounded, onPressed: () => Get.back()),
                    const SizedBox(width: 12),
                    Text('SETTINGS', style: AppTextStyles.headlineMedium.copyWith(color: Colors.white)),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  children: [
                    _sectionTitle('AUDIO & FEEDBACK'),
                    const SizedBox(height: 10),
                    Obx(() => _toggleTile(
                          icon: Icons.volume_up_rounded,
                          title: 'Sound Effects',
                          subtitle: 'Flap, coin, hit sounds',
                          value: controller.soundEnabled.value,
                          onChanged: controller.toggleSound,
                        )),
                    const SizedBox(height: 10),
                    Obx(() => _toggleTile(
                          icon: Icons.music_note_rounded,
                          title: 'Music',
                          subtitle: 'Background music',
                          value: controller.musicEnabled.value,
                          onChanged: controller.toggleMusic,
                        )),
                    const SizedBox(height: 10),
                    Obx(() => _toggleTile(
                          icon: Icons.vibration_rounded,
                          title: 'Haptics',
                          subtitle: 'Vibration feedback',
                          value: controller.hapticsEnabled.value,
                          onChanged: controller.toggleHaptics,
                        )),

                    const SizedBox(height: 26),
                    _sectionTitle('ABOUT'),
                    const SizedBox(height: 10),
                    GlassmorphicContainer(
                      borderRadius: 18,
                      child: Column(
                        children: [
                          _infoRow('Version', '1.0.0 (Play Store Ready)'),
                          Divider(color: Colors.white.withOpacity(0.08)),
                          _infoRow('Engine', 'Flutter 3.24.5 • Flame • GetX'),
                          Divider(color: Colors.white.withOpacity(0.08)),
                          _infoRow('Made with', '♥️ AAA Quality'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 26),
                    _sectionTitle('DANGER ZONE'),
                    const SizedBox(height: 10),
                    GlassmorphicContainer(
                      borderRadius: 18,
                      gradient: LinearGradient(colors: [AppColors.error.withOpacity(0.22), AppColors.error.withOpacity(0.06)]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.warning_rounded, color: AppColors.error, size: 20),
                              const SizedBox(width: 8),
                              Text('Reset all progress', style: AppTextStyles.titleMedium.copyWith(color: Colors.white)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text('This will delete your high score, coins (keeps 50 starter) and unlocks. Cannot be undone.',
                              style: AppTextStyles.bodySmall.copyWith(color: Colors.white70)),
                          const SizedBox(height: 14),
                          PremiumButton(
                            text: 'RESET PROGRESS',
                            variant: PremiumButtonVariant.danger,
                            icon: Icons.delete_forever_rounded,
                            isExpanded: true,
                            onPressed: () => _confirmReset(context),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String t) => Text(t,
      style: AppTextStyles.labelSmall.copyWith(
          letterSpacing: 1.4, color: Colors.white.withOpacity(0.6), fontWeight: FontWeight.w700));

  Widget _toggleTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return GlassmorphicContainer(
      borderRadius: 16,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.titleMedium.copyWith(color: Colors.white)),
                Text(subtitle, style: AppTextStyles.bodySmall.copyWith(fontSize: 11, color: Colors.white60)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
            thumbColor: WidgetStateProperty.all(Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(k, style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70)),
            Text(v, style: AppTextStyles.bodySmall.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
          ],
        ),
      );

  void _confirmReset(BuildContext context) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: GlassmorphicContainer(
          borderRadius: 20,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning_amber_rounded, size: 44, color: AppColors.error),
              const SizedBox(height: 12),
              Text('Reset everything?', style: AppTextStyles.headlineMedium.copyWith(color: Colors.white)),
              const SizedBox(height: 8),
              Text('You will lose all coins and unlocks.',
                  style: AppTextStyles.bodySmall.copyWith(color: Colors.white70), textAlign: TextAlign.center),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: PremiumButton(
                        text: 'CANCEL',
                        variant: PremiumButtonVariant.ghost,
                        onPressed: () => Get.back()),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: PremiumButton(
                        text: 'RESET',
                        variant: PremiumButtonVariant.danger,
                        onPressed: () async {
                          await controller.resetProgress();
                          Get.back();
                          Get.snackbar('Reset done', 'Progress cleared',
                              backgroundColor: AppColors.surfaceBright, colorText: Colors.white);
                        }),
                  ),
                ],
              ),
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
  const IconGlassButton({super.key, required this.icon, this.onPressed, this.size = 48});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.14),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Icon(icon, color: Colors.white, size: size * 0.5),
      ),
    );
  }
}
