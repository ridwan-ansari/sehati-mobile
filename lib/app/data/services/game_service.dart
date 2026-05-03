import 'package:dio/dio.dart';
import 'package:sehati/app/data/config/dio_factory.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/utils/snackbar_utils.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/data/models/response/game_model.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/game/views/game_play_page.dart';
import 'local_storage_service.dart';

class GameService {
  final Dio _dio = DioFactory.create();

  Future<List<GameModel>?> getGames({
    String name = "",
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final token = LocalStorageService.getAccessToken();
      if (token == null || token.isEmpty) {
        SnackbarUtils.show("Token not found. Please log in again.");
        return null;
      }

      final response = await _dio.get(
        ApiEndpoints.GAME,
        queryParameters: {"name": name, "limit": limit, "offset": offset},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      print("Response Data: ${response.data}");
      print("Response Data: ${response.statusCode}");
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((e) => GameModel.fromJson(e)).toList();
      } else {
        SnackbarUtils.show(response.data['message'] ?? "Failed to load games");
        return null;
      }
    } on DioException catch (e) {
      print("❌ get games error: ${e.response?.data ?? e.message}");
      print("❌ get games error: ${e.response?.statusCode}");
      final msg = e.response?.data['message'] ?? "Network error";
      SnackbarUtils.show(isError: true, msg);
      return null;
    }
  }

  Future<void> gameClaim({required String gameId}) async {
    try {
      final token = LocalStorageService.getAccessToken();
      if (token == null || token.isEmpty) {
        SnackbarUtils.show("Token not found. Please log in again.");
        return;
      }

      final response = await _dio.post(
        "${ApiEndpoints.GAME}$gameId/claim",
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        SnackbarUtils.show(isError: false,response.data["message"]);
      } else {
        SnackbarUtils.show(response.data['message'] ?? "Failed to claim game");
      }
    } on DioException catch (e) {
      final msg = e.response?.data['message'] ?? "Network error";
      SnackbarUtils.show(isError: true, msg);
    }
  }


  Future<void> playGame({required String gameId}) async {
    try {
      final token = LocalStorageService.getAccessToken();
      if (token == null || token.isEmpty) {
        SnackbarUtils.show("Token not found. Please log in again.");
        return;
      }

      final playUrl = "${ApiEndpoints.GAME}$gameId/play";
      Get.to(
        () => GamePlayPage(linkUrl: playUrl, title: "Play Game", token: token),
      );
    } catch (e) {
      SnackbarUtils.show(isError: true, "Error loading game");
    }
  }
}
