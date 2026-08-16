import '../../../../core/error/failures.dart';
import '../entities/score_entry.dart';

abstract class GameRepository {
  Future<Result<List<ScoreEntry>>> getLeaderboard();
  Future<Result<void>> saveScore(ScoreEntry entry);
  Future<Result<int>> getHighScore();
  Future<Result<void>> saveHighScore(int score);
  Future<Result<int>> getTotalCoins();
  Future<Result<void>> saveTotalCoins(int coins);
}
