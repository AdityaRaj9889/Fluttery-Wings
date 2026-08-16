import 'package:get/get.dart';
import '../../core/services/storage_service.dart';
import '../../core/services/audio_service.dart';
import '../../core/services/haptic_service.dart';
import '../../features/home/presentation/controllers/home_controller.dart';
import '../../features/game/presentation/controllers/game_controller.dart';
import '../../features/shop/presentation/controllers/shop_controller.dart';
import '../../features/settings/presentation/controllers/settings_controller.dart';
import '../../features/achievements/presentation/controllers/achievements_controller.dart';
import '../../features/daily_reward/presentation/controllers/daily_reward_controller.dart';

class InitialBinding extends Bindings {
  final StorageService storageService;
  InitialBinding(this.storageService);

  @override
  void dependencies() {
    // Services - Singleton
    Get.put<StorageService>(storageService, permanent: true);
    Get.put<AudioService>(AudioService(storageService), permanent: true);
    Get.put<HapticService>(HapticService(storageService), permanent: true);

    // Controllers - Lazy
    Get.lazyPut<HomeController>(() => HomeController(
          storageService: Get.find(),
          audioService: Get.find(),
          hapticService: Get.find(),
        ), fenix: true);

    Get.lazyPut<GameController>(() => GameController(
          storageService: Get.find(),
          audioService: Get.find(),
          hapticService: Get.find(),
        ), fenix: true);

    Get.lazyPut<ShopController>(() => ShopController(
          storageService: Get.find(),
          audioService: Get.find(),
          hapticService: Get.find(),
        ), fenix: true);

    Get.lazyPut<SettingsController>(() => SettingsController(
          storageService: Get.find(),
          audioService: Get.find(),
        ), fenix: true);

    Get.lazyPut<AchievementsController>(() => AchievementsController(
          storageService: Get.find(),
        ), fenix: true);

    Get.lazyPut<DailyRewardController>(() => DailyRewardController(
          storageService: Get.find(),
          audioService: Get.find(),
          hapticService: Get.find(),
        ), fenix: true);
  }
}
