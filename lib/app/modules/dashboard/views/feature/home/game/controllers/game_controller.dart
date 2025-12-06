import 'package:get/get.dart';
import 'package:sehati/app/data/models/response/game_model.dart';
import 'package:sehati/app/data/services/game_service.dart';

class GameController extends GetxController {
  final GameService _service = GameService();

  var games = <GameModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchGames();
  }

  void fetchGames({String name = "", int limit = 20, int offset = 0}) async {
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
}
