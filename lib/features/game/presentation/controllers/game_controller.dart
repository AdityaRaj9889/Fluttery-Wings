import 'package:get/get.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/enums/character_type.dart';
import '../../../../core/enums/game_state.dart';
import '../../../../core/enums/theme_type.dart';
import '../../../../core/services/audio_service.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../game/domain/entities/score_entry.dart';

class GameController extends GetxController {
  final StorageService storageService;
  final AudioService audioService;
  final HapticService hapticService;

  GameController({
    required this.storageService,
    required this.audioService,
    required this.hapticService,
  });

  // Reactive State
  final Rx<GameState> gameState = GameState.ready.obs;
  final RxInt currentScore = 0.obs;
  final RxInt sessionCoins = 0.obs;
  final RxInt highScore = 0.obs;
  final RxInt totalCoins = 0.obs;
  final RxBool isNewHigh = false.obs;

  // Selected
  late Rx<CharacterType> selectedCharacterType;
  late Rx<GameThemeType> selectedThemeType;

  @override
  void onInit() {
    super.onInit();
    highScore.value = storageService.highScore;
    totalCoins.value = storageService.totalCoins;
    selectedCharacterType = storageService.selectedCharacter.obs;
    selectedThemeType = storageService.selectedTheme.obs;
  }

  CharacterData get selectedCharacter =>
      CharacterCatalog.byType(selectedCharacterType.value);

  GameThemeData get selectedTheme =>
      GameThemeCatalog.byType(selectedThemeType.value);

  void onGameStarted() {
    gameState.value = GameState.playing;
    currentScore.value = 0;
    sessionCoins.value = 0;
    isNewHigh.value = false;
    audioService.playBgmGame();
  }

  // NEW: Freeze flow per user request
  void freezeScreen() {
    gameState.value = GameState.frozen;
  }

  void showTapToFlap() {
    gameState.value = GameState.ready;
  }

  void onGameRevived() {
    // Keep score, don't reset - true resume
    gameState.value = GameState.playing;
    isNewHigh.value = false;
    audioService.playBgmGame();
  }

  void onScore(int score) {
    currentScore.value = score;
    hapticService.selection();
    audioService.playScore();
    if (score > highScore.value) {
      highScore.value = score;
      isNewHigh.value = true;
      storageService.highScore = score;
    }
  }

  void onFlap() {
    storageService.totalFlaps = storageService.totalFlaps + 1;
    audioService.playFlap();
    hapticService.light();
    // Stats for achievement progress
    _checkFlapAchievements();
  }

  void onCoinCollected(int sessionCount) {
    sessionCoins.value = sessionCount;
    totalCoins.value += AppConstants.coinValue;
    storageService.totalCoins = totalCoins.value;
    audioService.playCoin();
    hapticService.medium();
  }

  Future<void> onGameOver(int finalScore, int coins) async {
    gameState.value = GameState.gameOver;
    audioService.playDie();
    audioService.playBgmMain();
    hapticService.heavy();

    // Increment stats
    storageService.totalGamesPlayed = storageService.totalGamesPlayed + 1;

    // Save score to leaderboard (local)
    await _saveScore(finalScore, coins);

    // Check achievements
    _evaluateAchievements(finalScore);
  }

  // NEW: Rewarded ad coins
  void addRewardCoins(int amount) {
    totalCoins.value += amount;
    storageService.totalCoins = totalCoins.value;
    audioService.playCoin();
    hapticService.medium();
  }

  Future<void> _saveScore(int finalScore, int coins) async {
    final entry = ScoreEntry(
      score: finalScore,
      coinsCollected: coins,
      date: DateTime.now(),
    );
    // Read existing list
    final raw = storageService.read<List>('leaderboard_v1');
    List<Map<String, dynamic>> list = [];
    if (raw != null) {
      list = raw.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    }
    list.add(entry.toJson());
    list.sort((a, b) => (b['score'] as int).compareTo(a['score'] as int));
    if (list.length > 50) list = list.take(50).toList();
    await storageService.write('leaderboard_v1', list);
  }

  void resetGame() {
    gameState.value = GameState.ready;
    currentScore.value = 0;
    sessionCoins.value = 0;
    isNewHigh.value = false;
  }

  void _checkFlapAchievements() {
    // Flap achievement will be checked in achievements controller separately
  }

  void _evaluateAchievements(int score) {
    // Trigger achievements controller if present
    try {
      // Will be handled by AchievementsController reading from storage stats
    } catch (_) {}
  }

  List<ScoreEntry> getLeaderboard() {
    final raw = storageService.read<List>('leaderboard_v1');
    if (raw == null) return [];
    return raw
        .map((e) => ScoreEntry.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }
}
