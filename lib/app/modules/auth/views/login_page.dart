import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/localization/app_strings.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:sehati/app/common/widgets/app_button.dart';
import 'package:sehati/app/common/utils/validator.dart';
import 'package:sehati/app/data/services/language_service.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late AuthController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<AuthController>();
    // Reset fields once on page load, not on every rebuild
    controller.clearLoginFields();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      Get.find<LanguageService>().currentLanguage.value;
      return Scaffold(
        body: Stack(
          children: [
            _background(),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: controller.formKeyLogin,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 60),
                      AnimatedIn(
                        child: Text(
                          AppStrings.getOr("Welcome", "Selamat Datang"),
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      AnimatedIn(
                        child: Text(
                          AppStrings.get(AppStrings.loginKeyTitle),
                          style: const TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
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
                      AnimatedIn(
                        child: TextFormField(
                          controller: controller.emailController,
                          keyboardType: TextInputType.emailAddress,
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
                            labelText: AppStrings.get(AppStrings.commonKeyEmail),
                            border: const OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: (value) {
                            final baseValidator = Validator.email(value);
                            if (baseValidator != null && !AppStrings.isEnglish) {
                              if (baseValidator.contains("Email")) {
                                return AppStrings.get(AppStrings.validationKeyEmailInvalid);
                              } else if (baseValidator.contains("cannot be empty")) {
                                return AppStrings.get(AppStrings.validationKeyEmailRequired);
                              }
                            }
                            return baseValidator;
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
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
                                  color: Colors.green,
                                ),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  controller.togglePasswordVisibility();
                                },
                                icon: Icon(
                                  controller.isPasswordHidden.value
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              labelText: AppStrings.get(AppStrings.commonKeyPassword),
                              border: const OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            validator: (value) {
                              final baseValidator = Validator.password(value);
                              if (baseValidator != null && !AppStrings.isEnglish) {
                                return AppStrings.get(AppStrings.validationKeyPasswordWeak);
                              }
                              return baseValidator;
                            },
                          ),
                        );
                      }),

                      const SizedBox(height: 32),
                      Obx(
                        () => AnimatedIn(
                          child: AppButton(
                            text: AppStrings.get(AppStrings.loginKeyButton),
                            isLoading: controller.isLoading.value,
                            onPressed: controller.isLoading.value
                                ? null
                                : () async {
                                    if (controller.formKeyLogin.currentState!.validate()) {
                                      await controller.login(
                                        controller.emailController.text.trim(),
                                        controller.passwordController.text.trim(),
                                      );
                                    }
                                  },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => Get.toNamed("/forgot_password"),
                        child: Text(
                          AppStrings.get(AppStrings.loginKeyForgot),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.get(AppStrings.loginKeyNoAccount),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed("/input_profile");
                            },
                            child: Text(
                              AppStrings.get(AppStrings.loginKeySignUp),
                              style: const TextStyle(
                                color: Color.fromARGB(255, 19, 11, 3),
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
    });
  }

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
