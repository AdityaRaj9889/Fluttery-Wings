import 'package:get/get.dart';
import '../../../../core/services/audio_service.dart';
import '../../../../core/services/storage_service.dart';

class SettingsController extends GetxController {
  final StorageService storageService;
  final AudioService audioService;

  SettingsController({
    required this.storageService,
    required this.audioService,
  });

  final RxBool soundEnabled = true.obs;
  final RxBool musicEnabled = true.obs;
  final RxBool hapticsEnabled = true.obs;

  @override
  void onInit() {
    super.onInit();
    soundEnabled.value = storageService.soundEnabled;
    musicEnabled.value = storageService.musicEnabled;
    hapticsEnabled.value = storageService.hapticsEnabled;
  }

  Future<void> toggleSound(bool v) async {
    soundEnabled.value = v;
    storageService.soundEnabled = v;
    audioService.setSoundEnabled(v);
    if (v) await audioService.playButton();
  }

  Future<void> toggleMusic(bool v) async {
    musicEnabled.value = v;
    storageService.musicEnabled = v;
    await audioService.setMusicEnabled(v);
    if (v) {
      await audioService.playBgmMain();
    }
  }

  Future<void> toggleHaptics(bool v) async {
    hapticsEnabled.value = v;
    storageService.hapticsEnabled = v;
  }

  Future<void> resetProgress() async {
    // Keep settings but reset game data
    await storageService.write('leaderboard_v1', []);
    storageService.highScore = 0;
    storageService.totalCoins = 50;
    storageService.totalGamesPlayed = 0;
    storageService.totalFlaps = 0;
    // Keep classic unlocked only
    await storageService.write('unlocked_characters', [0]);
    await storageService.write('unlocked_themes', [0]);
  }
}
