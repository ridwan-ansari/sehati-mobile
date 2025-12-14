// ignore_for_file: deprecated_member_use, prefer_is_empty

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:sehati/app/common/utils/snackbar_utils.dart';
import 'package:sehati/app/data/models/request/nutrition_req_model.dart';
import 'package:sehati/app/data/services/auth_service.dart';
import 'package:sehati/app/data/services/local_storage_service.dart';
import 'package:sehati/app/data/services/user_service.dart';
import 'package:sehati/app/routes/app_routes.dart';

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

    // weightController.addListener(calculate);
    // heightController.addListener(calculate);
    // ever(selectedDate, (_) => calculate());
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
    print(isConfirmForgotPass.value);
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
    // if (!formKeySignup.currentState!.validate()) return;

    FocusScope.of(Get.context!).unfocus();
    isLoading.value = true;
    EasyLoading.show(status: "Mendaftarkan akun...");

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
        Get.offAllNamed(
          '/verify_otp',
          arguments: {'email': emailController.text.trim()},
        );
      } else {
        EasyLoading.dismiss();
        isLoading.value = false;
      }
    } on DioException catch (e) {
      EasyLoading.dismiss();
      isLoading.value = false;

      String message = "Terjadi kesalahan";
      if (e.response != null &&
          e.response?.data != null &&
          e.response?.data['message'] != null) {
        message = e.response!.data['message'];
      } else if (e.message != null) {
        message = e.message!;
      }
      SnackbarUtils.show(message);
    } catch (e) {
      EasyLoading.dismiss();
      isLoading.value = false;
      Get.snackbar(
        "Error",
        "Terjadi kesalahan: $e",
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
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

  // void calculate() {
  //   // Update nilai dari text field
  //   weight.value = double.tryParse(weightController.text) ?? 0;
  //   height.value = double.tryParse(heightController.text) ?? 0;
  //   dateOfBirth.value = selectedDate.value;

  //   if (weight.value > 0 && height.value > 0) {
  //     bmi.value = NutritionalService.calculateBMI(weight.value, height.value);
  //     status.value = NutritionalService.getNutritionalStatus(bmi.value);
  //     idealWeight.value = NutritionalService.calculateIdealWeight(height.value);
  //   }

  //   if (dateOfBirth.value.isNotEmpty) {
  //     final dob = DateFormat('yyyy-MM-dd').parse(dateOfBirth.value);
  //     age.value = NutritionalService.calculateAge(dob);
  //   }
  // }

  // Verifikasi OTP
  Future<bool> verifyOtp(String email, String otp) async {
    FocusScope.of(Get.context!).unfocus();
    isLoading.value = true;
    EasyLoading.show(status: "Verify Otp ...");
    try {
      final response = await _authService.verifyOtp(email: email, code: otp);
      if (response == true) {
        Get.offAllNamed(AppRoutes.SPLASH);
      } else {
        EasyLoading.dismiss();
        isLoading.value = false;
      }
      return false;
    } on DioException catch (e) {
      EasyLoading.dismiss();
      isLoading.value = false;

      String message = "Terjadi kesalahan";
      if (e.response != null &&
          e.response?.data != null &&
          e.response?.data['message'] != null) {
        message = e.response!.data['message'];
      } else if (e.message != null) {
        message = e.message!;
      }
      SnackbarUtils.show(message);
      return false;
    } catch (e) {
      EasyLoading.dismiss();
      isLoading.value = false;
      return false;
    } finally {
      isLoading.value = false;
      if (EasyLoading.isShow) EasyLoading.dismiss();
    }
  }

  /// LOGIN
  Future<void> login(String email, String password) async {
    FocusScope.of(Get.context!).unfocus();
    isLoading.value = true;
    EasyLoading.show(status: 'Login...');

    try {
      final data = await _authService.login(email: email, password: password);

      if (data != null) {
        EasyLoading.dismiss();
        isLoading.value = false;
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
    } on DioException catch (e) {
      EasyLoading.dismiss();
      isLoading.value = false;

      String message = "Terjadi kesalahan";
      if (e.response != null &&
          e.response?.data != null &&
          e.response?.data['message'] != null) {
        message = e.response!.data['message'];
      } else if (e.message != null) {
        message = e.message!;
      }
      SnackbarUtils.show(message);
    } catch (e) {
      EasyLoading.dismiss();
      isLoading.value = false;
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
    } on DioException catch (e) {
      EasyLoading.dismiss();
      isLoading.value = false;

      String message = "Terjadi kesalahan";
      if (e.response != null &&
          e.response?.data != null &&
          e.response?.data['message'] != null) {
        message = e.response!.data['message'];
      } else if (e.message != null) {
        message = e.message!;
      }
      SnackbarUtils.show(message);
    } catch (e) {
      log("Refresh token failed: $e");
    }
  }

  // Resend OTP
  Future<void> resendOtp(String email) async {
    // await sendOtp(email);
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
    EasyLoading.show(status: "Reset Password...");

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
    } on DioException catch (e) {
      EasyLoading.dismiss();
      isLoading.value = false;

      String message = "Terjadi kesalahan";
      if (e.response != null &&
          e.response?.data != null &&
          e.response?.data['message'] != null) {
        message = e.response!.data['message'];
      } else if (e.message != null) {
        message = e.message!;
      }
      SnackbarUtils.show(message);
    } catch (e) {
      EasyLoading.dismiss();
      isLoading.value = false;
    }
  }

  Future<void> resetPasswordConfirm(String email, String code) async {
    if (!formKeyForgot.currentState!.validate()) return;
    isLoading.value = true;
    EasyLoading.show(status: "Forgot Password ...");
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
      }
    } catch (e) {
      EasyLoading.dismiss();
      isLoading.value = false;
    } finally {
      isLoading.value = false;
      EasyLoading.dismiss();
      isLoading.value = false;
    }
  }

  Future<void> submitNutrition() async {
    final weightVal = double.tryParse(weightController.text) ?? 0;
    final heightVal = double.tryParse(heightController.text) ?? 0;

    if (weightVal <= 0 || heightVal <= 0) {
      SnackbarUtils.show("Please enter valid weight & height");
      return;
    }

    final request = NutritionCreateRequest(
      weightKg: weightVal,
      heightCm: heightVal,
    );

    final result = await UserService().createNutrition(request);

    if (result != null) {
      // isi ulang field dari API
      bmi.value = result.bmi;
      status.value = result.status;
      idealWeight.value = result.idealWeightKg;
      isNutritionSaved.value = true;
    }
  }

  // @override
  // void onClose() {
  //   emailController.dispose();
  //   passwordController.dispose();
  //   nameController.dispose();
  //   nicknameController.dispose();
  //   phoneController.dispose();
  //   weightController.dispose();
  //   heightController.dispose();
  //   newPasswordController.dispose();
  //   confirmPasswordController.dispose();
  //   otpController.dispose();
  //   super.onClose();
  // }
}
