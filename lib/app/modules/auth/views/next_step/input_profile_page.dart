// ignore_for_file: no_leading_underscores_for_local_identifiers, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:sehati/app/common/utils/validator.dart';
import 'package:sehati/app/common/widgets/app_button.dart';
import 'package:sehati/app/modules/auth/controllers/auth_controller.dart';

class InputProfilePage extends GetView<AuthController> {
  const InputProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final _profileFormKey = GlobalKey<FormState>();

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Profile",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Complete your profile",
                          style: TextStyle(color: Colors.black54, fontSize: 14),
                        ),
                        SizedBox(height: 24),
                      ],
                    ),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: AppAssetUtils.svg(
                          AppAssets.profileIcon,
                          width: 80,
                          height: 80,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Name (read-only)
                _buildInput(
                  label: "Name",
                  icon: AppAssets.peopleIcon,
                  controller: controller.nameController,
                  readOnly: true,
                ),
                const SizedBox(height: 16),

                // Nickname
                _buildInput(
                  label: "Nick Name",
                  icon: AppAssets.peopleIcon,
                  controller: controller.nicknameController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty)
                      return "Nickname cannot be empty";
                    if (value.trim().length > 20) return "Nickname too long";
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Date of Birth
                _buildDateField(),
                const SizedBox(height: 16),

                // Gender Dropdown
                _buildDropdown(
                  label: "Gender",
                  icon: AppAssets.genderIcon,
                  items: const ["Male", "Female"],
                  onChanged: (val) =>
                      controller.selectedGender.value = val ?? "",
                ),
                const SizedBox(height: 16),

                // Email (read-only)
                _buildInput(
                  label: "Email",
                  icon: AppAssets.messageIcon,
                  controller: controller.emailController,
                  readOnly: true,
                ),
                const SizedBox(height: 16),

                // Password (read-only)
                Obx(
                  () => _buildPasswordField(
                    label: "Password",
                    icon: AppAssets.lockIcon,
                    textController: controller.passwordController,
                    obscureText: controller.isPasswordHidden.value,
                    controller: controller,
                    readOnly: true,
                  ),
                ),
                const SizedBox(height: 16),

                // Phone Number
                _buildInput(
                  label: "Phone Number",
                  icon: AppAssets.phoneIcon,
                  controller: controller.phoneController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Phone number cannot be empty";
                    }
                    if (!RegExp(r'^\d{10,15}$').hasMatch(value.trim())) {
                      return "Invalid phone number";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Next Button
                Obx(
                  () => AppButton(
                    text: "Sign up",
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
  }

  // Date Picker Field
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
                Obx(
                  () => Text(
                    controller.selectedDate.value.isEmpty
                        ? "Date of Birth"
                        : controller.selectedDate.value,
                    style: const TextStyle(color: Colors.orange, fontSize: 16),
                  ),
                ),
              ],
            ),
            const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.orange),
          ],
        ),
      ),
    );
  }

  // Input Field
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
          child: AppAssetUtils.svg(
            icon,
            width: 24,
            height: 24,
            color: Colors.black,
          ),
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

  // Dropdown Field
  Widget _buildDropdown({
    required String label,
    required String icon,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Obx(() {
      return InputDecorator(
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12.0),
            child: AppAssetUtils.svg(
              icon,
              width: 24,
              height: 24,
              color: Colors.black,
            ),
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
            hint: const Text("Dropdown list"),
            items: items
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: onChanged,
          ),
        ),
      );
    });
  }

  // Password Field
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
          child: AppAssetUtils.svg(
            icon,
            width: 24,
            height: 24,
            color: Colors.black,
          ),
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
