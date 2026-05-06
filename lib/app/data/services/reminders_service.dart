import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sehati/app/data/config/dio_factory.dart';
import 'package:sehati/app/common/utils/snackbar_utils.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/data/models/response/reminder_model.dart';
import 'package:sehati/app/data/services/local_storage_service.dart';
import 'package:sehati/app/common/localization/app_strings.dart';
import 'package:sehati/app/common/utils/app_logger.dart';

class RemindersService {
  final Dio _dio = DioFactory.create(
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  );

  // GET reminders
  Future<List<Reminder>?> getReminders({
    String? title = '',
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
        '${ApiEndpoints.REMENDER}?title=$title&limit=$limit&offset=$offset',
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200) {
        final reminderList = ReminderResponse.fromJson(response.data);
        return reminderList.dataList;
      }
      SnackbarUtils.show(response.data['message'] ?? "An error occurred");
      return null;
    } on DioException catch (e) {
      AppLogger.log("❌ get reminders error: ${e.response?.data ?? e.message}");
      final msg =
          e.response?.data?['message'] ?? e.message ?? "An error occurred";
      SnackbarUtils.show(msg);
      return null;
    }
  }

  // POST create reminder
  Future<ReminderResponse?> createReminder(Reminder reminder) async {
    try {
      EasyLoading.show();
      final token = LocalStorageService.getAccessToken();
      if (token == null || token.isEmpty) {
        EasyLoading.dismiss();
        SnackbarUtils.show(AppStrings.get(AppStrings.commonKeyTokenNotFound));
        return null;
      }
      final response = await _dio.post(
        ApiEndpoints.REMENDER,
        data: json.encode(reminder.toJson()),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            "Authorization": "Bearer $token",
          },
        ),
      );
      EasyLoading.dismiss();

      if (response.statusCode == 201) {
        SnackbarUtils.show(
            isError: false, response.data['message'] ?? AppStrings.get(AppStrings.commonKeySuccess));
        return ReminderResponse.fromJson(response.data);
      }
      SnackbarUtils.show(response.data['message'] ?? AppStrings.get(AppStrings.commonKeyError));
      return null;
    } on DioException catch (e) {
      EasyLoading.dismiss();
      AppLogger.log("❌ create reminder error: ${e.response?.statusCode}");
      AppLogger.log("❌ create reminder error: ${e.response?.data ?? e.message}");
      final msg =
          e.response?.data?['message'] ?? e.message ?? AppStrings.get(AppStrings.commonKeyError);
      SnackbarUtils.show(msg);
      return null;
    }
  }

  // GET reminder by id
  Future<Reminder?> getReminder(String id) async {
    try {
      final token = LocalStorageService.getAccessToken();
      if (token == null || token.isEmpty) {
        SnackbarUtils.show(AppStrings.get(AppStrings.commonKeyTokenNotFound));
        return null;
      }
      final response = await _dio.get(
        '${ApiEndpoints.REMENDER}/$id',
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token}",
          },
        ),
      );

      if (response.statusCode == 200) {
        final reminderResp = ReminderResponse.fromJson(response.data);
        return reminderResp.dataItem;
      }
      SnackbarUtils.show(response.data['message'] ?? AppStrings.get(AppStrings.commonKeyError));
      return null;
    } on DioException catch (e) {
      AppLogger.log("❌ get reminder error: ${e.response?.data ?? e.message}");
      final msg =
          e.response?.data?['message'] ?? e.message ?? AppStrings.get(AppStrings.commonKeyError);
      SnackbarUtils.show(msg);
      return null;
    }
  }

  // UPDATE reminder by id
  Future<ReminderResponse?> updateReminder(Reminder reminder) async {
    try {
      EasyLoading.show();
      final token = LocalStorageService.getAccessToken();
      if (token == null || token.isEmpty) {
        EasyLoading.dismiss();
        SnackbarUtils.show(AppStrings.get(AppStrings.commonKeyTokenNotFound));
        return null;
      }
      final response = await _dio.put(
        '${ApiEndpoints.REMENDER}${reminder.id}',
        data: json.encode(reminder.toJson()),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            "Authorization": "Bearer $token",
          },
        ),
      );
      EasyLoading.dismiss();

      if (response.statusCode == 200) {
        SnackbarUtils.show(
            isError: false, response.data['message'] ?? AppStrings.get(AppStrings.commonKeySuccess));
        return ReminderResponse.fromJson(response.data);
      }
      SnackbarUtils.show(response.data['message'] ?? AppStrings.get(AppStrings.commonKeyError));
      return null;
    } on DioException catch (e) {
      EasyLoading.dismiss();
      AppLogger.log("❌ update reminder error: ${e.response?.data ?? e.message}");
      final msg =
          e.response?.data?['message'] ?? e.message ?? AppStrings.get(AppStrings.commonKeyError);
      SnackbarUtils.show(msg);
      return null;
    }
  }

  // DELETE reminder by id
  Future<bool> deleteReminder(String id) async {
    try {
      EasyLoading.show();
      final token = LocalStorageService.getAccessToken();
      if (token == null || token.isEmpty) {
        EasyLoading.dismiss();
        SnackbarUtils.show(AppStrings.get(AppStrings.commonKeyTokenNotFound));
        return false;
      }
      final response = await _dio.delete(
        '${ApiEndpoints.REMENDER}$id',
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );
      EasyLoading.dismiss();

      if (response.statusCode == 200) {
        SnackbarUtils.show(
            isError: false, response.data['message'] ?? AppStrings.get(AppStrings.commonKeySuccess));
        return true;
      }
      SnackbarUtils.show(response.data['message'] ?? AppStrings.get(AppStrings.commonKeyError));
      return false;
    } on DioException catch (e) {
      EasyLoading.dismiss();
      AppLogger.log("❌ delete reminder error: ${e.response?.data ?? e.message}");
      final msg =
          e.response?.data?['message'] ?? e.message ?? AppStrings.get(AppStrings.commonKeyError);
      SnackbarUtils.show(msg);
      return false;
    }
  }
}
