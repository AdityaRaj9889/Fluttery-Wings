import 'package:get_storage/get_storage.dart';
import '../constants/app_constants.dart';
import '../enums/character_type.dart';
import '../enums/theme_type.dart';

/// High-performance local storage service abstracting GetStorage.
/// SOLID: Single responsibility, testable.

class StorageService {
  final GetStorage _box;

  StorageService(this._box);

  static Future<StorageService> init() async {
    await GetStorage.init(AppConstants.storageBox);
    final box = GetStorage(AppConstants.storageBox);
    final service = StorageService(box);
    await service._ensureDefaults();
    return service;
  }

  Future<void> _ensureDefaults() async {
    if (!_box.hasData(AppConstants.keyTotalCoins)) {
      await _box.write(AppConstants.keyTotalCoins, AppConstants.starterCoins);
    }
    if (!_box.hasData(AppConstants.keyHighScore)) {
      await _box.write(AppConstants.keyHighScore, 0);
    }
    if (!_box.hasData(AppConstants.keySelectedCharacter)) {
      await _box.write(
          AppConstants.keySelectedCharacter, CharacterType.classic.index);
    }
    if (!_box.hasData(AppConstants.keyUnlockedCharacters)) {
      await _box.write(AppConstants.keyUnlockedCharacters,
          <int>[CharacterType.classic.index]);
    }
    if (!_box.hasData(AppConstants.keySelectedTheme)) {
      await _box
          .write(AppConstants.keySelectedTheme, GameThemeType.day.index);
    }
    if (!_box.hasData(AppConstants.keyUnlockedThemes)) {
      await _box
          .write(AppConstants.keyUnlockedThemes, <int>[GameThemeType.day.index]);
    }
    if (!_box.hasData(AppConstants.keySoundEnabled)) {
      await _box.write(AppConstants.keySoundEnabled, true);
    }
    if (!_box.hasData(AppConstants.keyMusicEnabled)) {
      await _box.write(AppConstants.keyMusicEnabled, true);
    }
    if (!_box.hasData(AppConstants.keyHapticsEnabled)) {
      await _box.write(AppConstants.keyHapticsEnabled, true);
    }
    if (!_box.hasData(AppConstants.keyDailyRewardStreak)) {
      await _box.write(AppConstants.keyDailyRewardStreak, 0);
    }
    if (!_box.hasData(AppConstants.keyTotalGamesPlayed)) {
      await _box.write(AppConstants.keyTotalGamesPlayed, 0);
    }
    if (!_box.hasData(AppConstants.keyTotalFlaps)) {
      await _box.write(AppConstants.keyTotalFlaps, 0);
    }
  }

  // Generic
  T? read<T>(String key) => _box.read<T>(key);
  Future<void> write(String key, dynamic value) => _box.write(key, value);
  bool has(String key) => _box.hasData(key);

  // Typed Helpers

  int get highScore => read<int>(AppConstants.keyHighScore) ?? 0;
  set highScore(int v) => write(AppConstants.keyHighScore, v);

  int get totalCoins => read<int>(AppConstants.keyTotalCoins) ?? 0;
  set totalCoins(int v) => write(AppConstants.keyTotalCoins, v);

  CharacterType get selectedCharacter {
    final idx = read<int>(AppConstants.keySelectedCharacter) ?? 0;
    return CharacterType.values[idx % CharacterType.values.length];
  }

  set selectedCharacter(CharacterType v) =>
      write(AppConstants.keySelectedCharacter, v.index);

  List<CharacterType> get unlockedCharacters {
    final List<dynamic>? raw = read<List>(AppConstants.keyUnlockedCharacters);
    if (raw == null) return [CharacterType.classic];
    return raw.map((e) => CharacterType.values[(e as int) % CharacterType.values.length]).toList();
  }

  Future<void> unlockCharacter(CharacterType type) async {
    final current = unlockedCharacters;
    if (!current.contains(type)) {
      current.add(type);
      await write(AppConstants.keyUnlockedCharacters,
          current.map((e) => e.index).toList());
    }
  }

  GameThemeType get selectedTheme {
    final idx = read<int>(AppConstants.keySelectedTheme) ?? 0;
    return GameThemeType.values[idx % GameThemeType.values.length];
  }

  set selectedTheme(GameThemeType v) =>
      write(AppConstants.keySelectedTheme, v.index);

  List<GameThemeType> get unlockedThemes {
    final List<dynamic>? raw = read<List>(AppConstants.keyUnlockedThemes);
    if (raw == null) return [GameThemeType.day];
    return raw
        .map((e) => GameThemeType.values[(e as int) % GameThemeType.values.length])
        .toList();
  }

  Future<void> unlockTheme(GameThemeType type) async {
    final current = unlockedThemes;
    if (!current.contains(type)) {
      current.add(type);
      await write(AppConstants.keyUnlockedThemes,
          current.map((e) => e.index).toList());
    }
  }

  bool get soundEnabled => read<bool>(AppConstants.keySoundEnabled) ?? true;
  set soundEnabled(bool v) => write(AppConstants.keySoundEnabled, v);

  bool get musicEnabled => read<bool>(AppConstants.keyMusicEnabled) ?? true;
  set musicEnabled(bool v) => write(AppConstants.keyMusicEnabled, v);

  bool get hapticsEnabled => read<bool>(AppConstants.keyHapticsEnabled) ?? true;
  set hapticsEnabled(bool v) => write(AppConstants.keyHapticsEnabled, v);

  DateTime? get lastDailyRewardClaim {
    final iso = read<String>(AppConstants.keyDailyRewardLastClaim);
    if (iso == null) return null;
    return DateTime.tryParse(iso);
  }

  set lastDailyRewardClaim(DateTime? v) => write(
      AppConstants.keyDailyRewardLastClaim, v?.toIso8601String());

  int get dailyStreak => read<int>(AppConstants.keyDailyRewardStreak) ?? 0;
  set dailyStreak(int v) => write(AppConstants.keyDailyRewardStreak, v);

  int get totalGamesPlayed =>
      read<int>(AppConstants.keyTotalGamesPlayed) ?? 0;
  set totalGamesPlayed(int v) =>
      write(AppConstants.keyTotalGamesPlayed, v);

  int get totalFlaps => read<int>(AppConstants.keyTotalFlaps) ?? 0;
  set totalFlaps(int v) => write(AppConstants.keyTotalFlaps, v);

  Map<String, dynamic> get achievements {
    final raw = read<Map>(AppConstants.keyAchievements);
    if (raw == null) return {};
    return Map<String, dynamic>.from(raw as Map);
  }

  set achievements(Map<String, dynamic> v) =>
      write(AppConstants.keyAchievements, v);
}
