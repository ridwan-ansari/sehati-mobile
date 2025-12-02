// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sehati/app/common/utils/snackbar_utils.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/data/models/response/profile_response_model.dart';
import 'package:sehati/app/data/services/local_storage_service.dart';

class ProfileService {
  final Dio _dio = Dio(
    BaseOptions(
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

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
        print("⚠️ Failed to fetch profile: ${response.statusMessage}");
        SnackbarUtils.show("Failed to load profile.");
        return null;
      }
    } on DioException catch (e) {
      EasyLoading.dismiss();
      print("❌ Profile request error: ${e.response?.data ?? e.message}");
      SnackbarUtils.show("Network error occurred.");
      return null;
    }
  }

  // ==============================
  // 🧍 GET USER BY ID
  // ==============================
  Future<Map<String, dynamic>?> getUserById(int userId) async {
    try {
      final token = LocalStorageService.getAccessToken();

      final response = await _dio.get(
        ApiEndpoints.userById(userId),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        print("✅ GET USER SUCCESS: ${response.data}");
        return response.data;
      } else {
        print("⚠️ GET USER FAILED: ${response.statusMessage}");
        SnackbarUtils.show("Gagal memuat data pengguna");
        return null;
      }
    } on DioException catch (e) {
      EasyLoading.dismiss();
      print("❌ GET USER ERROR: ${e.response?.data ?? e.message}");
      SnackbarUtils.show("Terjadi kesalahan saat memuat data pengguna");
      return null;
    }
  }

  // ==============================
  // 📸 UPLOAD PROFILE PICTURE
  // ==============================
  Future<Map<String, dynamic>?> uploadProfilePicture(String filePath) async {
    try {
      EasyLoading.show(status: "Mengunggah foto...");

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
      print('upload [icture : ${response.statusCode}]');
      if (response.statusCode == 201 ) {
        print("✅ UPLOAD FOTO BERHASIL: ${response.data}");
        SnackbarUtils.show(isError: false, "Foto profil berhasil diperbarui");
        return response.data;
      } else {
        print("⚠️ UPLOAD FOTO GAGAL: ${response.statusMessage}");
        SnackbarUtils.show("Gagal mengunggah foto");
        return null;
      }
    } on DioException catch (e) {
      EasyLoading.dismiss();
      print("❌ UPLOAD FOTO ERROR: ${e.response?.data ?? e.message}");
      SnackbarUtils.show("Terjadi kesalahan saat mengunggah foto");
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
        print("✅ USER LIST SUCCESS: ${response.data}");
        return response.data;
      } else {
        print("⚠️ USER LIST FAILED: ${response.statusMessage}");
        SnackbarUtils.show("Gagal memuat daftar pengguna");
        return null;
      }
    } on DioException catch (e) {
      EasyLoading.dismiss();
      print("❌ USER LIST ERROR: ${e.response?.data ?? e.message}");
      SnackbarUtils.show("Terjadi kesalahan saat memuat data pengguna");
      return null;
    }
  }
}
