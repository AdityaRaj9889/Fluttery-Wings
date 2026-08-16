import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum AchievementTier { bronze, silver, gold, platinum }

class Achievement extends Equatable {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final AchievementTier tier;
  final int target;
  final int rewardCoins;
  final bool Function(int score, int coins, int games, int flaps) evaluator;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.tier,
    required this.target,
    required this.rewardCoins,
    required this.evaluator,
  });

  Color get tierColor {
    switch (tier) {
      case AchievementTier.bronze:
        return const Color(0xFFCD7F32);
      case AchievementTier.silver:
        return const Color(0xFFB0B0B0);
      case AchievementTier.gold:
        return const Color(0xFFFFD700);
      case AchievementTier.platinum:
        return const Color(0xFF6C5CE7);
    }
  }

  @override
  List<Object?> get props => [id, title];
}

class AchievementProgress extends Equatable {
  final String id;
  final int current;
  final bool unlocked;
  final DateTime? unlockedAt;

  const AchievementProgress({
    required this.id,
    required this.current,
    required this.unlocked,
    this.unlockedAt,
  });

  AchievementProgress copyWith({int? current, bool? unlocked, DateTime? unlockedAt}) {
    return AchievementProgress(
      id: id,
      current: current ?? this.current,
      unlocked: unlocked ?? this.unlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'current': current,
        'unlocked': unlocked,
        'unlockedAt': unlockedAt?.toIso8601String(),
      };

  factory AchievementProgress.fromJson(Map<String, dynamic> json) =>
      AchievementProgress(
        id: json['id'] as String,
        current: json['current'] as int? ?? 0,
        unlocked: json['unlocked'] as bool? ?? false,
        unlockedAt: json['unlockedAt'] != null
            ? DateTime.tryParse(json['unlockedAt'] as String)
            : null,
      );

  @override
  List<Object?> get props => [id, current, unlocked, unlockedAt];
}

class AchievementCatalog {
  AchievementCatalog._();

  static final List<Achievement> all = [
    Achievement(
      id: 'first_flight',
      title: 'First Flight',
      description: 'Score your first point',
      icon: Icons.flight_takeoff_rounded,
      tier: AchievementTier.bronze,
      target: 1,
      rewardCoins: 20,
      evaluator: (s, c, g, f) => s >= 1,
    ),
    Achievement(
      id: 'soaring_10',
      title: 'Soaring',
      description: 'Reach 10 points',
      icon: Icons.airplanemode_active_rounded,
      tier: AchievementTier.bronze,
      target: 10,
      rewardCoins: 40,
      evaluator: (s, c, g, f) => s >= 10,
    ),
    Achievement(
      id: 'pilot_25',
      title: 'Skilled Pilot',
      description: 'Reach 25 points',
      icon: Icons.rocket_launch_rounded,
      tier: AchievementTier.silver,
      target: 25,
      rewardCoins: 75,
      evaluator: (s, c, g, f) => s >= 25,
    ),
    Achievement(
      id: 'ace_50',
      title: 'Flying Ace',
      description: 'Reach 50 points',
      icon: Icons.military_tech_rounded,
      tier: AchievementTier.gold,
      target: 50,
      rewardCoins: 150,
      evaluator: (s, c, g, f) => s >= 50,
    ),
    Achievement(
      id: 'legend_100',
      title: 'Legend',
      description: 'Reach 100 points',
      icon: Icons.emoji_events_rounded,
      tier: AchievementTier.platinum,
      target: 100,
      rewardCoins: 400,
      evaluator: (s, c, g, f) => s >= 100,
    ),
    Achievement(
      id: 'coin_100',
      title: 'Collector',
      description: 'Collect 100 coins total',
      icon: Icons.monetization_on_rounded,
      tier: AchievementTier.silver,
      target: 100,
      rewardCoins: 100,
      evaluator: (s, c, g, f) => c >= 100,
    ),
    Achievement(
      id: 'coin_500',
      title: 'Tycoon',
      description: 'Collect 500 coins total',
      icon: Icons.account_balance_wallet_rounded,
      tier: AchievementTier.gold,
      target: 500,
      rewardCoins: 250,
      evaluator: (s, c, g, f) => c >= 500,
    ),
    Achievement(
      id: 'games_10',
      title: 'Persistent',
      description: 'Play 10 games',
      icon: Icons.repeat_rounded,
      tier: AchievementTier.bronze,
      target: 10,
      rewardCoins: 50,
      evaluator: (s, c, g, f) => g >= 10,
    ),
    Achievement(
      id: 'games_50',
      title: 'Addicted',
      description: 'Play 50 games',
      icon: Icons.favorite_rounded,
      tier: AchievementTier.silver,
      target: 50,
      rewardCoins: 120,
      evaluator: (s, c, g, f) => g >= 50,
    ),
    Achievement(
      id: 'flaps_500',
      title: 'Flappy Master',
      description: 'Flap 500 times',
      icon: Icons.touch_app_rounded,
      tier: AchievementTier.gold,
      target: 500,
      rewardCoins: 200,
      evaluator: (s, c, g, f) => f >= 500,
    ),
  ];
}
