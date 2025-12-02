// ignore_for_file: avoid_print

//TODO PERBAIKI CPYAN

import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sehati/app/common/utils/snackbar_utils.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/data/models/request/sleep_req_model.dart';
import 'package:sehati/app/data/models/response/nutrition_res_model.dart';
import 'package:sehati/app/data/models/response/sleep_record_response.dart';
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

      if (request.targetSleep <= 0) {
        SnackbarUtils.show("Target sleep hours must be greater than 0");
        EasyLoading.dismiss();
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

      print('sleep status : ${response.statusCode}');
      print('sleep data : ${response.data}');
      EasyLoading.dismiss();

      if (response.statusCode == 201) {
        SnackbarUtils.show(
          isError: false,
          "Your sleep record has been saved successfully.",
        );
        return true;
      } else {
        SnackbarUtils.show(
          "Failed to save your sleep record. Please try again.",
        );
        return false;
      }
    } on DioException catch (e) {
      EasyLoading.dismiss();
      final errorMsg = e.response!.data["detail"]?[0]["msg"]??"Error";
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
      print("get sleep ${response.statusCode}");
      if (response.statusCode == 200) {
        print("response : ${response.data}");
        return SleepRecordResponse.fromJson(response.data).data;
      }
      return null;
    } on DioException catch (e) {
      print("❌ Pagination Error: ${e.response?.data}");
      return null;
    }
  }
}
