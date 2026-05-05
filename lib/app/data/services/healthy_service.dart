import 'package:dio/dio.dart';
import 'package:sehati/app/common/utils/loading_utils.dart';
import 'package:sehati/app/common/localization/app_strings.dart';
import 'package:sehati/app/data/config/dio_factory.dart';
import 'package:sehati/app/common/utils/snackbar_utils.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/data/models/recipe_model.dart';
import 'package:sehati/app/data/services/local_storage_service.dart';
import 'package:sehati/app/common/utils/app_logger.dart';

class HealthyService {
  final Dio _dio = DioFactory.create();

  Future<List<RecipeModel>?> getRecipes({
    int limit = 10,
    int offset = 0,
    String? name,
  }) async {
    try {
      final token = LocalStorageService.getAccessToken();
      if (token == null || token.isEmpty) {
        SnackbarUtils.show("Token not found. Please log in again.");
        return null;
      }

      final response = await _dio.get(
        ApiEndpoints.RECIPE,
        queryParameters: {'name': name, 'limit': limit, 'offset': offset},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];

        if (data is List) {
          return data
              .map((e) => RecipeModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }

        throw Exception('Invalid recipe data format');
      } else {
        throw Exception(response.data['message'] ?? 'Gagal memuat resep');
      }
    } on DioException catch (e) {
      LoadingUtils.hide();
      final msg = e.response?.data?['message'] ?? e.message ?? AppStrings.get(AppStrings.snackKeyLoadFailed);
      SnackbarUtils.show(isError: true, msg);
      rethrow;
    }
  }

  Future<void> claimPoint({required String recipeId}) async {
    try {
      final token = LocalStorageService.getAccessToken();
      if (token == null || token.isEmpty) {
        SnackbarUtils.show(AppStrings.get(AppStrings.commonKeyTokenNotFound));
        return;
      }
      LoadingUtils.show(AppStrings.get(AppStrings.commonKeyClaimingPoint));
      final response = await _dio.post(
        "${ApiEndpoints.RECIPE}claim-point",
        data: {"recipe_id": recipeId},
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Accept': 'application/json',
            "Authorization": "Bearer $token",
          },
        ),
      );
      LoadingUtils.hide();
      AppLogger.log("CLAIM ${response.statusCode}");
      if (response.statusCode == 201 || response.statusCode == 200) {
        SnackbarUtils.show(isError: false, response.data['message'] ?? AppStrings.get(AppStrings.snackKeyPointClaimed));
      } else {
        SnackbarUtils.show(response.data['message'] ?? AppStrings.get(AppStrings.commonKeyError));
      }
    } on DioException catch (e) {
      LoadingUtils.hide();
      AppLogger.log("❌ [E]-claimPoint: ${e.response?.data ?? e.message}");
      final msg = e.response?.data?['message'] ?? e.message ?? AppStrings.get(AppStrings.commonKeyError);
      SnackbarUtils.show(isError: true, msg);
    }
  }
}
