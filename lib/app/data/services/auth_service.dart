// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:sehati/app/data/config/api_config.dart';

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
}
