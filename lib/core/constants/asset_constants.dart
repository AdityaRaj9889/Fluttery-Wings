/// Asset path constants - single source of truth.
/// Keeps references typed and refactored-safe.

class AssetConstants {
  AssetConstants._();

  // Birds - procedurally drawn if assets missing, but paths ready for premium sprites
  static const String birdsPath = 'assets/images/birds/';
  static const String birdClassic = '${birdsPath}bird_classic.png';
  static const String birdBlaze = '${birdsPath}bird_blaze.png';
  static const String birdFrost = '${birdsPath}bird_frost.png';
  static const String birdGalaxy = '${birdsPath}bird_galaxy.png';
  static const String birdGolden = '${birdsPath}bird_golden.png';
  static const String birdNinja = '${birdsPath}bird_ninja.png';
  static const String birdRobot = '${birdsPath}bird_robot.png';
  static const String birdPhoenix = '${birdsPath}bird_phoenix.png';

  static List<String> get allBirdAssets => [
        birdClassic,
        birdBlaze,
        birdFrost,
        birdGalaxy,
        birdGolden,
        birdNinja,
        birdRobot,
        birdPhoenix,
      ];

  // Themes / Backgrounds
  static const String themesPath = 'assets/images/themes/';
  static const String themeDay = '${themesPath}bg_day.png';
  static const String themeSunset = '${themesPath}bg_sunset.png';
  static const String themeNight = '${themesPath}bg_night.png';
  static const String themeForest = '${themesPath}bg_forest.png';
  static const String themeCyber = '${themesPath}bg_cyber.png';
  static const String themeCandy = '${themesPath}bg_candy.png';

  // UI
  static const String uiPath = 'assets/images/ui/';
  static const String appIcon = '${uiPath}app_icon.png';
  static const String coinIcon = '${uiPath}coin.png';
  static const String logo = '${uiPath}logo.png';

  // Audio
  static const String audioPath = 'assets/audio/';
  static const String sfxFlap = 'flap.wav';
  static const String sfxCoin = 'coin.wav';
  static const String sfxHit = 'hit.wav';
  static const String sfxScore = 'score.wav';
  static const String sfxButton = 'button.wav';
  static const String sfxDie = 'die.wav';
  static const String bgmMain = 'bgm_main.mp3';
  static const String bgmGame = 'bgm_game.mp3';

  static List<String> get allSfx => [
        sfxFlap,
        sfxCoin,
        sfxHit,
        sfxScore,
        sfxButton,
        sfxDie,
      ];
}
