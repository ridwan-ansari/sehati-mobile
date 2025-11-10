import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:sehati/app/data/services/nutritional_service.dart';

class AuthController extends GetxController {
  // === Text Controllers ===
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final nicknameController = TextEditingController();
  final phoneController = TextEditingController();
  final weightController = TextEditingController();
  final heightController = TextEditingController();

  // === Form Key ===
  final formKey = GlobalKey<FormState>();

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

  @override
  void onInit() {
    super.onInit();

    weightController.addListener(calculate);
    heightController.addListener(calculate);
    ever(selectedDate, (_) => calculate());
  }

  // === LOGIN ===
  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    FocusScope.of(Get.context!).unfocus();
    EasyLoading.show(status: 'Memproses...');

    // Simulasi API
    await Future.delayed(const Duration(seconds: 2));
    EasyLoading.dismiss();

    if (emailController.text == "admin@mail.com" &&
        passwordController.text == "123456") {
      Get.snackbar(
        "Berhasil",
        "Login sukses!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      Get.offAllNamed('/dashboard');
    } else {
      Get.snackbar(
        "Gagal",
        "Email atau password salah",
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  // === REGISTER ===
  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;

    FocusScope.of(Get.context!).unfocus();
    isLoading.value = true;
    EasyLoading.show(status: "Mendaftarkan akun...");

    await Future.delayed(const Duration(seconds: 2));

    isLoading.value = false;
    EasyLoading.dismiss();

    Get.snackbar(
      "Berhasil",
      "Akun berhasil dibuat!",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );

    // Lanjut ke pengisian profil
    Get.toNamed('/profile');
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
      selectedDate.value = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  void calculate() {
    // Update nilai dari text field
    weight.value = double.tryParse(weightController.text) ?? 0;
    height.value = double.tryParse(heightController.text) ?? 0;
    dateOfBirth.value = selectedDate.value;

    if (weight.value > 0 && height.value > 0) {
      bmi.value = NutritionalService.calculateBMI(weight.value, height.value);
      status.value = NutritionalService.getNutritionalStatus(bmi.value);
      idealWeight.value = NutritionalService.calculateIdealWeight(height.value);
    }

    if (dateOfBirth.value.isNotEmpty) {
      final dob = DateFormat('yyyy-MM-dd').parse(dateOfBirth.value);
      age.value = NutritionalService.calculateAge(dob);
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    nicknameController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
