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

                // ==== Header ====
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Profile",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Complete your profile",
                          style: TextStyle(color: Colors.black54, fontSize: 14),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                    // GestureDetector(
                    //   onTap: () => Get.toNamed('/signup'),
                    //   child: Container(
                    //     padding: const EdgeInsets.all(6),
                    //     decoration: const BoxDecoration(
                    //       color: Colors.redAccent,
                    //       shape: BoxShape.circle,
                    //     ),
                    //     child: const Icon(Icons.close, color: Colors.white),
                    //   ),
                    // ),
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

                // ==== FORM ====
                _buildInput(
                  label: "Name",
                  icon: AppAssets.peopleIcon,
                  controller: controller.nameController,
                ),
                const SizedBox(height: 16),

                _buildInput(
                  label: "Nick Name",
                  icon: AppAssets.peopleIcon,
                  controller: controller.nicknameController,
                ),
                const SizedBox(height: 16),
                 _buildDateField(),
                const SizedBox(height: 16),

                _buildDropdown(
                  label: "Gender",
                  icon: AppAssets.genderIcon,
                  items: const ["Male", "Female"],
                  onChanged: (val) =>
                      controller.selectedGender.value = val ?? "",
                ),
                const SizedBox(height: 16),

                _buildInput(
                  label: "Email",
                  icon: AppAssets.messageIcon,
                  controller: controller.emailController,
                ),
                const SizedBox(height: 16),

                Obx(
                  () => _buildPasswordField(
                    label: "Password",
                    icon: AppAssets.lockIcon,
                    textController: controller.passwordController,
                    obscureText: controller.isPasswordHidden.value,
                    controller: controller,
                  ),
                ),
                const SizedBox(height: 16),

                _buildInput(
                  label: "Phone Number",
                  icon: AppAssets.phoneIcon,
                  controller: controller.phoneController,
                ),
                const SizedBox(height: 32),

                // ==== Button ====
                Obx(
                  () => AppButton(
                    text: "Next",
                    isLoading: controller.isLoading.value,
                    onPressed: controller.isLoading.value
                        ? null
                        : () => Get.toNamed('/nutrition'),
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

  // ===== Widget Input Field =====
  Widget _buildInput({
    required String label,
    required String icon,
    required TextEditingController controller,
  }) {
    return TextFormField(
      controller: controller,
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
    );
  }

  // ===== Dropdown =====
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

  // ===== Password Field =====
 Widget _buildPasswordField({
  required String label,
  required String icon,
  required TextEditingController textController,
  required bool obscureText,
  required AuthController controller,
}) {
  return Obx(() {
    return TextFormField(
      controller: textController,
      obscureText: controller.isPasswordHidden.value,
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
        suffixIcon: IconButton(
          icon: Icon(
            controller.isPasswordHidden.value
                ? Icons.visibility_off
                : Icons.visibility,
            color: Colors.grey.shade700,
          ),
          onPressed: () => controller.isPasswordHidden.toggle(), // 👈 ini kuncinya
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
      validator: Validator.password,
    );
  });
}
}
