// ignore_for_file: avoid_print

//TODO PERBAIKI CODE COPYAN

import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sehati/app/common/utils/snackbar_utils.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/data/models/request/sleep_req_model.dart';
import 'package:sehati/app/data/models/response/nutrition_res_model.dart';
import 'package:sehati/app/data/services/local_storage_service.dart';

class SleepService {
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


  Future<bool> addSleep(SleepReqModel request) async {
    try {
      final token = LocalStorageService.getAccessToken();
      if (token == null || token.isEmpty) {
        SnackbarUtils.show("Token not found. Please log in again.");
        return false;
      }

      EasyLoading.show();
      print("body data ; ${request.toJson()}");

      final response = await _dio.post(
        ApiEndpoints.USER_SLEEP,
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
        print("RESPONSE TIDAK PUNYA FIELD 'data' !!!");
      }

      if (response.statusCode == 201) {
        SnackbarUtils.show(isError: false ,"Your sleep record has been saved successfully.");
        return true;
      } else {
        SnackbarUtils.show("Failed to save your sleep record. Please try again.");
        return false;
      }
    } on DioException catch (e) {
      EasyLoading.dismiss();
      print("Error Post Sleep : ${e.message}");
      SnackbarUtils.show("${e.response?.data["message"] ?? 'Error'}");
      return false;
    }
  }

  Future<List<NutritionData>?> getUserSleepPaginated({
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
      print("❌ Pagination Error: ${e.response?.data}");
      return null;
    }
  }
}
