import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:sehati/app/common/utils/validator.dart';
import 'package:sehati/app/common/widgets/app_button.dart';
import '../controllers/auth_controller.dart';

class RegisterPage extends GetView<AuthController> {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnimatedIn(
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.toNamed('/login'),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              AnimatedIn(
                child: AnimatedIn(
                  child: Row(
                    children: [
                      const Text(
                        "Already registered? ",
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                      GestureDetector(
                        onTap: () => Get.toNamed('/login'), // balik ke login
                        child: const Text(
                          "Sign in",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // SVG Illustration
              Center(
                child: AnimatedIn(child: AppAssetUtils.svg(AppAssets.logoSehati, width: 250)),
              ),

              const SizedBox(height: 40),

              // === FORM FIELD ===
              Form(
                key: controller.formKeySignup,
                child: Column(
                  children: [
                    AnimatedIn(
                      child: TextFormField(
                        controller: controller.nameController,
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: AppAssetUtils.svg(
                              AppAssets.peopleIcon,
                              width: 24,
                              height: 24,
                              color: Colors.black,
                            ),
                          ),
                          labelText: "Name",
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
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Name cannot be empty";
                          }
                          return null; // valid
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    AnimatedIn(
                      child: TextFormField(
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
                          labelText: "Email",
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
                    ),
                    const SizedBox(height: 16),

                    // Password Field with eye toggle
                    Obx(() {
                      return AnimatedIn(
                        child: TextFormField(
                          controller: controller.passwordController,
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
                            labelText: "Password",
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
                          validator: Validator.password,
                        ),
                      );
                    }),
                    const SizedBox(height: 32),

                    // Button
                    Obx(
                      () => AnimatedIn(
                        child: AppButton(
                          text: "Next",
                          isLoading: controller.isLoading.value,
                          onPressed: controller.isLoading.value
                              ? null
                              : () {
                                  if (controller.formKeySignup.currentState!
                                      .validate()) {
                                    Get.toNamed('/input_profile');
                                  }
                                },
                          iconRight: AppAssetUtils.svg(AppAssets.rightIcon),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
