import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/storage_service.dart';
import '../../domain/entities/score_entry.dart';

abstract class GameLocalDataSource {
  List<ScoreEntry> getLeaderboard();
  Future<void> saveScore(ScoreEntry entry);
  int getHighScore();
  Future<void> saveHighScore(int score);
  int getTotalCoins();
  Future<void> saveTotalCoins(int coins);
}

class GameLocalDataSourceImpl implements GameLocalDataSource {
  final StorageService storage;
  GameLocalDataSourceImpl(this.storage);

  @override
  List<ScoreEntry> getLeaderboard() {
    final raw = storage.read<List>('leaderboard_v1');
    if (raw == null) return [];
    return raw
        .map((e) => ScoreEntry.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList()
      ..sort((a, b) => b.score.compareTo(a.score));
  }

  @override
  Future<void> saveScore(ScoreEntry entry) async {
    final list = getLeaderboard()..add(entry);
    list.sort((a, b) => b.score.compareTo(a.score));
    final trimmed = list.take(50).toList();
    await storage.write('leaderboard_v1', trimmed.map((e) => e.toJson()).toList());
  }

  @override
  int getHighScore() => storage.highScore;

  @override
  Future<void> saveHighScore(int score) async {
    storage.highScore = score;
  }

  @override
  int getTotalCoins() => storage.totalCoins;

  @override
  Future<void> saveTotalCoins(int coins) async {
    storage.totalCoins = coins;
  }
}
