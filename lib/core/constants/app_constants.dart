/// Centralized game tuning and app-wide constants.
/// Production-ready, no magic numbers in components.

class AppConstants {
  AppConstants._();

  // App
  static const String appName = 'Fluttery Wings';
  static const String storageBox = 'fluttery_wings_box';

  // Physics - Tuned for 60fps premium feel
  static const double gravity = 920.0;
  static const double flapImpulse = -360.0;
  static const double maxFallVelocity = 460.0;
  static const double birdRadius = 24.0;

  // Bird rotation
  static const double maxUpRotation = -0.45;
  static const double maxDownRotation = 1.35;
  static const double rotationLerpFactor = 4.5;

  // World Speed - Dynamic difficulty
  static const double baseWorldSpeed = 180.0;
  static const double maxWorldSpeed = 340.0;
  static const double speedIncrementPerScore = 1.8;

  // Pipes
  static const double pipeWidth = 78.0;
  static const double pipeGap = 158.0;
  static const double pipeMinHeight = 60.0;
  static const double pipeSpacing = 280.0;
  static const double pipeSpawnXOffset = 100.0;

  // Ground
  static const double groundHeight = 86.0;

  // Coins
  static const double coinSize = 28.0;
  static const int coinValue = 1;
  static const double coinSpawnChance = 0.62;

  // Scoring
  static const int scorePerPipe = 1;

  // Storage Keys
  static const String keyHighScore = 'high_score';
  static const String keyTotalCoins = 'total_coins';
  static const String keySelectedCharacter = 'selected_character';
  static const String keyUnlockedCharacters = 'unlocked_characters';
  static const String keySelectedTheme = 'selected_theme';
  static const String keyUnlockedThemes = 'unlocked_themes';
  static const String keySoundEnabled = 'sound_enabled';
  static const String keyMusicEnabled = 'music_enabled';
  static const String keyHapticsEnabled = 'haptics_enabled';
  static const String keyDailyRewardLastClaim = 'daily_reward_last_claim';
  static const String keyDailyRewardStreak = 'daily_reward_streak';
  static const String keyAchievements = 'achievements_progress';
  static const String keyTotalGamesPlayed = 'total_games_played';
  static const String keyTotalFlaps = 'total_flaps';
  static const String keyFirstLaunch = 'first_launch_done';

  // Achievements thresholds
  static const int achievementFirstFlightScore = 1;
  static const int achievementSoaring10 = 10;
  static const int achievementPilot25 = 25;
  static const int achievementAce50 = 50;
  static const int achievementLegend100 = 100;
  static const int achievementRich100Coins = 100;
  static const int achievementRich500Coins = 500;
  static const int achievementGames10 = 10;
  static const int achievementGames50 = 50;

  // Shop
  static const int starterCoins = 50;

  // Ads
  static const String testBannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
  static const String testInterstitialAdUnitId =
      'ca-app-pub-3940256099942544/1033173712';
  static const String testRewardedAdUnitId =
      'ca-app-pub-3940256099942544/5224354917';

  // Daily Rewards - 7 Day cycle
  static const List<int> dailyRewards = [50, 75, 100, 150, 200, 300, 500];

  // Animation Durations
  static const Duration shortAnim = Duration(milliseconds: 180);
  static const Duration mediumAnim = Duration(milliseconds: 320);
  static const Duration longAnim = Duration(milliseconds: 520);
}
