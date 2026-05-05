// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/localization/app_strings.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:sehati/app/common/utils/validator.dart';
import 'package:sehati/app/modules/auth/controllers/auth_controller.dart';

import 'package:sehati/app/common/constants/app_colors.dart';

class ForgotPasswordPage extends GetView<AuthController> {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: controller.formKeyForgot,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => Text(
                        controller.isConfirmForgotPass.value
                            ? AppStrings.getOr("Verify & Reset", "Verifikasi & Reset")
                            : AppStrings.getOr("Recover Password", "Pulihkan Kata Sandi"),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textDark,
                        ),
                      )),
                      const SizedBox(height: 8),
                      Obx(() => Text(
                        controller.isConfirmForgotPass.value
                            ? AppStrings.getOr("Enter the 6-digit code sent to your email and your new password.", "Masukkan 6 digit kode yang dikirim ke email dan kata sandi baru Anda.")
                            : AppStrings.getOr("Enter your email address to receive a password reset code.", "Masukkan alamat email Anda untuk menerima kode reset kata sandi."),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          height: 1.5,
                        ),
                      )),
                      const SizedBox(height: 32),
                      
                      // Email Field
                      TextFormField(
                        controller: controller.emailController,
                        enabled: !controller.isConfirmForgotPass.value,
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: AppAssetUtils.svg(
                              AppAssets.messageIcon,
                              width: 16,
                              height: 14,
                              color: controller.isConfirmForgotPass.value ? Colors.grey : AppColors.orangeLight,
                            ),
                          ),
                          hintText: AppStrings.get(AppStrings.commonKeyEmail),
                          filled: true,
                          fillColor: controller.isConfirmForgotPass.value ? Colors.grey.shade100 : Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: AppColors.orangeLight, width: 2),
                          ),
                        ),
                        validator: Validator.email,
                      ),
                      
                      Obx(() {
                        if (controller.isConfirmForgotPass.value) {
                          return Column(
                            children: [
                              const SizedBox(height: 20),
                              // OTP Field
                              TextFormField(
                                controller: controller.otpController,
                                decoration: InputDecoration(
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(14.0),
                                    child: AppAssetUtils.svg(
                                      AppAssets.otpIcon,
                                      width: 24,
                                      height: 24,
                                      color: AppColors.orangeLight,
                                    ),
                                  ),
                                  hintText: AppStrings.get(AppStrings.forgotKeyOtp),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(color: Colors.grey.shade200),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(color: Colors.grey.shade200),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(color: AppColors.orangeLight, width: 2),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                maxLength: 6,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'OTP cannot be empty';
                                  } else if (value.length < 6) {
                                    return 'OTP must be 6 digits';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              // New Password Field
                              TextFormField(
                                controller: controller.newPasswordController,
                                obscureText: controller.isPasswordHidden.value,
                                decoration: InputDecoration(
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(14.0),
                                    child: AppAssetUtils.svg(
                                      AppAssets.lockIcon,
                                      width: 24,
                                      height: 24,
                                      color: AppColors.orangeLight,
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      controller.isPasswordHidden.value
                                          ? Icons.visibility_off_rounded
                                          : Icons.visibility_rounded,
                                      color: Colors.grey,
                                      size: 20,
                                    ),
                                    onPressed: () => controller.isPasswordHidden.toggle(),
                                  ),
                                  hintText: AppStrings.get(AppStrings.forgotKeyNewPassword),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(color: Colors.grey.shade200),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(color: Colors.grey.shade200),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(color: AppColors.orangeLight, width: 2),
                                  ),
                                ),
                                validator: Validator.password,
                              ),
                              const SizedBox(height: 20),
                              // Confirm Password Field
                              TextFormField(
                                controller: controller.confirmPasswordController,
                                obscureText: controller.isPasswordHidden.value,
                                decoration: InputDecoration(
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(14.0),
                                    child: AppAssetUtils.svg(
                                      AppAssets.lockIcon,
                                      width: 24,
                                      height: 24,
                                      color: AppColors.orangeLight,
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      controller.isPasswordHidden.value
                                          ? Icons.visibility_off_rounded
                                          : Icons.visibility_rounded,
                                      color: Colors.grey,
                                      size: 20,
                                    ),
                                    onPressed: () => controller.isPasswordHidden.toggle(),
                                  ),
                                  hintText: AppStrings.get(AppStrings.forgotKeyConfirmPassword),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(color: Colors.grey.shade200),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(color: Colors.grey.shade200),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(color: AppColors.orangeLight, width: 2),
                                  ),
                                ),
                                validator: controller.confirmPasswordValidator,
                              ),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      }),

                      const SizedBox(height: 40),

                      // Submit Button
                      Obx(() => SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : () {
                                  if (controller.formKeyForgot.currentState!.validate()) {
                                    controller.isConfirmForgotPass.value
                                        ? controller.resetPasswordConfirm(
                                            controller.emailController.text.trim(),
                                            controller.otpController.text.trim(),
                                          )
                                        : controller.resetPassword(
                                            controller.emailController.text.trim(),
                                          );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.orangeLight,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      controller.isConfirmForgotPass.value
                                          ? AppStrings.getOr("Reset Password", "Reset Kata Sandi")
                                          : AppStrings.getOr("Send Code", "Kirim Kode"),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.arrow_forward_rounded, size: 18),
                                  ],
                                ),
                        ),
                      )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 24, 24),
      decoration: const BoxDecoration(
        color: AppColors.richBrown,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
              ),
              AppAssetUtils.svg(
                AppAssets.logoSehati,
                width: 40,
                height: 40,
              ),
              const SizedBox(width: 48), // Balancing IconButton width
            ],
          ),
          const SizedBox(height: 12),
          Text(
            AppStrings.get(AppStrings.forgotKeyTitle),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
