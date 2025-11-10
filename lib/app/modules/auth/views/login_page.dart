import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:sehati/app/common/widgets/app_button.dart';
import 'package:sehati/app/common/utils/validator.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends GetView<AuthController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments ?? {};
    final prefillEmail = args['email'] ?? '';
    final prefillPassword = args['password'] ?? '';

    controller.emailController.text = prefillEmail;
    controller.passwordController.text = prefillPassword;
    return Scaffold(
      body: Stack(
        children: [
          _background(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: controller.formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    const Text(
                      "Welcome",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 40),
                        child: AppAssetUtils.svg(
                          AppAssets.logoSehati,
                          width: 260,
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: controller.emailController,
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: AppAssetUtils.svg(
                            AppAssets.messageIcon,
                            width: 16,
                            height: 16,
                            color: Colors.green,
                          ),
                        ),
                        labelText: "Email",
                        border: const OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: Validator.email,
                    ),
                    const SizedBox(height: 16),
                    Obx(() {
                      return TextFormField(
                        controller: controller.passwordController,
                        obscureText: controller
                            .isPasswordHidden
                            .value, // reactive hide/show
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: AppAssetUtils.svg(
                              AppAssets.lockIcon,
                              width: 24,
                              height: 24,
                              color: Colors.green,
                            ),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              controller.isPasswordHidden.toggle();
                            },
                            icon: Icon(
                              controller.isPasswordHidden.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          labelText: "Password",
                          border: const OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: Validator.password,
                      );
                    }),

                    const SizedBox(height: 32),
                    Obx(
                      () => AppButton(
                        text: "Masuk",
                        isLoading: controller.isLoading.value,
                        onPressed: controller.isLoading.value
                            ? null
                            : () async => await controller.login(
                                controller.emailController.text.trim(),
                                controller.passwordController.text.trim(),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Lupa Password?",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 👇 Tambahan baru
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don’t have an account? ",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed('/signup');
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Color.fromARGB(
                                255,
                                19,
                                11,
                                3,
                              ), // oranye dari tema kamu
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ Background gradient + ilustrasi
  Widget _background() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFD84E), Color(0xFFFF9A3D)],
        ),
      ),
    );
  }
}
