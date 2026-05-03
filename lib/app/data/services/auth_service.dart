// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:sehati/app/data/config/dio_factory.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:sehati/app/common/utils/snackbar_utils.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/data/services/local_storage_service.dart';
import 'package:get/get.dart' as go;

class AuthService {
  final Dio _dio = DioFactory.create();

  /// REGISTER USER
  Future<Response?> registerUser({
    required String fullname,
    required String email,
    required String phoneNumber,
    required String dateOfBirth,
    required String password,
    String picture = "",
    String nickname = "",
    String gender = "",
  }) async {
    try {
      final data = jsonEncode({
        "fullname": fullname,
        "email": email,
        "phone_number": phoneNumber,
        "date_of_birth": dateOfBirth,
        "password": password,
        "picture": picture,
        "nickname": nickname,
        "gender": gender,
      });
      print(data);

      final response = await _dio.post(ApiEndpoints.REGISTER, data: data);

      print("✅ REGISTER SUCCESS: ${response.data}");
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        print("❌ REGISTER FAILED: ${e.response?.data}");
      } else {
        print("⚠️ NETWORK ERROR: ${e.message}");
      }
      rethrow;
    }
  }

  /// VERIFY OTP
  Future<bool> verifyOtp({required String email, required String code}) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.VERIFY_ACCOUNT,
        queryParameters: {"email": email, "code": code},
        options: Options(headers: {"Accept": "application/json"}),
      );
      print('-> otp ${response.statusCode}');
      print('-> otp ${response.data}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ OTP Verified: ${response.data}");
        return true;
      }
      return false;
    } on DioException catch (e) {
      print("❌ OTP Verification Error: ${e.response?.data ?? e.message}");
      String message = "OTP verification failed";
      if (e.response?.data != null && e.response?.data['message'] != null) {
        message = e.response!.data['message'];
      } else if (e.message != null) {
        message = e.message!;
      }
      throw Exception(message);
    }
  }

  /// LOGIN
  Future<Map<String, dynamic>?> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.LOGIN,
        data: {'email': email, 'password': password},
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        print("✅ LOGIN SUCCESS: ${response.data}");
        await LocalStorageService.setAccessToken(
          response.data['data']['access_token'],
        );
        await LocalStorageService.setRefreshToken(
          response.data['data']['refresh_token'],
        );
        return response.data['data'];
      }
      return null;
    } on DioException catch (e) {
      EasyLoading.dismiss();

      String message = "Terjadi kesalahan";
      if (e.response != null &&
          e.response?.data != null &&
          e.response?.data['message'] != null) {
        message = e.response!.data['message'];
      } else if (e.message != null) {
        message = e.message!;
      }
      SnackbarUtils.show(message);
    }
    return null;
  }

  /// REFRESH TOKEN
  Future<String?> refreshToken({required String refreshToken}) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.REFRESH_TOKEN,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $refreshToken',
          },
        ),
      );

      print("✅ REFRESH TOKEN SUCCESS: ${response.statusCode}");
      if (response.statusCode == 200) {
        print("✅ REFRESH TOKEN SUCCESS: ${response.data}");
        await LocalStorageService.setAccessToken(
          response.data['data']['access_token'],
        );
        await LocalStorageService.setRefreshToken(
          response.data['data']['refresh_token'],
        );
        return response.data['data']['access_token'];
      }
      return null;
    } on DioException catch (e) {
      print("❌ REFRESH TOKEN ERROR: ${e.response?.data ?? e.message}");
      if (e.response?.statusCode == 401) {
        LocalStorageService.clearTokens();
        SnackbarUtils.show('anda telah logout');
        go.Get.toNamed('/login');
      }
      return null;
    }
  }

  /// RESET PASSWORD
  Future<bool> forgotPassword({required String email}) async {
    try {
      final response = await _dio.post(
        '${ApiEndpoints.RESET_PASSWORD}?email=$email',
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200 && response.data['status_code'] == 200) {
        print("✅ Reset password success: ${response.data}");
        return true;
      } else {
        print("⚠️ Reset password failed: ${response.data}");
        return false;
      }
    } on DioException catch (e) {
      print("❌ Reset password error: ${e.response?.data ?? e.message}");
      return false;
    }
  }

  Future<Response?> confirmForgotPassword({
    required String email,
    required String otp,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final data = {
        'email': email,
        'code': otp,
        'new_password': newPassword,
        'confirm_password': confirmPassword,
      };
      final response = await _dio.post(
        ApiEndpoints.RESET_PASSWORD_CONFIRM,
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Accept': 'application/json',
          },
        ),
        data: data,
      );

      print("✅ Reset password success: ${response.data}");
      return response;
    } on DioException catch (e) {
      print("❌ Reset password error: ${e.response?.data ?? e.message}");
      if (e.response != null) {
        print("❌ RESET PASSWORD CONFIRM FAILED: ${e.response?.data}");
      } else {
        print("⚠️ NETWORK ERROR: ${e.message}");
      }
      rethrow;
    }
  }
}
