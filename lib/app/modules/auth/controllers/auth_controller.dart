// ignore_for_file: deprecated_member_use, prefer_is_empty

import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:sehati/app/data/config/dio_factory.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:sehati/app/common/localization/app_strings.dart';
import 'package:sehati/app/common/utils/snackbar_utils.dart';
import 'package:sehati/app/data/models/request/nutrition_req_model.dart';
import 'package:sehati/app/data/services/auth_service.dart';
import 'package:sehati/app/data/services/local_storage_service.dart';
import 'package:sehati/app/data/services/user_service.dart';
import 'package:sehati/app/routes/app_routes.dart';
import 'package:sehati/app/common/utils/app_logger.dart';

class AuthController extends GetxController {
  final _authService = AuthService();
  final _userService = UserService();
  // === Text Controllers ===
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final nicknameController = TextEditingController();
  final phoneController = TextEditingController();
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final otpController = TextEditingController();

  // === Form Key ===
  final formKeyForgot = GlobalKey<FormState>();
  final formKeyLogin = GlobalKey<FormState>();
  final formKeySignup = GlobalKey<FormState>();

  // === Reactive Variables ===
  final isLoading = false.obs;
  final isPasswordHidden = true.obs;
  final selectedGender = ''.obs;
  final selectedDate = ''.obs;

  //-----nutrition------
  var weight = 0.0.obs;
  var height = 0.0.obs;
  var bmi = 0.0.obs;
  var idealWeight = 0.0.obs;
  var status = ''.obs;
  var dateOfBirth = ''.obs;
  var age = 0.obs;

  final isConfirmForgotPass = false.obs;
  RxBool isNutritionSaved = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is Map) {
      nameController.text = Get.arguments['fullname'] ?? nameController.text;
      emailController.text = Get.arguments['email'] ?? emailController.text;
      phoneController.text =
          Get.arguments['phone_number'] ?? phoneController.text;
      dateOfBirth.value = Get.arguments['date_of_birth'] ?? dateOfBirth.value;
      passwordController.text =
          Get.arguments['password'] ?? passwordController.text;
      nicknameController.text =
          Get.arguments['nickname'] ?? nicknameController.text;
      selectedGender.value = Get.arguments['gender'] ?? selectedGender.value;
    }
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // Only clears text fields — no reactive variables to avoid Obx rebuild loop
  void clearLoginFields() {
    emailController.clear();
    passwordController.clear();
    isPasswordHidden.value = true;
  }

  void resetLoginFields() {
    emailController.clear();
    passwordController.clear();
    nameController.clear();
    nicknameController.clear();
    phoneController.clear();
    selectedGender.value = '';
    selectedDate.value = '';
    isPasswordHidden.value = true;
    isLoading.value = false;
  }

  // === REGISTER ===
  Future<void> register() async {
    FocusScope.of(Get.context!).unfocus();
    isLoading.value = true;
    EasyLoading.show();

    try {
      final response = await _authService.registerUser(
        fullname: nameController.text.trim(),
        email: emailController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        dateOfBirth: dateOfBirth.value,
        password: passwordController.text.trim(),
        nickname: nicknameController.text.trim(),
        gender: selectedGender.value.toLowerCase(),
      );
      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        EasyLoading.dismiss();
        isLoading.value = false;
        SnackbarUtils.show(
          response.data['message'] ??
              AppStrings.get(AppStrings.commonKeySuccess),
          isError: false,
        );
        Get.offAllNamed(
          '/verify_otp',
          arguments: {
            'fullname': nameController.text.trim(),
            'email': emailController.text.trim(),
            'phone_number': phoneController.text.trim(),
            'date_of_birth': dateOfBirth.value,
            'password': passwordController.text.trim(),
            'nickname': nicknameController.text.trim(),
            'gender': selectedGender.value.toLowerCase(),
          },
        );
      } else {
        EasyLoading.dismiss();
        isLoading.value = false;
        SnackbarUtils.show(
          response?.data?['message'] ??
              AppStrings.get(AppStrings.commonKeyError),
        );
      }
    } on DioException catch (e) {
      EasyLoading.dismiss();
      isLoading.value = false;
      final message =
          e.response?.data?['message'] ??
          e.message ??
          AppStrings.get(AppStrings.commonKeyError);
      SnackbarUtils.show(message);
    } catch (e) {
      EasyLoading.dismiss();
      isLoading.value = false;
      SnackbarUtils.show(AppStrings.get(AppStrings.commonKeyError));
    }
  }

  // === PILIH TANGGAL LAHIR ===
  Future<void> selectDate() async {
    final now = DateTime.now();
    final picked = await Get.dialog<DateTime>(
      Theme(
        data: Theme.of(Get.context!).copyWith(
          datePickerTheme: DatePickerThemeData(
            backgroundColor: Colors.white,
            headerBackgroundColor: Colors.orange,
            headerForegroundColor: Colors.white,
            dayForegroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return Colors.white;
              }
              return Colors.black;
            }),
            todayBackgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return Colors.orange;
              }
              return Colors.orange.withOpacity(0.2);
            }),
            todayForegroundColor: WidgetStateProperty.all(Colors.white),
            todayBorder: const BorderSide(color: Colors.orange, width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            confirmButtonStyle: TextButton.styleFrom(
              foregroundColor: Colors.orange,
            ),
            cancelButtonStyle: TextButton.styleFrom(
              foregroundColor: Colors.grey[700],
            ),
          ),
        ),
        child: DatePickerDialog(
          initialDate: now,
          firstDate: DateTime(1950),
          lastDate: now,
        ),
      ),
    );

    if (picked != null) {
      final formatted = DateFormat('yyyy-MM-dd').format(picked);
      selectedDate.value = formatted;
      dateOfBirth.value = formatted;
    }
  }

  // === VERIFY OTP ===
  Future<bool> verifyOtp(String email, String otp) async {
    FocusScope.of(Get.context!).unfocus();
    isLoading.value = true;
    EasyLoading.show();
    try {
      final response = await _authService.verifyOtp(email: email, code: otp);
      if (response == true) {
        EasyLoading.dismiss();
        isLoading.value = false;
        // Snackbar is already shown in AuthService.verifyOtp
        await Future.delayed(const Duration(milliseconds: 800));
        Get.offAllNamed(AppRoutes.SPLASH);
      } else {
        EasyLoading.dismiss();
        isLoading.value = false;
      }
      return response;
    } on DioException {
      EasyLoading.dismiss();
      isLoading.value = false;
      // Snackbar is already shown in AuthService.verifyOtp
      return false;
    } catch (e) {
      EasyLoading.dismiss();
      isLoading.value = false;
      final msg = e.toString().replaceFirst('Exception: ', '');
      SnackbarUtils.show(
        msg.isNotEmpty ? msg : AppStrings.get(AppStrings.commonKeyError),
      );
      return false;
    }
  }

  /// LOGIN
  Future<void> login(String email, String password) async {
    FocusScope.of(Get.context!).unfocus();
    isLoading.value = true;
    EasyLoading.show();

    try {
      final data = await _authService.login(email: email, password: password);

      if (data != null) {
        EasyLoading.dismiss();
        isLoading.value = false;
        try {
          String? fcmToken = await FirebaseMessaging.instance.getToken();
          print('FCM Token: $fcmToken');

          if (fcmToken != null) {
            final dio = DioFactory.create();
            final accessToken = LocalStorageService.getAccessToken();
            await dio.post(
              ApiEndpoints.SAVE_TOKEN_FCM,
              data: {"token_fcm": fcmToken},
              options: Options(
                headers: {
                  "Accept": "application/json",
                  "Authorization": "Bearer $accessToken",
                },
              ),
            );
            AppLogger.log("Berhasil POST FCM Token");
          }
        } catch (e) {
          AppLogger.log("Failed to register FCM token after login: $e");
        }

        var nutritionData = await _userService.getUserNutrition();
        if (nutritionData?.length == 0) {
          Get.toNamed(AppRoutes.NUTRITION);
          return;
        }
        Get.offAllNamed('/dashboard');
      } else {
        EasyLoading.dismiss();
        isLoading.value = false;
      }
    } on DioException {
      EasyLoading.dismiss();
      isLoading.value = false;
      // Snackbar is already shown in AuthService.login
    } catch (e) {
      EasyLoading.dismiss();
      isLoading.value = false;
      SnackbarUtils.show(AppStrings.get(AppStrings.commonKeyError));
    }
  }

  /// REFRESH TOKEN
  Future<void> refreshToken() async {
    final token = LocalStorageService.getRefreshToken();

    if (token == null) return;

    try {
      final newAccess = await _authService.refreshToken(refreshToken: token);
      if (newAccess != null) {
        EasyLoading.dismiss();
        LocalStorageService.setAccessToken(newAccess);
      }
    } on DioException {
      EasyLoading.dismiss();
      isLoading.value = false;
      // Snackbar is already shown in AuthService.refreshToken
    } catch (e) {
      log("Refresh token failed: $e");
    }
  }

  // Resend OTP
  Future<void> resendOtp() async {
    isLoading.value = true;
    try {
      await _authService.resendOtp(
        fullname: nameController.text.trim(),
        email: emailController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        dateOfBirth: dateOfBirth.value,
        password: passwordController.text.trim(),
        nickname: nicknameController.text.trim(),
        gender: selectedGender.value.toLowerCase(),
      );
    } finally {
      isLoading.value = false;
      EasyLoading.dismiss();
    }
  }

  String? confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) return 'Harus diisi';
    if (value != newPasswordController.text.trim()) {
      return 'Password tidak sama';
    }
    return null;
  }

  Future<void> resetPassword(String email) async {
    if (emailController.text.isEmpty) return;

    isLoading.value = true;
    EasyLoading.show();

    try {
      final response = await _authService.forgotPassword(email: email);

      if (response == true) {
        EasyLoading.dismiss();
        isConfirmForgotPass.value = true;
        isLoading.value = false;
      } else {
        EasyLoading.dismiss();
        isLoading.value = false;
      }
    } on DioException {
      EasyLoading.dismiss();
      isLoading.value = false;
    } catch (e) {
      EasyLoading.dismiss();
      isLoading.value = false;
      SnackbarUtils.show(AppStrings.get(AppStrings.commonKeyError));
    }
  }

  Future<void> resetPasswordConfirm(String email, String code) async {
    if (!formKeyForgot.currentState!.validate()) return;
    isLoading.value = true;
    EasyLoading.show();
    try {
      final response = await _authService.confirmForgotPassword(
        email: email,
        otp: code,
        newPassword: newPasswordController.text.trim(),
        confirmPassword: confirmPasswordController.text.trim(),
      );

      if (response != null && response.statusCode == 200) {
        Get.offAllNamed(
          '/login',
          arguments: {
            'email': emailController.text.trim(),
            'password': confirmPasswordController.text.trim(),
          },
        );
        EasyLoading.dismiss();
        isLoading.value = false;
        // Snackbar is already shown in AuthService.confirmForgotPassword
      }
    } catch (e) {
      EasyLoading.dismiss();
      isLoading.value = false;
    } finally {
      isLoading.value = false;
      EasyLoading.dismiss();
    }
  }

  Future<void> submitNutrition() async {
    final weightVal = double.tryParse(weightController.text) ?? 0;
    final heightVal = double.tryParse(heightController.text) ?? 0;

    if (weightVal <= 0 || heightVal <= 0) {
      SnackbarUtils.show(AppStrings.get(AppStrings.commonKeyInvalidInput));
      return;
    }

    isLoading.value = true;
    EasyLoading.show();

    try {
      final request = NutritionCreateRequest(
        weightKg: weightVal,
        heightCm: heightVal,
      );

      final result = await UserService().createNutrition(request);

      EasyLoading.dismiss();
      isLoading.value = false;

      if (result != null) {
        bmi.value = result.bmi;
        status.value = result.status;
        idealWeight.value = result.idealWeightKg;
        isNutritionSaved.value = true;
        // Snackbar is already shown in UserService.createNutrition
      } else {
        // If result is null, UserService might have already shown an error snackbar
      }
    } catch (e) {
      EasyLoading.dismiss();
      isLoading.value = false;
      SnackbarUtils.show(AppStrings.get(AppStrings.commonKeyError));
    }
  }
}
