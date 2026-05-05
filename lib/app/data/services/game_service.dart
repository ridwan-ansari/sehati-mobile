import 'package:dio/dio.dart';
import 'package:sehati/app/common/utils/loading_utils.dart';
import 'package:sehati/app/common/localization/app_strings.dart';
import 'package:sehati/app/data/config/dio_factory.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/utils/snackbar_utils.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/data/models/response/game_model.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/game/views/game_play_page.dart';
import 'local_storage_service.dart';
import 'package:sehati/app/common/utils/app_logger.dart';

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
        SnackbarUtils.show(AppStrings.get(AppStrings.commonKeyTokenNotFound));
        return null;
      }

      final response = await _dio.get(
        ApiEndpoints.GAME,
        queryParameters: {"name": name, "limit": limit, "offset": offset},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      AppLogger.log("Response Data: ${response.data}");
      AppLogger.log("Response Data: ${response.statusCode}");
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((e) => GameModel.fromJson(e)).toList();
      } else {
        LoadingUtils.hide();
        SnackbarUtils.show(response.data['message'] ?? "Failed to load games");
        return null;
      }
    } on DioException catch (e) {
      LoadingUtils.hide();
      AppLogger.log("❌ get games error: ${e.response?.data ?? e.message}");
      AppLogger.log("❌ get games error: ${e.response?.statusCode}");
      final msg = e.response?.data?['message'] ?? e.message ?? "Network error";
      SnackbarUtils.show(isError: true, msg);
      return null;
    }
  }

  Future<void> gameClaim({required String gameId}) async {
    try {
      final token = LocalStorageService.getAccessToken();
      if (token == null || token.isEmpty) {
        SnackbarUtils.show(AppStrings.get(AppStrings.commonKeyTokenNotFound));
        return;
      }

      final response = await _dio.post(
        "${ApiEndpoints.GAME}$gameId/claim",
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        LoadingUtils.hide();
        SnackbarUtils.show(
            isError: false, response.data["message"] ?? AppStrings.get(AppStrings.commonKeySuccess));
      } else {
        LoadingUtils.hide();
        SnackbarUtils.show(response.data['message'] ?? AppStrings.get(AppStrings.commonKeyError));
      }
    } on DioException catch (e) {
      LoadingUtils.hide();
      final msg = e.response?.data?['message'] ?? e.message ?? AppStrings.get(AppStrings.commonKeyError);
      SnackbarUtils.show(isError: true, msg);
    }
  }

  Future<void> playGame({required String gameId}) async {
    try {
      final token = LocalStorageService.getAccessToken();
      if (token == null || token.isEmpty) {
        SnackbarUtils.show(AppStrings.get(AppStrings.commonKeyTokenNotFound));
        return;
      }

      final playUrl = "${ApiEndpoints.GAME}$gameId/play";
      Get.to(
        () => GamePlayPage(linkUrl: playUrl, title: AppStrings.get(AppStrings.menuKeyGame), token: token),
      );
    } catch (e) {
      LoadingUtils.hide();
      SnackbarUtils.show(isError: true, AppStrings.get(AppStrings.snackKeyErrorLoading));
    }
  }
}
