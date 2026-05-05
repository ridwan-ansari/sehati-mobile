
import 'package:dio/dio.dart';
import 'package:sehati/app/data/config/dio_factory.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sehati/app/common/utils/snackbar_utils.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/data/models/request/nutrition_req_model.dart';
import 'package:sehati/app/data/models/response/nutrition_res_model.dart';
import 'package:sehati/app/data/models/response/profile_response_model.dart';
import 'package:sehati/app/data/services/local_storage_service.dart';
import 'package:sehati/app/common/utils/app_logger.dart';

class UserService {
  final Dio _dio = DioFactory.create(
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  );

  /// ===============================================
  /// GET USER NUTRITION LIST
  /// ===============================================
  Future<List<NutritionData>?> getUserNutrition() async {
    try {
      final token = LocalStorageService.getAccessToken();
      if (token == null || token.isEmpty) {
        SnackbarUtils.show("Token not found. Please log in again.");
        return null;
      }

      final response = await _dio.get(
        ApiEndpoints.USER_NUTRITION,
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      EasyLoading.dismiss();

      if (response.statusCode == 200) {
        final result = NutritionResponse.fromJson(response.data);
        return result.data;
      }
      SnackbarUtils.show(response.data['message'] ?? "An error occurred");
      return null;
    } on DioException catch (e) {
      EasyLoading.dismiss();
      AppLogger.log("❌ Nutrition request error: ${e.response?.data ?? e.message}");
      SnackbarUtils.show(
          e.response?.data?['message'] ?? e.message ?? "An error occurred");
      return null;
    }
  }

  /// ======================================================
  /// POST create nutrition data
  /// ======================================================
  Future<NutritionData?> createNutrition(NutritionCreateRequest request) async {
    try {
      final token = LocalStorageService.getAccessToken();
      if (token == null || token.isEmpty) {
        SnackbarUtils.show("Token not found. Please log in again.");
        return null;
      }

      EasyLoading.show(status: "Saving nutrition data...");

      final response = await _dio.post(
        ApiEndpoints.USER_NUTRITION,
        data: request.toJson(),
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      EasyLoading.dismiss();

      // Cek apakah ada field "data"
      if (response.data is Map && response.data.containsKey("data")) {
        response.data["data"];
      } else {
        AppLogger.log("RESPONSE TIDAK PUNYA FIELD 'data' !!!");
      }

      // Parsing sesuai format yang benar
      if (response.statusCode == 201) {
        final raw = response.data["data"];

        if (raw is Map<String, dynamic>) {
          final result = NutritionData.fromJson(raw);
          SnackbarUtils.show(
              isError: false, response.data['message'] ?? "Success");
          return result;
        } else {
          AppLogger.log("❌ DATA BUKAN MAP (tidak bisa diparse NutritionData)");
          SnackbarUtils.show(
              isError: false, response.data['message'] ?? "Success");
          return null;
        }
      }
      SnackbarUtils.show(response.data['message'] ?? "An error occurred");
      return null;
    } on DioException catch (e) {
      EasyLoading.dismiss();
      SnackbarUtils.show(
          e.response?.data?['message'] ?? e.message ?? "An error occurred");
      return null;
    }
  }

  Future<List<NutritionData>?> getUserNutritionPaginated({
    required int limit,
    required int offset,
  }) async {
    try {
      final token = LocalStorageService.getAccessToken();
      if (token == null || token.isEmpty) return null;

      final response = await _dio.get(
        "${ApiEndpoints.USER_NUTRITION}?limit=$limit&offset=$offset",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200) {
        return NutritionResponse.fromJson(response.data).data;
      }
      return null;
    } on DioException catch (e) {
      AppLogger.log("❌ Pagination Error: ${e.response?.data}");
      return null;
    }
  }

  Future<ProfileData?> getUserId({final String? userId}) async {
    try {
      final token = LocalStorageService.getAccessToken();
      if (token == null || token.isEmpty) {
        SnackbarUtils.show("Token not found. Please log in again.");
        throw Exception("Token not found");
      }

      final response = await _dio.get(
        "${ApiEndpoints.SEARCH_USERS}$userId",
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        final data = ProfileResponse.fromJson(response.data);
        return data.data;
      } else {
        AppLogger.log("⚠️ GET USER FAILED: ${response.statusMessage}");
        throw Exception("Failed to fetch user data");
      }
    } on DioException catch (e) {
      AppLogger.log("❌ GET USER ERROR: ${e.response?.data ?? e.message}");
      throw Exception("Network error occurred");
    }
  }
}
