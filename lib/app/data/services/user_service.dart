import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sehati/app/common/utils/snackbar_utils.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/data/models/request/nutrition_req_model.dart';
import 'package:sehati/app/data/models/response/nutrition_res_model.dart';
import 'package:sehati/app/data/services/local_storage_service.dart';

class UserService {
  final Dio _dio = Dio(
    BaseOptions(
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  /// ===============================================
  /// GET USER NUTRITION LIST
  /// ===============================================
  Future<List<NutritionData>?> getUserNutrition() async {
    try {
      final token = await LocalStorageService.getAccessToken();
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
      } else {
        SnackbarUtils.show("Failed to load nutrition data.");
        return null;
      }
    } on DioException catch (e) {
      EasyLoading.dismiss();
      print("❌ Nutrition request error: ${e.response?.data ?? e.message}");
      SnackbarUtils.show("${e.message}");
      return null;
    }
  }

  /// ======================================================
  /// POST create nutrition data
  /// ======================================================
  Future<NutritionData?> createNutrition(NutritionCreateRequest request) async {
 try {
  final token = await LocalStorageService.getAccessToken();
  if (token == null || token.isEmpty) {
    SnackbarUtils.show("Token not found. Please log in again.");
    return null;
  }

  EasyLoading.show(status: "Saving nutrition data...");

  print("============== REQUEST BODY ==============");
  print(request.toJson());
  print("==========================================");

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
    final rawData = response.data["data"];

  } else {
    print("RESPONSE TIDAK PUNYA FIELD 'data' !!!");
  }

  // Parsing sesuai format yang benar
  if (response.statusCode == 201) {
    final raw = response.data["data"];

    if (raw is Map<String, dynamic>) {
      final result = NutritionData.fromJson(raw);
      SnackbarUtils.show(isError: false, "Nutrition saved!");
      return result;
    } else {
      print("❌ DATA BUKAN MAP (tidak bisa diparse NutritionData)");
      SnackbarUtils.show(isError: false, "Nutrition saved!");
      return null;
    }
  } else {
    SnackbarUtils.show("Failed to save nutrition data.");
    return null;
  }
} on DioException catch (e) {
  EasyLoading.dismiss();
  SnackbarUtils.show("${e.response?.data["message"] ?? 'Error'}");
  return null;
}
  }

  Future<List<NutritionData>?> getUserNutritionPaginated({
    required int limit,
    required int offset,
  }) async {
    try {
      final token = await LocalStorageService.getAccessToken();
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
      print("❌ Pagination Error: ${e.response?.data}");
      return null;
    }
  }
}
