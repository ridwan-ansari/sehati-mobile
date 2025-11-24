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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

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

              // WEIGHT
              _buildTextField(
                "Current Bodyweight",
                AppAssets.bodyWeightIcon,
                controller.weightController,
              ),
              const SizedBox(height: 16),

              // HEIGHT
              _buildTextField(
                "Current Bodyheight",
                AppAssets.bodyHeightIcon,
                controller.heightController,
              ),
              const SizedBox(height: 16),

              // === SAVE BUTTON (AMAN) ===
              Obx(() {
                final disable = controller.bmi.value != 0.0;

                return disable
                    ? const SizedBox()
                    : AppButton(
                        text: "Calculate",
                        onPressed: () => controller.submitNutrition(),
                      );
              }),

              const SizedBox(height: 16),

              // AUTO-FILL FIELDS
              Obx(
                () => _buildAutoFillField(
                  "BMI",
                  AppAssets.bmiIcon,
                  controller.bmi.stringObs,
                ),
              ),
              const SizedBox(height: 16),

              _buildAutoFillField(
                "Nutritional Status",
                AppAssets.bmiIcon,
                controller.status,
              ),
              const SizedBox(height: 16),

              Obx(
                () => _buildAutoFillField(
                  "Ideal Bodyweight",
                  AppAssets.bodyHeightIcon,
                  controller.idealWeight.stringObs,
                ),
              ),
              const SizedBox(height: 16),

              // FINISH BUTTON
              Obx(() {
                return controller.isNutritionSaved.value
                    ? AppButton(
                        text: "Finish",
                        onPressed: () => Get.offAllNamed('/dashboard'),
                      )
                    : const SizedBox();
              }),
            ],
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
  }
}
