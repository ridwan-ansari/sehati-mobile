import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:sehati/app/data/models/leaderboard_model.dart';
import 'package:sehati/app/data/services/leaderboard_service.dart';
import 'package:sehati/app/data/services/profile_service.dart';

class LeaderboardController extends GetxController {
  final LeaderboardService _service = LeaderboardService();
  final ProfileService _profileService = ProfileService();
  final AudioPlayer _player = AudioPlayer();

  final RxBool isLoading = false.obs;
  final RxBool showLottie = true.obs;
  final RxBool _pageOpened = false.obs;
  final RxString username = ''.obs;
  final RxString dashboardNotif = ''.obs;
  final RxString errorMessage = ''.obs;
  final RxList<LeaderboardModel> leaderboardList = <LeaderboardModel>[].obs;

  Future<void> fetchLeaderboard() async {
    errorMessage.value = '';
    await getDashboardNotif();
    try {
      isLoading.value = true;
      final result = await _service.getLeaderboard();
      if (result != null) {
        leaderboardList.assignAll(result);
      }
    } catch (_) {
      errorMessage.value = 'Failed to load leaderboard. Check your connection.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getDashboardNotif() async {
    try {
      final result = await _service.getDashboardNotif();
      if (result?['data'] != null && result?['data'] != '') {
        dashboardNotif.value = result?['data'];
      }
    } catch (_) {}
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
    final index = leaderboardList.indexWhere(
      (e) => e.nickname == username.value,
    );
    return index == -1 ? -1 : index + 1;
  }

  int get mySaldo {
    return leaderboardList
        .firstWhere(
          (e) => e.nickname == username.value,
          orElse: () => LeaderboardModel(
            nickname: '',
            achievementPoints: 0,
            creditPoints: 0,
          ),
        )
        .creditPoints;
  }

  int get myAchievement {
    return leaderboardList
        .firstWhere(
          (e) => e.nickname == username.value,
          orElse: () => LeaderboardModel(
            nickname: '',
            achievementPoints: 0,
            creditPoints: 0,
          ),
        )
        .achievementPoints;
  }

  void startOpenPage() {
    if (_pageOpened.value) return;
    _pageOpened.value = true;
    showLottie.value = true;
    Future.delayed(const Duration(seconds: 3), () {
      showLottie.value = false;
    });
    _player.play(AssetSource('sound/coin.mp3'));
  }

  @override
  void onInit() {
    super.onInit();
    fetchLeaderboard();
    fetchUsername();
  }

  @override
  void onClose() {
    _player.dispose();
    super.onClose();
  }
}
