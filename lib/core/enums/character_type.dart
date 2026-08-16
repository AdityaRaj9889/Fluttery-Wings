import 'package:flutter/material.dart';

enum CharacterType {
  classic,
  blaze,
  frost,
  galaxy,
  golden,
  ninja,
  robot,
  phoenix,
}

class CharacterData {
  final CharacterType type;
  final String name;
  final String description;
  final int price;
  final Color primaryColor;
  final Color secondaryColor;
  final IconData icon;
  final double flapBoost; // 1.0 normal
  final double gravityModifier;

  const CharacterData({
    required this.type,
    required this.name,
    required this.description,
    required this.price,
    required this.primaryColor,
    required this.secondaryColor,
    required this.icon,
    this.flapBoost = 1.0,
    this.gravityModifier = 1.0,
  });

  bool get isFree => price == 0;
}

class CharacterCatalog {
  CharacterCatalog._();

  static const List<CharacterData> all = [
    CharacterData(
      type: CharacterType.classic,
      name: 'Classic',
      description: 'The original fluttery hero',
      price: 0,
      primaryColor: Color(0xFFFFD93D),
      secondaryColor: Color(0xFFFF6B6B),
      icon: Icons.flutter_dash_rounded,
    ),
    CharacterData(
      type: CharacterType.blaze,
      name: 'Blaze',
      description: 'Burns through the sky',
      price: 150,
      primaryColor: Color(0xFFFF6B35),
      secondaryColor: Color(0xFFF7931E),
      icon: Icons.local_fire_department_rounded,
      flapBoost: 1.05,
    ),
    CharacterData(
      type: CharacterType.frost,
      name: 'Frost',
      description: 'Cool and stable flight',
      price: 200,
      primaryColor: Color(0xFF74B9FF),
      secondaryColor: Color(0xFF0984E3),
      icon: Icons.ac_unit_rounded,
      gravityModifier: 0.95,
    ),
    CharacterData(
      type: CharacterType.galaxy,
      name: 'Galaxy',
      description: 'From outer space',
      price: 350,
      primaryColor: Color(0xFF6C5CE7),
      secondaryColor: Color(0xFFA29BFE),
      icon: Icons.auto_awesome_rounded,
    ),
    CharacterData(
      type: CharacterType.golden,
      name: 'Golden',
      description: '2x coin magnet range',
      price: 500,
      primaryColor: Color(0xFFFFD700),
      secondaryColor: Color(0xFFFFA600),
      icon: Icons.star_rounded,
      flapBoost: 1.08,
    ),
    CharacterData(
      type: CharacterType.ninja,
      name: 'Ninja',
      description: 'Slim hitbox, swift moves',
      price: 400,
      primaryColor: Color(0xFF2D3436),
      secondaryColor: Color(0xFF636E72),
      icon: Icons.sports_martial_arts_rounded,
      gravityModifier: 0.92,
    ),
    CharacterData(
      type: CharacterType.robot,
      name: 'Robo',
      description: 'Precision engineering',
      price: 600,
      primaryColor: Color(0xFF00CEC9),
      secondaryColor: Color(0xFF00B894),
      icon: Icons.smart_toy_rounded,
    ),
    CharacterData(
      type: CharacterType.phoenix,
      name: 'Phoenix',
      description: 'Legendary rebirth power',
      price: 1000,
      primaryColor: Color(0xFFD63031),
      secondaryColor: Color(0xFFFF7675),
      icon: Icons.whatshot_rounded,
      flapBoost: 1.12,
      gravityModifier: 0.9,
    ),
  ];

  static CharacterData byType(CharacterType t) =>
      all.firstWhere((e) => e.type == t, orElse: () => all.first);

  static CharacterData byIndex(int i) => all[i % all.length];
}
