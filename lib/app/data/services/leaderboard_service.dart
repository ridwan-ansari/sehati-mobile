// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sehati/app/data/config/dio_factory.dart';
import 'package:sehati/app/common/utils/snackbar_utils.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/data/models/leaderboard_model.dart';
import 'package:sehati/app/data/services/local_storage_service.dart';

class LeaderboardService {
  final Dio _dio = DioFactory.create();

  /// GET LEADERBOARD
  Future<List<LeaderboardModel>?> getLeaderboard() async {
    try {
      final token = LocalStorageService.getAccessToken();
      if (token == null || token.isEmpty) {
        SnackbarUtils.show("Token not found. Please log in again.");
        return null;
      }

      final response = await _dio.get(
        ApiEndpoints.LEADERBOARD,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((e) => LeaderboardModel.fromJson(e)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'An error occurred');
      }
    } on DioException catch (e) {
      final msg = e.response?.data['message'] ?? 'An error occurred';
      SnackbarUtils.show(isError: true, msg);
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getDashboardNotif() async {
    try {
      final token = LocalStorageService.getAccessToken();

      if (token == null || token.isEmpty) {
        SnackbarUtils.show("Token not found. Please log in again.");
        return null;
      }

      final response = await _dio.get(
        ApiEndpoints.DASHBOARD_NOTIFICATION,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        SnackbarUtils.show(response.data['message'] ?? "An error occurred");
        return null;
      }
    } on DioException catch (e) {
      print("❌ getDashboardNotif error: ${e.response?.data ?? e.message}");
      final msg = e.response?.data['message'] ?? e.message ?? "An error occurred";
      SnackbarUtils.show(msg);
      return null;
    } catch (e) {
      print("❌ getDashboardNotif error: $e");
      return null;
    }
  }
}
