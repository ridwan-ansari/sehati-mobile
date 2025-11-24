import 'package:get/get.dart';
import 'package:sehati/app/data/models/leaderboard_model.dart';
import 'package:sehati/app/data/services/leaderboard_service.dart';
import 'package:sehati/app/data/services/profile_service.dart';

class LeaderboardController extends GetxController {
  final LeaderboardService _service = LeaderboardService();
  final ProfileService _profileService = ProfileService();

  RxBool isLoading = false.obs;
  RxString username = "".obs;
  RxList<LeaderboardModel> leaderboardList = <LeaderboardModel>[].obs;

  Future<void> fetchLeaderboard() async {
    try {
      isLoading.value = true;
      final result = await _service.getLeaderboard();
      if (result != null) {
        leaderboardList.assignAll(result);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUsername() async {
    try {
      final result = await _profileService.getProfile();
      if (result != null && result.nickname.isNotEmpty) {
        username.value = result.nickname;
      }
    } catch (_) {}
  }

  int get userRank {
    final index =
        leaderboardList.indexWhere((e) => e.nickname == username.value);
    return index == -1 ? -1 : index + 1;
  }

  int get myPoints {
    final user = leaderboardList.firstWhere(
      (e) => e.nickname == username.value,
      orElse: () => LeaderboardModel(
        nickname: "",
        achievementPoints: 0,
        creditPoints: 0,
      ),
    );
    return user.creditPoints;
  }

  int get myAchievement {
    final user = leaderboardList.firstWhere(
      (e) => e.nickname == username.value,
      orElse: () => LeaderboardModel(
        nickname: "",
        achievementPoints: 0,
        creditPoints: 0,
      ),
    );
    return user.achievementPoints;
  }

  @override
  void onInit() {
    fetchLeaderboard();
    fetchUsername();
    super.onInit();
  }
}
