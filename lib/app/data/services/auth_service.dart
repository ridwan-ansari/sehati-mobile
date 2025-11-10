// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/data/services/local_storage_service.dart';

class AuthService {
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
        '${ApiEndpoints.VERIFY_ACCOUNT}',
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
      return false;
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
        await LocalStorageService.setAccessToken(response.data['data']['access_token']);
        await LocalStorageService.setRefreshToken(response.data['data']['refresh_token']);
        return response.data['data'];
      }
      return null;
    } on DioException catch (e) {
      print("❌ LOGIN ERROR: ${e.response?.data ?? e.message}");
      return null;
    }
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

      if (response.statusCode == 200) {
        print("✅ REFRESH TOKEN SUCCESS: ${response.data}");
        await LocalStorageService.setAccessToken(response.data['data']['access_token']);
        await LocalStorageService.setRefreshToken(response.data['data']['refresh_token']);
        return response.data['data']['access_token'];
      }
      return null;
    } on DioException catch (e) {
      print("❌ REFRESH TOKEN ERROR: ${e.response?.data ?? e.message}");
      return null;
    }
  }
}
