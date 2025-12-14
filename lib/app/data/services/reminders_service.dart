import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:sehati/app/common/utils/snackbar_utils.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/data/models/response/reminder_model.dart';
import 'package:sehati/app/data/services/local_storage_service.dart';

class RemindersService {
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

  // GET reminders
  Future<List<Reminder>?> getReminders({
    String? title = '',
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
      } else {
        print("Failed to load reminders: ${response.statusMessage}");
        return null;
      }
    } on DioException catch (e) {
      print("❌ get reminders error: ${e.response?.data ?? e.message}");
      return null;
    }
  }

  // POST create reminder
  Future<ReminderResponse?> createReminder(Reminder reminder) async {
    try {
      print("[SERVICE] :: ${reminder.toJson()}");
      final token = LocalStorageService.getAccessToken();
      if (token == null || token.isEmpty) {
        SnackbarUtils.show("Token not found. Please log in again.");
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

      if (response.statusCode == 201) {
        return ReminderResponse.fromJson(response.data);
      } else {
        print("Failed to create reminder: ${response.statusMessage}");
        return null;
      }
    } on DioException catch (e) {
      print("❌ create reminder error: ${e.response?.statusCode}");
      print("❌ create reminder error: ${e.response?.data ?? e.message}");
      return null;
    }
  }

  // GET reminder by id
  Future<Reminder?> getReminder(String id) async {
    try {
      final token = LocalStorageService.getAccessToken();
      if (token == null || token.isEmpty) {
        SnackbarUtils.show("Token not found. Please log in again.");
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
      } else {
        print("Failed to get reminder: ${response.statusMessage}");
        return null;
      }
    } on DioException catch (e) {
      print("❌ get reminder error: ${e.response?.data ?? e.message}");
      return null;
    }
  }

  // UPDATE reminder by id
  Future<ReminderResponse?> updateReminder(Reminder reminder) async {
    try {
      final token = LocalStorageService.getAccessToken();
      if (token == null || token.isEmpty) {
        SnackbarUtils.show("Token not found. Please log in again.");
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

      if (response.statusCode == 200) {
        final reminderResp = ReminderResponse.fromJson(response.data);
        return reminderResp;
      } else {
        print("Failed to update reminder: ${response.statusMessage}");
        return null;
      }
    } on DioException catch (e) {
      print("❌ update reminder error: ${e.response?.data ?? e.message}");
      return null;
    }
  }

  // DELETE reminder by id
  Future<bool> deleteReminder(String id) async {
    try {
      final token = LocalStorageService.getAccessToken();
      if (token == null || token.isEmpty) {
        SnackbarUtils.show("Token not found. Please log in again.");
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

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Failed to delete reminder: ${response.statusMessage}");
        return false;
      }
    } on DioException catch (e) {
      print("❌ delete reminder error: ${e.response?.data ?? e.message}");
      return false;
    }
  }
}
