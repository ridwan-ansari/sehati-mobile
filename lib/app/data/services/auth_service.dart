
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:sehati/app/data/config/dio_factory.dart';
import 'package:sehati/app/common/utils/loading_utils.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:sehati/app/common/utils/snackbar_utils.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/data/services/local_storage_service.dart';
import 'package:get/get.dart' as go;
import 'package:sehati/app/common/utils/app_logger.dart';
import 'package:sehati/app/common/localization/app_strings.dart';

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
      AppLogger.log(data);

      final response = await _dio.post(ApiEndpoints.REGISTER, data: data);

      AppLogger.log("✅ REGISTER SUCCESS: ${response.data}");
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        AppLogger.log("❌ REGISTER FAILED: ${e.response?.data}");
      } else {
        AppLogger.log("⚠️ NETWORK ERROR: ${e.message}");
      }
      rethrow;
    }
  }

  /// VERIFY OTP
  Future<bool> verifyOtp({required String email, required String code}) async {
    try {
      LoadingUtils.show(AppStrings.get(AppStrings.authKeyVerifyingOtp));
      final response = await _dio.post(
        ApiEndpoints.VERIFY_ACCOUNT,
        queryParameters: {"email": email, "code": code},
        options: Options(headers: {"Accept": "application/json"}),
      );
      LoadingUtils.hide();
      AppLogger.log('-> otp ${response.statusCode}');
      AppLogger.log('-> otp ${response.data}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        AppLogger.log("✅ OTP Verified: ${response.data}");
        SnackbarUtils.show(
            isError: false, response.data['message'] ?? AppStrings.get(AppStrings.commonKeySuccess));
        return true;
      }
      SnackbarUtils.show(response.data['message'] ?? AppStrings.get(AppStrings.commonKeyError));
      return false;
    } on DioException catch (e) {
      LoadingUtils.hide();
      AppLogger.log("❌ OTP Verification Error: ${e.response?.data ?? e.message}");
      final msg =
          e.response?.data?['message'] ?? e.message ?? AppStrings.get(AppStrings.commonKeyError);
      SnackbarUtils.show(msg);
      return false;
    }
  }

  /// RESEND OTP
  Future<bool> resendOtp({
    required String fullname,
    required String email,
    required String phoneNumber,
    required String dateOfBirth,
    required String password,
    String? picture,
    required String nickname,
    required String gender,
  }) async {
    try {
      LoadingUtils.show(AppStrings.get(AppStrings.authKeyResendingOtp));
      final response = await _dio.post(
        ApiEndpoints.REGISTER,
        data: {
          "fullname": fullname,
          "email": email,
          "phone_number": phoneNumber,
          "date_of_birth": dateOfBirth,
          "password": password,
          "picture": picture,
          "nickname": nickname,
          "gender": gender,
        },
      );

      LoadingUtils.hide();
      if (response.statusCode == 200 || response.statusCode == 201) {
        AppLogger.log("✅ OTP Resent: ${response.data}");
        SnackbarUtils.show(
            isError: false,
            response.data['message'] ?? AppStrings.get(AppStrings.snackKeyOtpResent));
        return true;
      }
      SnackbarUtils.show(response.data['message'] ?? AppStrings.get(AppStrings.commonKeyError));
      return false;
    } on DioException catch (e) {
      LoadingUtils.hide();
      AppLogger.log("❌ OTP Resend Error: ${e.response?.data ?? e.message}");
      final msg =
          e.response?.data?['message'] ?? e.message ?? AppStrings.get(AppStrings.commonKeyError);
      SnackbarUtils.show(msg);
      return false;
    }
  }

  /// LOGIN
  Future<Map<String, dynamic>?> login({
    required String email,
    required String password,
  }) async {
    try {
      LoadingUtils.show(AppStrings.get(AppStrings.authKeyLoggingIn));
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
      LoadingUtils.hide();

      if (response.statusCode == 200) {
        AppLogger.log("✅ LOGIN SUCCESS: ${response.data}");
        await LocalStorageService.setAccessToken(
          response.data['data']['access_token'],
        );
        await LocalStorageService.setRefreshToken(
          response.data['data']['refresh_token'],
        );
        SnackbarUtils.show(
            isError: false, response.data['message'] ?? AppStrings.get(AppStrings.authKeyLoginSuccess));
        return response.data['data'];
      }
      SnackbarUtils.show(response.data['message'] ?? AppStrings.get(AppStrings.commonKeyError));
      return null;
    } on DioException catch (e) {
      LoadingUtils.hide();
      AppLogger.log("❌ LOGIN ERROR: ${e.response?.data ?? e.message}");
      final msg =
          e.response?.data?['message'] ?? e.message ?? AppStrings.get(AppStrings.commonKeyError);
      SnackbarUtils.show(msg);
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

      AppLogger.log("✅ REFRESH TOKEN SUCCESS: ${response.statusCode}");
      if (response.statusCode == 200) {
        AppLogger.log("✅ REFRESH TOKEN SUCCESS: ${response.data}");
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
      AppLogger.log("❌ REFRESH TOKEN ERROR: ${e.response?.data ?? e.message}");
      if (e.response?.statusCode == 401) {
        LocalStorageService.clearTokens();
        final msg = e.response?.data?['message'] ??
            e.message ??
            "Session expired, please login again";
        SnackbarUtils.show(msg);
        go.Get.toNamed('/login');
      }
      return null;
    }
  }

  /// RESET PASSWORD
  Future<bool> forgotPassword({required String email}) async {
    try {
      LoadingUtils.show(AppStrings.get(AppStrings.authKeySendingReset));
      final response = await _dio.post(
        '${ApiEndpoints.RESET_PASSWORD}?email=$email',
        options: Options(headers: {'Accept': 'application/json'}),
      );
      LoadingUtils.hide();

      if (response.statusCode == 200 && response.data['status_code'] == 200) {
        AppLogger.log("✅ Reset password success: ${response.data}");
        SnackbarUtils.show(
            isError: false, response.data['message'] ?? AppStrings.get(AppStrings.commonKeySuccess));
        return true;
      } else {
        AppLogger.log("⚠️ Reset password failed: ${response.data}");
        SnackbarUtils.show(response.data['message'] ?? AppStrings.get(AppStrings.commonKeyError));
        return false;
      }
    } on DioException catch (e) {
      LoadingUtils.hide();
      AppLogger.log("❌ Reset password error: ${e.response?.data ?? e.message}");
      final msg =
          e.response?.data?['message'] ?? e.message ?? AppStrings.get(AppStrings.commonKeyError);
      SnackbarUtils.show(msg);
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
      LoadingUtils.show(AppStrings.get(AppStrings.authKeyResettingPassword));
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
      LoadingUtils.hide();

      AppLogger.log("✅ Reset password success: ${response.data}");
      SnackbarUtils.show(isError: false, response.data['message'] ?? AppStrings.get(AppStrings.commonKeySuccess));
      return response;
    } on DioException catch (e) {
      LoadingUtils.hide();
      AppLogger.log("❌ Reset password error: ${e.response?.data ?? e.message}");
      final msg =
          e.response?.data?['message'] ?? e.message ?? AppStrings.get(AppStrings.commonKeyError);
      SnackbarUtils.show(msg);
      rethrow;
    }
  }
}
