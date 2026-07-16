import 'package:dio/dio.dart';
import 'package:sehati/app/data/config/dio_factory.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sehati/app/common/utils/snackbar_utils.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/data/models/response/profile_response_model.dart';
import 'package:sehati/app/data/services/local_storage_service.dart';
import 'package:sehati/app/common/utils/app_logger.dart';

class ProfileService {
  final Dio _dio = DioFactory.create();

  // ==============================
  // 👤 GET USER PROFILE
  // ==============================
  Future<ProfileData?> getProfile() async {
    try {
      final token = LocalStorageService.getAccessToken();
      if (token == null || token.isEmpty) {
        SnackbarUtils.show("Token not found. Please log in again.");
        return null;
      }
      EasyLoading.show();

      final response = await _dio.get(
        ApiEndpoints.USER_PROFILE,
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      EasyLoading.dismiss();

      if (response.statusCode == 200) {
        final data = ProfileResponse.fromJson(response.data);
        return data.data;
      } else {
        AppLogger.log("⚠️ Failed to fetch profile: ${response.statusMessage}");
        SnackbarUtils.show(
          response.data['message'] ?? "Failed to load profile.",
        );
        return null;
      }
    } on DioException catch (e) {
      EasyLoading.dismiss();
      AppLogger.log(
        "❌ Profile request error: ${e.response?.data ?? e.message}",
      );
      final msg =
          e.response?.data['message'] ?? e.message ?? "Network error occurred.";
      SnackbarUtils.show(msg);
      return null;
    }
  }

  // ==============================
  // 📸 UPLOAD PROFILE PICTURE
  // ==============================
  Future<Map<String, dynamic>?> uploadProfilePicture(String filePath) async {
    try {
      EasyLoading.show();

      final token = LocalStorageService.getAccessToken();

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filePath,
          filename: filePath.split('/').last,
        ),
      });

      final response = await _dio.post(
        ApiEndpoints.USER_PICTURE,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      EasyLoading.dismiss();
      AppLogger.log('upload [icture : ${response.statusCode}]');
      if (response.statusCode == 201) {
        AppLogger.log("✅ UPLOAD FOTO BERHASIL: ${response.data}");
        SnackbarUtils.show(
          isError: false,
          response.data['message'] ?? "Foto profil berhasil diperbarui",
        );
        return response.data;
      } else {
        AppLogger.log("⚠️ UPLOAD FOTO GAGAL: ${response.statusMessage}");
        SnackbarUtils.show(response.data['message'] ?? "Gagal mengunggah foto");
        return null;
      }
    } on DioException catch (e) {
      EasyLoading.dismiss();
      AppLogger.log("❌ UPLOAD FOTO ERROR: ${e.response?.data ?? e.message}");
      final msg =
          e.response?.data['message'] ??
          e.message ??
          "Terjadi kesalahan saat mengunggah foto";
      SnackbarUtils.show(msg);
      return null;
    }
  }

  // ==============================
  // 📋 GET USER LIST
  // ==============================
  Future<Map<String, dynamic>?> getUserList({
    String? keyword,
    int? limit,
    int? offset,
  }) async {
    try {
      final token = LocalStorageService.getAccessToken();

      final response = await _dio.get(
        "$BASE_URL/api/users/",
        queryParameters: {
          if (keyword != null) 'keyword': keyword,
          if (limit != null) 'limit': limit,
          if (offset != null) 'offset': offset,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        AppLogger.log("✅ USER LIST SUCCESS: ${response.data}");
        return response.data;
      } else {
        AppLogger.log("⚠️ USER LIST FAILED: ${response.statusMessage}");
        SnackbarUtils.show(
          response.data['message'] ?? "Gagal memuat daftar pengguna",
        );
        return null;
      }
    } on DioException catch (e) {
      EasyLoading.dismiss();
      AppLogger.log("❌ USER LIST ERROR: ${e.response?.data ?? e.message}");
      final msg =
          e.response?.data['message'] ??
          e.message ??
          "Terjadi kesalahan saat memuat data pengguna";
      SnackbarUtils.show(msg);
      return null;
    }
  }
}
