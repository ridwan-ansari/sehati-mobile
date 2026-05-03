import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/localization/app_strings.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:sehati/app/common/utils/rx_extensions.dart';
import 'package:sehati/app/common/widgets/app_button.dart';
import 'package:sehati/app/data/services/language_service.dart';
import 'package:sehati/app/modules/auth/controllers/auth_controller.dart';

class NutritionalStatusPage extends GetView<AuthController> {
  const NutritionalStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      Get.find<LanguageService>().currentLanguage.value;

      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),

                // Header
                Text(
                  AppStrings.get(AppStrings.nutritionKeyPageTitle),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    height: 1.2,
                  ),
                ),

                const SizedBox(height: 40),

                // Weight input
                _buildTextField(
                  AppStrings.get(AppStrings.nutritionKeyWeight),
                  AppAssets.bodyWeightIcon,
                  controller.weightController,
                ),
                const SizedBox(height: 16),

                // Height input
                _buildTextField(
                  AppStrings.get(AppStrings.nutritionKeyHeight),
                  AppAssets.bodyHeightIcon,
                  controller.heightController,
                ),
                const SizedBox(height: 24),

                // Calculate button — hidden once results are available
                Obx(() {
                  if (controller.isNutritionSaved.value) return const SizedBox.shrink();
                  return AppButton(
                    text: AppStrings.get(AppStrings.nutritionKeyCalculate),
                    isLoading: controller.isLoading.value,
                    onPressed: controller.isLoading.value
                        ? null
                        : () => controller.submitNutrition(),
                  );
                }),

                // Result section — only visible after backend responds
                Obx(() {
                  final saved = controller.isNutritionSaved.value;
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: saved
                        ? Column(
                            key: const ValueKey('results'),
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildResultCard(
                                AppStrings.get(AppStrings.nutritionKeyBmi),
                                AppAssets.bmiIcon,
                                controller.bmi.stringObs,
                              ),
                              const SizedBox(height: 16),
                              _buildResultCard(
                                AppStrings.get(AppStrings.nutritionKeyNutritionalStatus),
                                AppAssets.bmiIcon,
                                controller.status,
                              ),
                              const SizedBox(height: 16),
                              _buildResultCard(
                                AppStrings.get(AppStrings.nutritionKeyIdealWeight),
                                AppAssets.bodyHeightIcon,
                                controller.idealWeight.stringObs,
                              ),
                              const SizedBox(height: 24),
                              AppButton(
                                text: AppStrings.get(AppStrings.nutritionKeyFinish),
                                onPressed: () => Get.offAllNamed('/dashboard'),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(key: ValueKey('empty')),
                  );
                }),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildTextField(
    String label,
    String iconPath,
    TextEditingController textController,
  ) {
    return TextFormField(
      controller: textController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
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

  Widget _buildResultCard(String label, String iconPath, RxString value) {
    return Obx(
      () => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.orangeLight),
        ),
        child: Row(
          children: [
            AppAssetUtils.svg(
              iconPath,
              width: 28,
              height: 28,
              color: Colors.black54,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: AppColors.orangeLight,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value.value.isEmpty ? '-' : value.value,
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
