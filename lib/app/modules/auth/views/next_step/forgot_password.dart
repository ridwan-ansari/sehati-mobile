// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/localization/app_strings.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:sehati/app/common/utils/validator.dart';
import 'package:sehati/app/common/widgets/app_button.dart';
import 'package:sehati/app/modules/auth/controllers/auth_controller.dart';

class ForgotPasswordPage extends GetView<AuthController> {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: const Text(
          "Forgot Password",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: controller.formKeyForgot,
            child: Column(
              children: [
                TextFormField(
                  controller: controller.emailController,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: AppAssetUtils.svg(
                        AppAssets.messageIcon,
                        width: 16,
                        height: 14,
                        color: Colors.black,
                      ),
                    ),
                    labelText: AppStrings.get(AppStrings.commonKeyEmail),
                    labelStyle: const TextStyle(color: Colors.orange),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.black54),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.orange),
                    ),
                  ),
                  validator: Validator.email,
                ),
                const SizedBox(height: 16),
                Obx(() {
                  return Column(
                    children: [
                      if (controller.isConfirmForgotPass.value == true)
                        TextFormField(
                          controller: controller.otpController,
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: AppAssetUtils.svg(
                                AppAssets.otpIcon,
                                width: 24,
                                height: 24,
                                color: Colors.black,
                              ),
                            ),

                            labelText: AppStrings.get(AppStrings.forgotKeyOtp),
                            labelStyle: const TextStyle(color: Colors.orange),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.black54,
                              ),
                            ),

                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.orange,
                              ),
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
                    ],
                  );
                }),

                const SizedBox(height: 16),
                // New Password
                Obx(() {
                  return Column(
                    children: [
                      if (controller.isConfirmForgotPass.value == true)
                        TextFormField(
                          controller: controller.newPasswordController,
                          obscureText: controller.isPasswordHidden.value,
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: AppAssetUtils.svg(
                                AppAssets.lockIcon,
                                width: 24,
                                height: 24,
                                color: Colors.black,
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.isPasswordHidden.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey.shade700,
                              ),
                              onPressed: () =>
                                  controller.isPasswordHidden.toggle(),
                            ),
                            labelText: AppStrings.get(AppStrings.forgotKeyNewPassword),
                            labelStyle: const TextStyle(color: Colors.orange),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.black54,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.orange,
                              ),
                            ),
                          ),
                          validator: Validator.password,
                        ),
                    ],
                  );
                }),

                const SizedBox(height: 16),

                // Confirm Password
                Obx(() {
                  return Column(
                    children: [
                      if (controller.isConfirmForgotPass.value == true)
                        TextFormField(
                          controller: controller.confirmPasswordController,
                          obscureText: controller.isPasswordHidden.value,
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: AppAssetUtils.svg(
                                AppAssets.lockIcon,
                                width: 24,
                                height: 24,
                                color: Colors.black,
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.isPasswordHidden.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey.shade700,
                              ),
                              onPressed: () =>
                                  controller.isPasswordHidden.toggle(),
                            ),
                            labelText: AppStrings.get(AppStrings.forgotKeyConfirmPassword),
                            labelStyle: const TextStyle(color: Colors.orange),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.black54,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.orange,
                              ),
                            ),
                          ),
                          validator: controller.confirmPasswordValidator,
                        ),
                    ],
                  );
                }),

                const SizedBox(height: 32),

                // Button
                Obx(
                  () => AppButton(
                    text: "Forgot Password",
                    isLoading: controller.isLoading.value,
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                            if (controller.formKeyForgot.currentState!.validate()) {
                              controller.isConfirmForgotPass == true
                                  ? controller.resetPasswordConfirm(
                                      controller.emailController.text.trim(),
                                      controller.otpController.text.trim(),
                                    )
                                  : controller.resetPassword(
                                      controller.emailController.text.trim(),
                                    );
                            }
                          },
                    iconRight: AppAssetUtils.svg(AppAssets.rightIcon),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
