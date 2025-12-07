import 'package:get/get.dart';
import 'package:sehati/app/modules/dashboard/views/feature/forum/controller/camera_controller.dart';
import 'package:sehati/app/modules/dashboard/views/feature/forum/controller/forum_controller.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/game/controllers/game_controller.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/leaderboard/controller/leaderboard_controller.dart';
import 'package:sehati/app/modules/dashboard/views/feature/schedule/controller/schedule_controller.dart';
import 'package:sehati/app/modules/profile/controllers/profile_controller.dart';
import '../controllers/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardController());

    Get.lazyPut<ForumController>(() => ForumController());
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<CameraControllerX>(() => CameraControllerX());
    Get.lazyPut<ScheduleController>(() => ScheduleController());
    Get.lazyPut(() => LeaderboardController(), fenix: true);
    Get.lazyPut<GameController>(() => GameController());
  }
}
