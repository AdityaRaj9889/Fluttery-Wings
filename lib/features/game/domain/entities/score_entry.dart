import 'package:equatable/equatable.dart';

class ScoreEntry extends Equatable {
  final int score;
  final int coinsCollected;
  final DateTime date;
  final String playerName;

  const ScoreEntry({
    required this.score,
    required this.coinsCollected,
    required this.date,
    this.playerName = 'Player',
  });

  @override
  List<Object?> get props => [score, coinsCollected, date, playerName];

  Map<String, dynamic> toJson() => {
        'score': score,
        'coinsCollected': coinsCollected,
        'date': date.toIso8601String(),
        'playerName': playerName,
      };

  factory ScoreEntry.fromJson(Map<String, dynamic> json) => ScoreEntry(
        score: json['score'] as int,
        coinsCollected: json['coinsCollected'] as int? ?? 0,
        date: DateTime.parse(json['date'] as String),
        playerName: json['playerName'] as String? ?? 'Player',
      );
}
