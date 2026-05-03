import 'package:get/get.dart';
import 'package:sehati/app/data/models/response/game_model.dart';
import 'package:sehati/app/data/services/game_service.dart';

class GameController extends GetxController {
  final GameService _service = GameService();

  final RxList<GameModel> games = <GameModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchGames();
  }

  Future<void> fetchGames({
    String name = '',
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      errorMessage.value = '';
      isLoading.value = true;
      final result = await _service.getGames(
        name: name,
        limit: limit,
        offset: offset,
      );
      if (result != null) {
        games.assignAll(result);
      }
    } catch (_) {
      errorMessage.value = 'Failed to load games. Check your connection.';
    } finally {
      isLoading.value = false;
    }
  }

  void onGameTap(String gameId) {
    _service.playGame(gameId: gameId);
  }

  Future<void> claimGame(String gameId) async {
    await _service.gameClaim(gameId: gameId);
    await fetchGames();
  }
}
