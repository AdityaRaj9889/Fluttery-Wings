import 'package:flutter/material.dart';

enum GameThemeType { day, sunset, night, forest, cyber, candy }

class GameThemeData {
  final GameThemeType type;
  final String name;
  final int price;
  final Color skyTop;
  final Color skyBottom;
  final Color groundPrimary;
  final Color groundSecondary;
  final Color pipePrimary;
  final Color pipeSecondary;
  final Color cloudColor;
  final Color accent;

  const GameThemeData({
    required this.type,
    required this.name,
    required this.price,
    required this.skyTop,
    required this.skyBottom,
    required this.groundPrimary,
    required this.groundSecondary,
    required this.pipePrimary,
    required this.pipeSecondary,
    required this.cloudColor,
    required this.accent,
  });

  bool get isFree => price == 0;
}

class GameThemeCatalog {
  GameThemeCatalog._();

  static const List<GameThemeData> all = [
    GameThemeData(
      type: GameThemeType.day,
      name: 'Sunny Day',
      price: 0,
      skyTop: Color(0xFF87CEEB),
      skyBottom: Color(0xFFE0F6FF),
      groundPrimary: Color(0xFF7BC67E),
      groundSecondary: Color(0xFF5A9A5D),
      pipePrimary: Color(0xFF4CAF50),
      pipeSecondary: Color(0xFF388E3C),
      cloudColor: Colors.white,
      accent: Color(0xFF4CAF50),
    ),
    GameThemeData(
      type: GameThemeType.sunset,
      name: 'Sunset',
      price: 120,
      skyTop: Color(0xFFFF8A65),
      skyBottom: Color(0xFFFFCC80),
      groundPrimary: Color(0xFFBF8A5A),
      groundSecondary: Color(0xFF8D6E63),
      pipePrimary: Color(0xFFFF7043),
      pipeSecondary: Color(0xFFBF360C),
      cloudColor: Color(0xFFFFE0B2),
      accent: Color(0xFFFF7043),
    ),
    GameThemeData(
      type: GameThemeType.night,
      name: 'Midnight',
      price: 200,
      skyTop: Color(0xFF0A0E21),
      skyBottom: Color(0xFF1A1D3D),
      groundPrimary: Color(0xFF2C2F4A),
      groundSecondary: Color(0xFF1E2235),
      pipePrimary: Color(0xFF6366F1),
      pipeSecondary: Color(0xFF4338CA),
      cloudColor: Color(0xFF2C2F4A),
      accent: Color(0xFF6366F1),
    ),
    GameThemeData(
      type: GameThemeType.forest,
      name: 'Mystic Forest',
      price: 250,
      skyTop: Color(0xFF2E7D32),
      skyBottom: Color(0xFFA5D6A7),
      groundPrimary: Color(0xFF8BC34A),
      groundSecondary: Color(0xFF558B2F),
      pipePrimary: Color(0xFF795548),
      pipeSecondary: Color(0xFF4E342E),
      cloudColor: Color(0xFFC8E6C9),
      accent: Color(0xFF8BC34A),
    ),
    GameThemeData(
      type: GameThemeType.cyber,
      name: 'Cyber City',
      price: 400,
      skyTop: Color(0xFF120A2A),
      skyBottom: Color(0xFF4A148C),
      groundPrimary: Color(0xFF00E5FF),
      groundSecondary: Color(0xFF00B0FF),
      pipePrimary: Color(0xFF00E676),
      pipeSecondary: Color(0xFF00C853),
      cloudColor: Color(0xFFB388FF),
      accent: Color(0xFF00E5FF),
    ),
    GameThemeData(
      type: GameThemeType.candy,
      name: 'Candy Land',
      price: 350,
      skyTop: Color(0xFFFF80AB),
      skyBottom: Color(0xFFFFE0F0),
      groundPrimary: Color(0xFFF8BBD0),
      groundSecondary: Color(0xFFF48FB1),
      pipePrimary: Color(0xFFBA68C8),
      pipeSecondary: Color(0xFF8E24AA),
      cloudColor: Color(0xFFFCE4EC),
      accent: Color(0xFFE91E63),
    ),
  ];

  static GameThemeData byType(GameThemeType t) =>
      all.firstWhere((e) => e.type == t, orElse: () => all.first);

  static GameThemeData byIndex(int i) => all[i % all.length];
}
