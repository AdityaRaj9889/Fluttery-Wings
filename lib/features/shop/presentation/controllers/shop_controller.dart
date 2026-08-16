import 'package:get/get.dart';
import '../../../../core/enums/character_type.dart';
import '../../../../core/enums/theme_type.dart';
import '../../../../core/services/audio_service.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../home/presentation/controllers/home_controller.dart';

class ShopController extends GetxController {
  final StorageService storageService;
  final AudioService audioService;
  final HapticService hapticService;

  ShopController({
    required this.storageService,
    required this.audioService,
    required this.hapticService,
  });

  final RxInt totalCoins = 0.obs;
  final RxList<CharacterType> unlockedCharacters = <CharacterType>[].obs;
  final RxList<GameThemeType> unlockedThemes = <GameThemeType>[].obs;
  final Rx<CharacterType> selectedCharacter = CharacterType.classic.obs;
  final Rx<GameThemeType> selectedTheme = GameThemeType.day.obs;
  final RxInt tabIndex = 0.obs; // 0 characters, 1 themes

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  void _load() {
    totalCoins.value = storageService.totalCoins;
    unlockedCharacters.value = storageService.unlockedCharacters;
    unlockedThemes.value = storageService.unlockedThemes;
    selectedCharacter.value = storageService.selectedCharacter;
    selectedTheme.value = storageService.selectedTheme;
  }

  void reload() => _load();

  bool isCharacterUnlocked(CharacterType t) => unlockedCharacters.contains(t);

  bool isThemeUnlocked(GameThemeType t) => unlockedThemes.contains(t);

  bool get isCharacterTab => tabIndex.value == 0;

  void setTab(int i) {
    tabIndex.value = i;
    audioService.playButton();
    hapticService.selection();
  }

  // Sync HomeController in real-time for premium UX
  void _syncHome() {
    try {
      if (Get.isRegistered<HomeController>()) {
        final home = Get.find<HomeController>();
        home.totalCoins.value = totalCoins.value;
        home.selectedCharacter.value = selectedCharacter.value;
        home.selectedTheme.value = selectedTheme.value;
        home.refresh(); // also recalculates canClaim etc
      }
    } catch (_) {}
  }

  Future<bool> buyCharacter(CharacterType type) async {
    final data = CharacterCatalog.byType(type);
    if (isCharacterUnlocked(type)) {
      selectCharacter(type);
      return true;
    }
    if (totalCoins.value < data.price) return false;
    totalCoins.value -= data.price;
    storageService.totalCoins = totalCoins.value;
    await storageService.unlockCharacter(type);
    unlockedCharacters.add(type);
    selectCharacter(type);
    audioService.playCoin();
    hapticService.medium();
    _syncHome();
    return true;
  }

  Future<bool> buyTheme(GameThemeType type) async {
    final data = GameThemeCatalog.byType(type);
    if (isThemeUnlocked(type)) {
      selectTheme(type);
      return true;
    }
    if (totalCoins.value < data.price) return false;
    totalCoins.value -= data.price;
    storageService.totalCoins = totalCoins.value;
    await storageService.unlockTheme(type);
    unlockedThemes.add(type);
    selectTheme(type);
    audioService.playCoin();
    hapticService.medium();
    _syncHome();
    return true;
  }

  void selectCharacter(CharacterType type) {
    if (!isCharacterUnlocked(type)) return;
    selectedCharacter.value = type;
    storageService.selectedCharacter = type;
    audioService.playButton();
    hapticService.light();
    _syncHome();
  }

  void selectTheme(GameThemeType type) {
    if (!isThemeUnlocked(type)) return;
    selectedTheme.value = type;
    storageService.selectedTheme = type;
    audioService.playButton();
    hapticService.light();
    _syncHome();
  }
}
