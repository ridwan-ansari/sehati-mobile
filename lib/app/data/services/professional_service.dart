// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:sehati/app/data/config/dio_factory.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:sehati/app/common/utils/snackbar_utils.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/data/models/response/professional_res_model.dart';
import 'package:sehati/app/data/services/local_storage_service.dart';

class ProfessionalService {
  final Dio _dio = DioFactory.create(
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  );

  /// ==================================================
  /// GET LIST OF PROFESSIONALS
  /// ==================================================
  Future<List<ProfessionalData>?> getProfessionals() async {
    try {
      final token = LocalStorageService.getAccessToken();
      if (token == null || token.isEmpty) {
        SnackbarUtils.show("Token not found. Please log in again.");
        return null;
      }

      EasyLoading.show(status: "Loading professionals...");

      final response = await _dio.get(
        ApiEndpoints.PROFESSIONAL_LIST,
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );
      EasyLoading.dismiss();

      if (response.statusCode == 200) {
        final result = ProfessionalResponse.fromJson(response.data);
        return result.data;
      } else {
        SnackbarUtils.show("Failed to load professionals.");
        return null;
      }
    } on DioException catch (e) {
      EasyLoading.dismiss();
      print("❌ Professional request error: ${e.response?.data ?? e.message}");
      SnackbarUtils.show("${e.message}");
      return null;
    }
  }

  /// ==================================================
  /// CREATE APPOINTMENT
  /// ==================================================
  Future<bool> createAppointment({
    required String professionalId,
    required String appointmentDate,
    required String appointmentTime,
    String? notes,
  }) async {
    try {
      final token = LocalStorageService.getAccessToken();
      if (token == null || token.isEmpty) {
        SnackbarUtils.show("Token not found. Please log in again.");
        return false;
      }

      EasyLoading.show(status: "Creating appointment...");

      // Convert date: dd/MM/yy → yyyy-MM-dda
      final dateParts = appointmentDate.split("/");
      final formattedDate = "20${dateParts[2]}-${dateParts[1]}-${dateParts[0]}";

      // Convert time: 10:00 AM → HH:mm:ss
      final formattedTime = _convertTime(appointmentTime);

      final body = {
        "professional_id": professionalId,
        "appointment_date": formattedDate,
        "appointment_time": formattedTime,
        "notes": notes ?? "",
      };

      print("BODY : ${body}");
      final response = await _dio.post(
        ApiEndpoints.APPOINTMENT,
        data: body,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      EasyLoading.dismiss();

      if (response.statusCode == 200 || response.statusCode == 201) {
        SnackbarUtils.show(isError: false, "Appointment created successfully!");
        return true;
      } else {
        SnackbarUtils.show("Failed to create appointment.");
        return false;
      }
    } on DioException catch (e) {
      EasyLoading.dismiss();
      print("❌ Appointment request error: ${e.response?.data ?? e.message}");
      final data = e.response?.data;
      final msg = (data is Map) ? (data['message'] ?? e.message) : e.message;
      SnackbarUtils.show("$msg");
      return false;
    }
  }

  /// Convert "10:00 AM" → "10:00:00"
  String _convertTime(String time) {
    try {
      time = time.replaceAll('.', ':').trim();

      DateTime parsed;
      if (time.toLowerCase().contains("am") ||
          time.toLowerCase().contains("pm")) {
        parsed = DateFormat("h:mm a").parse(time);
      }
      else if (RegExp(r'^\d{1,2}:\d{2}$').hasMatch(time)) {
        parsed = DateFormat("HH:mm").parse(time);
      }
      else {
        parsed = DateFormat("HH:mm").parse(time);
      }

      final hour = parsed.hour.toString().padLeft(2, '0');
      final minute = parsed.minute.toString().padLeft(2, '0');

      return "$hour:$minute:00";
    } catch (e) {
      print("❌ TIME PARSE ERROR: $e");
      return "00:00:00";
    }
  }
}
