// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:sehati/app/data/config/dio_factory.dart';
import 'package:sehati/app/common/utils/snackbar_utils.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/data/models/response/schedule_res_model.dart';
import 'package:sehati/app/data/services/local_storage_service.dart';

class ScheduleService {
  final Dio _dio = DioFactory.create(
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  );
  Future<List<ScheduleData>?> getSchedule() async {
    try {
      final token = LocalStorageService.getAccessToken();
      if (token == null || token.isEmpty) {
        SnackbarUtils.show("Token not found. Please log in again.");
        return null;
      }

      final response = await _dio.get(
        ApiEndpoints.APPOINTMENT,
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );
      if (response.statusCode == 200) {
        final result = ScheduleResponse.fromJson(response.data);
        return result.data;
      } else {
        SnackbarUtils.show(response.data['message'] ?? "Failed to load schedules.");
        return null;
      }
    } on DioException catch (e) {
      print("❌ schedule request error: ${e.response?.data ?? e.message}");
      final msg = e.response?.data['message'] ?? e.message ?? "Failed to load schedules";
      SnackbarUtils.show(msg);
      return null;
    }
  }
}
