import 'package:get/get.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/enums/character_type.dart';
import '../../../../core/enums/theme_type.dart';
import '../../../../core/services/audio_service.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/helpers.dart';

class HomeController extends GetxController {
  final StorageService storageService;
  final AudioService audioService;
  final HapticService hapticService;

  HomeController({
    required this.storageService,
    required this.audioService,
    required this.hapticService,
  });

  final RxInt highScore = 0.obs;
  final RxInt totalCoins = 0.obs;
  final Rx<CharacterType> selectedCharacter = CharacterType.classic.obs;
  final Rx<GameThemeType> selectedTheme = GameThemeType.day.obs;
  final RxBool canClaimDaily = false.obs;
  final RxInt dailyStreak = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _load();
    audioService.init();
    audioService.playBgmMain();
  }

  void _load() {
    highScore.value = storageService.highScore;
    totalCoins.value = storageService.totalCoins;
    selectedCharacter.value = storageService.selectedCharacter;
    selectedTheme.value = storageService.selectedTheme;
    dailyStreak.value = storageService.dailyStreak;
    _checkDailyReward();
  }

  void refresh() {
    _load();
  }

  void _checkDailyReward() {
    final last = storageService.lastDailyRewardClaim;
    if (last == null) {
      canClaimDaily.value = true;
      return;
    }
    final now = DateTime.now();
    if (GameHelpers.isSameDay(last, now)) {
      canClaimDaily.value = false;
    } else {
      canClaimDaily.value = true;
    }
  }

  CharacterData get currentCharacterData =>
      CharacterCatalog.byType(selectedCharacter.value);

  GameThemeData get currentThemeData =>
      GameThemeCatalog.byType(selectedTheme.value);

  void selectCharacter(CharacterType type) {
    if (!storageService.unlockedCharacters.contains(type)) return;
    selectedCharacter.value = type;
    storageService.selectedCharacter = type;
    hapticService.selection();
    audioService.playButton();
  }

  void selectTheme(GameThemeType type) {
    if (!storageService.unlockedThemes.contains(type)) return;
    selectedTheme.value = type;
    storageService.selectedTheme = type;
    hapticService.selection();
    audioService.playButton();
  }

  bool canAfford(int price) => totalCoins.value >= price;

  Future<bool> purchaseCharacter(CharacterType type) async {
    final data = CharacterCatalog.byType(type);
    if (storageService.unlockedCharacters.contains(type)) return true;
    if (!canAfford(data.price)) return false;
    totalCoins.value -= data.price;
    storageService.totalCoins = totalCoins.value;
    await storageService.unlockCharacter(type);
    hapticService.medium();
    audioService.playCoin();
    return true;
  }

  Future<bool> purchaseTheme(GameThemeType type) async {
    final data = GameThemeCatalog.byType(type);
    if (storageService.unlockedThemes.contains(type)) return true;
    if (!canAfford(data.price)) return false;
    totalCoins.value -= data.price;
    storageService.totalCoins = totalCoins.value;
    await storageService.unlockTheme(type);
    hapticService.medium();
    audioService.playCoin();
    return true;
  }
}
