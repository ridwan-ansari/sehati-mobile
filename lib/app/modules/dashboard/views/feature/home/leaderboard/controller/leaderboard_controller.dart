import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:sehati/app/data/models/leaderboard_model.dart';
import 'package:sehati/app/data/services/leaderboard_service.dart';
import 'package:sehati/app/data/services/profile_service.dart';

class LeaderboardController extends GetxController {
  final LeaderboardService _service = LeaderboardService();
  final ProfileService _profileService = ProfileService();
  late AudioPlayer player = AudioPlayer();

  RxBool isLoading = false.obs;
  RxBool showLottie = true.obs;
  RxBool init = false.obs;
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
    final index = leaderboardList.indexWhere(
      (e) => e.nickname == username.value,
    );
    return index == -1 ? -1 : index + 1;
  }

  int get mySaldo {
    final user = leaderboardList.firstWhere(
      (e) => e.nickname == username.value,
      orElse: () =>
          LeaderboardModel(nickname: "", achievementPoints: 0, creditPoints: 0),
    );
    return user.creditPoints;
  }

  int get myAchievement {
    final user = leaderboardList.firstWhere(
      (e) => e.nickname == username.value,
      orElse: () =>
          LeaderboardModel(nickname: "", achievementPoints: 0, creditPoints: 0),
    );
    return user.achievementPoints;
  }

  void hideLottieAfterDelay() {
    Future.delayed(Duration(seconds: 3), () {
      showLottie.value = false;
    });
  }

  void playOpenSound() {
    print("play soud ");
    player.play(AssetSource('sound/coin.mp3'));
  }

  void startAnimation() {
    hideLottieAfterDelay();
    playOpenSound();
  }

  @override
  void onInit() {
    super.onInit();
    fetchLeaderboard();
    fetchUsername();
  }

  @override
  void onClose() {
    player.dispose();
    super.onClose();
  }

  void startOpenPage() {
    print("önReady------------------>");
    super.onReady();
    showLottie.value = true;
    Future.delayed(const Duration(seconds: 3), () {
      showLottie.value = false;
    });
    player = AudioPlayer();
    playOpenSound();
  }

  // @override
  // void onReady() {
  //   print("önReady------------------>");
  //   super.onReady();
  //   showLottie.value = true;
  //   Future.delayed(const Duration(seconds: 3), () {
  //     showLottie.value = false;
  //   });
  //   player = AudioPlayer();
  //   playOpenSound();
  // }
}
