import 'package:get/get.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/game/presentation/pages/game_page.dart';
import '../../features/shop/presentation/pages/shop_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/achievements/presentation/pages/achievements_page.dart';
import '../../features/leaderboard/presentation/pages/leaderboard_page.dart';
import '../../features/daily_reward/presentation/pages/daily_reward_page.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 280),
    ),
    GetPage(
      name: AppRoutes.game,
      page: () => const GamePage(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.shop,
      page: () => const ShopPage(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 320),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.achievements,
      page: () => const AchievementsPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.leaderboard,
      page: () => const LeaderboardPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.dailyReward,
      page: () => const DailyRewardPage(),
      transition: Transition.zoom,
      transitionDuration: const Duration(milliseconds: 340),
    ),
  ];
}
