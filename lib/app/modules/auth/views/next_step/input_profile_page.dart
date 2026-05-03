// ignore_for_file: no_leading_underscores_for_local_identifiers, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/localization/app_strings.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:sehati/app/common/utils/validator.dart';
import 'package:sehati/app/common/widgets/app_button.dart';
import 'package:sehati/app/data/services/language_service.dart';
import 'package:sehati/app/modules/auth/controllers/auth_controller.dart';

class InputProfilePage extends GetView<AuthController> {
  const InputProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final _profileFormKey = GlobalKey<FormState>();

    return Obx(() {
      Get.find<LanguageService>().currentLanguage.value;
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _profileFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  // Header
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.get(AppStrings.registerKeyTitle),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppStrings.get(AppStrings.profileKeyCompleteSignUp),
                        style: const TextStyle(color: Colors.black54, fontSize: 14),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Name
                  _buildInput(
                    label: AppStrings.get(AppStrings.profileKeyFullName),
                    icon: AppAssets.peopleIcon,
                    controller: controller.nameController,
                    readOnly: false,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty)
                        return AppStrings.get(AppStrings.validationKeyNameRequired);
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Nickname
                  _buildInput(
                    label: AppStrings.get(AppStrings.profileKeyNickName),
                    icon: AppAssets.peopleIcon,
                    controller: controller.nicknameController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty)
                        return AppStrings.get(AppStrings.validationKeyNicknameRequired);
                      if (value.trim().length > 20)
                        return AppStrings.get(AppStrings.validationKeyNicknameTooLong);
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Date of Birth
                  _buildDateField(),
                  const SizedBox(height: 16),

                  // Gender Dropdown
                  _buildDropdown(
                    label: AppStrings.get(AppStrings.profileKeyGender),
                    icon: AppAssets.genderIcon,
                    onChanged: (val) => controller.selectedGender.value = val ?? "",
                  ),
                  const SizedBox(height: 16),

                  // Email
                  _buildInput(
                    label: AppStrings.get(AppStrings.commonKeyEmail),
                    icon: AppAssets.messageIcon,
                    controller: controller.emailController,
                    readOnly: false,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty)
                        return AppStrings.get(AppStrings.validationKeyEmailRequired);
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password
                  Obx(
                    () => _buildPasswordField(
                      label: AppStrings.get(AppStrings.commonKeyPassword),
                      icon: AppAssets.lockIcon,
                      textController: controller.passwordController,
                      obscureText: controller.isPasswordHidden.value,
                      controller: controller,
                      readOnly: false,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Phone Number
                  _buildInput(
                    label: AppStrings.get(AppStrings.profileKeyPhone),
                    icon: AppAssets.phoneIcon,
                    controller: controller.phoneController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty)
                        return AppStrings.get(AppStrings.validationKeyPhoneRequired);
                      if (!RegExp(r'^\d{10,15}$').hasMatch(value.trim()))
                        return AppStrings.get(AppStrings.validationKeyPhoneInvalid);
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // Sign Up Button
                  Obx(
                    () => AppButton(
                      text: AppStrings.get(AppStrings.registerKeyTitle),
                      isLoading: controller.isLoading.value,
                      onPressed: controller.isLoading.value
                          ? null
                          : () {
                              if (_profileFormKey.currentState!.validate()) {
                                controller.register();
                              }
                            },
                      iconRight: AppAssetUtils.svg(
                        AppAssets.rightIcon,
                        width: 22,
                        height: 22,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildDateField() {
    return GestureDetector(
      onTap: () => controller.selectDate(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black54),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                AppAssetUtils.svg(
                  AppAssets.dateIcon,
                  width: 22,
                  height: 22,
                  color: Colors.black,
                ),
                const SizedBox(width: 10),
                Obx(() {
                  Get.find<LanguageService>().currentLanguage.value;
                  return Text(
                    controller.selectedDate.value.isEmpty
                        ? AppStrings.get(AppStrings.profileKeyDateOfBirth)
                        : controller.selectedDate.value,
                    style: const TextStyle(color: Colors.orange, fontSize: 16),
                  );
                }),
              ],
            ),
            const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildInput({
    required String label,
    required String icon,
    required TextEditingController controller,
    bool readOnly = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12.0),
          child: AppAssetUtils.svg(icon, width: 24, height: 24, color: Colors.black),
        ),
        labelText: label,
        labelStyle: TextStyle(color: readOnly ? Colors.grey : Colors.orange),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black54),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: readOnly ? Colors.grey : Colors.orange),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildDropdown({
    required String label,
    required String icon,
    required Function(String?) onChanged,
  }) {
    return Obx(() {
      Get.find<LanguageService>().currentLanguage.value;
      return InputDecorator(
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12.0),
            child: AppAssetUtils.svg(icon, width: 24, height: 24, color: Colors.black),
          ),
          labelText: label,
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
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controller.selectedGender.value.isEmpty
                ? null
                : controller.selectedGender.value,
            hint: Text(AppStrings.get(AppStrings.profileKeyGender)),
            items: [
              DropdownMenuItem(
                value: "Male",
                child: Text(AppStrings.get(AppStrings.profileKeyMale)),
              ),
              DropdownMenuItem(
                value: "Female",
                child: Text(AppStrings.get(AppStrings.profileKeyFemale)),
              ),
            ],
            onChanged: onChanged,
          ),
        ),
      );
    });
  }

  Widget _buildPasswordField({
    required String label,
    required String icon,
    required TextEditingController textController,
    required bool obscureText,
    required AuthController controller,
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: textController,
      readOnly: readOnly,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12.0),
          child: AppAssetUtils.svg(icon, width: 24, height: 24, color: Colors.black),
        ),
        suffixIcon: readOnly
            ? null
            : IconButton(
                icon: Icon(
                  controller.isPasswordHidden.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: Colors.grey.shade700,
                ),
                onPressed: () => controller.isPasswordHidden.toggle(),
              ),
        labelText: label,
        labelStyle: TextStyle(color: readOnly ? Colors.grey : Colors.orange),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black54),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: readOnly ? Colors.grey : Colors.orange),
        ),
      ),
      validator: readOnly ? null : Validator.password,
    );
  }
}
