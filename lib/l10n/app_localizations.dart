import 'package:flutter/material.dart';

/// Minimal localization hook for future .arb integration.
/// Ready for Play Store internationalization.

class AppLocalizations {
  final Locale locale;
  const AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        const AppLocalizations(Locale('en', 'US'));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const supportedLocales = [
    Locale('en', 'US'),
    Locale('es', 'ES'),
    Locale('fr', 'FR'),
    Locale('de', 'DE'),
    Locale('hi', 'IN'),
  ];

  String get appName => _localizedValues[locale.languageCode]?['appName'] ?? 'Fluttery Wings';
  String get playNow => _localizedValues[locale.languageCode]?['playNow'] ?? 'PLAY NOW';
  String get shop => _localizedValues[locale.languageCode]?['shop'] ?? 'SHOP';
  String get settings => _localizedValues[locale.languageCode]?['settings'] ?? 'SETTINGS';
  String get gameOver => _localizedValues[locale.languageCode]?['gameOver'] ?? 'GAME OVER';

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appName': 'Fluttery Wings',
      'playNow': 'PLAY NOW',
      'shop': 'SHOP',
      'settings': 'SETTINGS',
      'gameOver': 'GAME OVER',
    },
    'es': {
      'appName': 'Alas Revoloteando',
      'playNow': 'JUGAR AHORA',
      'shop': 'TIENDA',
      'settings': 'AJUSTES',
      'gameOver': 'FIN DEL JUEGO',
    },
    'hi': {
      'appName': 'फ्लटरी विंग्स',
      'playNow': 'अब खेलें',
      'shop': 'दुकान',
      'settings': 'सेटिंग्स',
      'gameOver': 'खेल समाप्त',
    },
  };
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'es', 'fr', 'de', 'hi'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
