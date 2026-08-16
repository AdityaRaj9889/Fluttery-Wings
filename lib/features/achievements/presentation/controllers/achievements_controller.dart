import 'package:get/get.dart';
import '../../../../core/services/storage_service.dart';
import '../../../game/domain/entities/achievement.dart';

class AchievementsController extends GetxController {
  final StorageService storageService;

  AchievementsController({required this.storageService});

  final RxList<AchievementProgress> progressList = <AchievementProgress>[].obs;
  final RxInt newlyUnlockedCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  void load() {
    final map = storageService.achievements;
    final List<AchievementProgress> list = [];
    for (final ach in AchievementCatalog.all) {
      if (map.containsKey(ach.id)) {
        list.add(AchievementProgress.fromJson(
            Map<String, dynamic>.from(map[ach.id] as Map)));
      } else {
        list.add(AchievementProgress(
            id: ach.id, current: 0, unlocked: false));
      }
    }
    progressList.value = list;
  }

  void evaluate({
    required int bestScore,
    required int totalCoins,
    required int gamesPlayed,
    required int totalFlaps,
  }) {
    bool changed = false;
    final updatedMap = Map<String, dynamic>.from(storageService.achievements);
    for (int i = 0; i < progressList.length; i++) {
      final def = AchievementCatalog.all.firstWhere((e) => e.id == progressList[i].id);
      final p = progressList[i];
      if (p.unlocked) continue;

      // For simplicity evaluator checks if achieved
      final achieved = def.evaluator(bestScore, totalCoins, gamesPlayed, totalFlaps);
      int current = p.current;
      // Update current based on type
      if (def.id.contains('coin')) current = totalCoins;
      else if (def.id.contains('games')) current = gamesPlayed;
      else if (def.id.contains('flaps')) current = totalFlaps;
      else current = bestScore.clamp(0, def.target);

      bool unlockedNow = achieved || current >= def.target;
      if (unlockedNow && !p.unlocked) {
        final newProg = p.copyWith(current: def.target, unlocked: true, unlockedAt: DateTime.now());
        progressList[i] = newProg;
        updatedMap[def.id] = newProg.toJson();
        // Reward coins
        storageService.totalCoins = storageService.totalCoins + def.rewardCoins;
        newlyUnlockedCount.value++;
        changed = true;
      } else if (current != p.current) {
        final newProg = p.copyWith(current: current);
        progressList[i] = newProg;
        updatedMap[def.id] = newProg.toJson();
        changed = true;
      }
    }
    if (changed) {
      storageService.achievements = updatedMap;
    }
  }

  List<Achievement> get unlockedAchievements {
    return AchievementCatalog.all.where((a) {
      final prog = progressList.firstWhere((p) => p.id == a.id);
      return prog.unlocked;
    }).toList();
  }

  double get completionPercent {
    if (progressList.isEmpty) return 0;
    final unlocked = progressList.where((e) => e.unlocked).length;
    return unlocked / progressList.length;
  }
}
