import '../../../../core/error/failures.dart';
import '../../domain/entities/score_entry.dart';
import '../../domain/repositories/game_repository.dart';
import '../datasources/local_datasource.dart';

class GameRepositoryImpl implements GameRepository {
  final GameLocalDataSource local;
  GameRepositoryImpl(this.local);

  @override
  Future<Result<List<ScoreEntry>>> getLeaderboard() async {
    try {
      final data = local.getLeaderboard();
      return Result.success(data);
    } catch (e) {
      return Result.failure(StorageFailure('Failed to load leaderboard: $e'));
    }
  }

  @override
  Future<Result<void>> saveScore(ScoreEntry entry) async {
    try {
      await local.saveScore(entry);
      return Result.success(null);
    } catch (e) {
      return Result.failure(StorageFailure('Failed to save score: $e'));
    }
  }

  @override
  Future<Result<int>> getHighScore() async {
    try {
      return Result.success(local.getHighScore());
    } catch (e) {
      return Result.failure(StorageFailure('Failed: $e'));
    }
  }

  @override
  Future<Result<void>> saveHighScore(int score) async {
    try {
      await local.saveHighScore(score);
      return Result.success(null);
    } catch (e) {
      return Result.failure(StorageFailure('Failed: $e'));
    }
  }

  @override
  Future<Result<int>> getTotalCoins() async {
    try {
      return Result.success(local.getTotalCoins());
    } catch (e) {
      return Result.failure(StorageFailure('Failed: $e'));
    }
  }

  @override
  Future<Result<void>> saveTotalCoins(int coins) async {
    try {
      await local.saveTotalCoins(coins);
      return Result.success(null);
    } catch (e) {
      return Result.failure(StorageFailure('Failed: $e'));
    }
  }
}
