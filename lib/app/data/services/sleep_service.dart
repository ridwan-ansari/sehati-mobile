
//TODO PERBAIKI CPYAN

import 'package:dio/dio.dart';
import 'package:sehati/app/data/config/dio_factory.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sehati/app/common/utils/snackbar_utils.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/data/models/request/sleep_req_model.dart';
import 'package:sehati/app/data/models/response/nutrition_res_model.dart';
import 'package:sehati/app/data/models/response/sleep_record_response.dart';
import 'package:sehati/app/data/services/local_storage_service.dart';
import 'package:sehati/app/common/utils/app_logger.dart';

class SleepService {
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
      } else {
        SnackbarUtils.show(response.data['message'] ?? "An error occurred");
        return null;
      }
    } on DioException catch (e) {
      EasyLoading.dismiss();
      AppLogger.log("❌ Nutrition request error: ${e.response?.data ?? e.message}");
      final msg = e.response?.data['message'] ?? e.message ?? "Failed to load nutrition data";
      SnackbarUtils.show(msg);
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
      AppLogger.log("body data ; ${request.toJson()}");

      if (request.targetSleep <= 0) {
        EasyLoading.dismiss();
        SnackbarUtils.show("Target sleep hours must be greater than 0");
        return false;
      }

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

      AppLogger.log('sleep status : ${response.statusCode}');
      AppLogger.log('sleep data : ${response.data}');
      EasyLoading.dismiss();

      if (response.statusCode == 201) {
        SnackbarUtils.show(
          isError: false,
          response.data['message'] ?? "Success",
        );
        return true;
      } else {
        SnackbarUtils.show(
          response.data['message'] ?? "An error occurred",
        );
        return false;
      }
    } on DioException catch (e) {
      EasyLoading.dismiss();
      final errorMsg = e.response?.data['message'] ?? e.response?.data["detail"]?[0]["msg"] ?? e.message ?? "Error";
      SnackbarUtils.show(errorMsg);
      return false;
    }
  }

  Future<List<SleepRecord>?> getUserSleepPaginated({
    required int limit,
    required int offset,
  }) async {
    try {
      final token = LocalStorageService.getAccessToken();
      if (token == null || token.isEmpty) return null;

      final response = await _dio.get(
        "${ApiEndpoints.USER_SLEEP}?limit=$limit&offset=$offset",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );
      AppLogger.log("get sleep ${response.statusCode}");
      if (response.statusCode == 200) {
        AppLogger.log("response : ${response.data}");
        return SleepRecordResponse.fromJson(response.data).data;
      }
      return null;
    } on DioException catch (e) {
      AppLogger.log("❌ Pagination Error: ${e.response?.data}");
      final msg = e.response?.data['message'] ?? e.message ?? "Failed to load sleep records";
      SnackbarUtils.show(msg);
      return null;
    }
  }
}

