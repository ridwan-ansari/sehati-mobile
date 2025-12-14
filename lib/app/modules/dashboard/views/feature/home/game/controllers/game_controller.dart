// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:sehati/app/data/models/response/game_model.dart';
import 'package:sehati/app/data/services/game_service.dart';

class GameController extends GetxController {
  final GameService _service = GameService();

  RxList<GameModel> games = <GameModel>[].obs;

  var isLoading = false.obs;

  @override
  void onInit() {
    print("🚀 GameController onInit DIPANGGIL");
    super.onInit();
    fetchGames();
  }

  Future<void> fetchGames({
    String name = "",
    int limit = 20,
    int offset = 0,
  }) async {
    print("get game ..");
    try {
      isLoading.value = true;
      final result = await _service.getGames(
        name: name,
        limit: limit,
        offset: offset,
      );
      if (result != null) {
        games.assignAll(result);
      }
    } finally {
      isLoading.value = false;
    }
  }

  void onGameTap(String gameId) {
    // Implementasi logika saat game ditekan
    print("Game tapped: $gameId");
    _service.playGame(gameId: gameId);
  }

  void claimGame(String gameId) async {
    await _service.gameClaim(gameId: gameId);
    await fetchGames();
  }
}
