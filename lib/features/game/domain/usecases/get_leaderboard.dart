import '../../../../core/error/failures.dart';
import '../entities/score_entry.dart';
import '../repositories/game_repository.dart';

class GetLeaderboard {
  final GameRepository repo;
  GetLeaderboard(this.repo);
  Future<Result<List<ScoreEntry>>> call() => repo.getLeaderboard();
}

class SaveScore {
  final GameRepository repo;
  SaveScore(this.repo);
  Future<Result<void>> call(ScoreEntry entry) => repo.saveScore(entry);
}
