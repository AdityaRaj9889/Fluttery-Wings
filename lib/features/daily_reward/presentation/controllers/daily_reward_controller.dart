import 'package:get/get.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/audio_service.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/helpers.dart';

enum DailyRewardStatus { available, claimedToday, missed }

class DailyRewardController extends GetxController {
  final StorageService storageService;
  final AudioService audioService;
  final HapticService hapticService;

  DailyRewardController({
    required this.storageService,
    required this.audioService,
    required this.hapticService,
  });

  final RxInt streak = 0.obs;
  final RxBool canClaim = false.obs;
  final RxInt todayReward = 0.obs;
  final Rx<DailyRewardStatus> status = DailyRewardStatus.available.obs;
  final Rx<DateTime?> lastClaim = Rx<DateTime?>(null);

  @override
  void onInit() {
    super.onInit();
    load();
  }

  void load() {
    streak.value = storageService.dailyStreak;
    lastClaim.value = storageService.lastDailyRewardClaim;
    _evaluate();
  }

  void _evaluate() {
    final last = lastClaim.value;
    final now = DateTime.now();

    if (last == null) {
      canClaim.value = true;
      status.value = DailyRewardStatus.available;
      todayReward.value = AppConstants.dailyRewards[streak.value % 7];
      return;
    }

    if (GameHelpers.isSameDay(last, now)) {
      canClaim.value = false;
      status.value = DailyRewardStatus.claimedToday;
      todayReward.value = AppConstants.dailyRewards[streak.value % 7];
    } else if (GameHelpers.isYesterday(last, now)) {
      canClaim.value = true;
      status.value = DailyRewardStatus.available;
      todayReward.value = AppConstants.dailyRewards[(streak.value) % 7];
    } else {
      // Streak broken
      canClaim.value = true;
      status.value = DailyRewardStatus.missed;
      todayReward.value = AppConstants.dailyRewards[0];
    }
  }

  Future<int> claim() async {
    if (!canClaim.value) return 0;
    final now = DateTime.now();
    final last = lastClaim.value;

    int newStreak;
    if (last == null || !GameHelpers.isYesterday(last, now)) {
      if (last != null && GameHelpers.isSameDay(last, now)) {
        return 0; // already claimed
      }
      // Check if missed >1 day -> reset
      if (last != null && !GameHelpers.isYesterday(last, now)) {
        newStreak = 0;
      } else {
        newStreak = streak.value;
      }
    } else {
      newStreak = streak.value;
    }

    final rewardIndex = newStreak % 7;
    final reward = AppConstants.dailyRewards[rewardIndex];

    // Give reward
    storageService.totalCoins = storageService.totalCoins + reward;
    storageService.lastDailyRewardClaim = now;
    storageService.dailyStreak = newStreak + 1;

    streak.value = newStreak + 1;
    lastClaim.value = now;
    canClaim.value = false;
    status.value = DailyRewardStatus.claimedToday;

    await audioService.playCoin();
    await hapticService.medium();

    return reward;
  }

  int rewardForDay(int dayIndex) => AppConstants.dailyRewards[dayIndex % 7];

  bool isDayClaimed(int dayIndex) => dayIndex < (streak.value % 7);

  bool isToday(int dayIndex) =>
      dayIndex == (streak.value % 7) && canClaim.value;
}
