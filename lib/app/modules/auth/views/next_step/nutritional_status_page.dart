import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:sehati/app/common/utils/rx_extensions.dart';
import 'package:sehati/app/common/widgets/app_button.dart';
import 'package:sehati/app/modules/auth/controllers/auth_controller.dart';

class NutritionalStatusPage extends GetView<AuthController> {
  const NutritionalStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                // Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Nutritional\nStatus",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        height: 1.2,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: AppAssetUtils.svg(
                        AppAssets.profileIcon,
                        width: 48,
                        height: 48,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // === FORM ===

                _buildTextField(
                  "Current Bodyweight",
                  AppAssets.bodyWeightIcon,
                  controller.weightController,
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  "Current Bodyheight",
                  AppAssets.bodyHeightIcon,
                  controller.heightController,
                ),
                const SizedBox(height: 16),

                _buildAutoFillField(
                  "BMI",
                  AppAssets.bmiIcon,
                  controller.bmi.stringObs,
                ),
                const SizedBox(height: 16),

                _buildAutoFillField(
                  "Nutritional Status",
                  AppAssets.bmiIcon,
                  controller.status,
                ),
                const SizedBox(height: 16),

                _buildAutoFillField(
                  "Ideal Bodyweight",
                  AppAssets.bodyHeightIcon,
                  controller.idealWeight.stringObs,
                ),
                const SizedBox(height: 16),

                _buildDropdownField("Type of Activity", AppAssets.activityIcon),
                const SizedBox(height: 32),

                // Finish Button
                AppButton(
                  text: "Finish",
                  onPressed: () => Get.offAllNamed('/dashboard'),
                  iconRight: AppAssetUtils.svg(
                    AppAssets.rightIcon,
                    width: 20,
                    height: 20,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Regular Input
  Widget _buildTextField(
    String label,
    String iconPath,
    TextEditingController textController,
  ) {
    return TextFormField(
      controller: textController,
      keyboardType: TextInputType.number,
      onChanged: (_) => controller.calculate(),
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12.0),
          child: AppAssetUtils.svg(
            iconPath,
            width: 20,
            height: 20,
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

  // Auto-fill Field
  Widget _buildAutoFillField(String label, String iconPath, RxString value) {
    return Obx(
      () => Container(
        height: 75,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.orangeLight),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              AppAssetUtils.svg(
                iconPath,
                width: 32,
                height: 32,
                color: Colors.black,
              ),
              const SizedBox(width: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: AppColors.orangeLight,
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    value.value.isEmpty ? '-' : value.value,
                    style: TextStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    // Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    // TextFormField(
    //   enabled: false,
    //   decoration: InputDecoration(
    //     prefixIcon: Padding(
    //       padding: const EdgeInsets.all(12.0),
    //       child: AppAssetUtils.svg(
    //         iconPath,
    //         width: 20,
    //         height: 20,
    //         color: Colors.black,
    //       ),
    //     ),
    //     labelText: label,
    //     labelStyle: const TextStyle(color: Colors.orange),
    //     border: OutlineInputBorder(
    //       borderRadius: BorderRadius.circular(8),
    //       borderSide: const BorderSide(color: Colors.black54),
    //     ),
    //   ),
    // ),
    // const SizedBox(height: 6),
    // Text(
    //   value.value.isEmpty ? '-' : value.value,
    //   style: const TextStyle(
    //     fontSize: 14,
    //     color: Colors.black,
    //     fontWeight: FontWeight.w500,
    //   ),
    // ),
    // const SizedBox(height: 12),
    // ],
    // ));
  }

  // Dropdown
  Widget _buildDropdownField(String label, String iconPath) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          AppAssetUtils.svg(
            iconPath,
            width: 22,
            height: 22,
            color: Colors.black,
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              "Type of Activity",
              style: TextStyle(color: Colors.orange, fontSize: 16),
            ),
          ),
          const Icon(Icons.arrow_drop_down, color: Colors.black),
        ],
      ),
    );
  }
  
}
