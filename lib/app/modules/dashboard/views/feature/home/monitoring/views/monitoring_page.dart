import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/localization/app_strings.dart';
import 'package:sehati/app/common/widgets/custom_appbar.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/monitoring/widgets/monitoring_input_card.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/monitoring/widgets/monitoring_input_field.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/monitoring/widgets/monitoring_section_header.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/monitoring/widgets/bodyweight_chart.dart';
import '../controllers/monitoring_controller.dart';

class MonitoringPage extends GetView<MonitoringController> {
  const MonitoringPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      backgroundColor: AppColors.surface,
      appBar: CustomAppBar(
        logoSvg: AppAssets.monitoringIcon,
        title: AppStrings.get(AppStrings.menuKeyMonitoring),
        showBackButton: true,
      ),
      body: RefreshIndicator(
        onRefresh: controller.fetchInitial,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    MonitoringSectionHeader(
                      title: AppStrings.get(AppStrings.nutritionKeyBodyweightMonitoring),
                    ),
                    const SizedBox(height: 16),
                    MonitoringInputCard(
                      children: [
                        _buildRow(
                          label: AppStrings.get(AppStrings.nutritionKeyDateMeasurement),
                          input: _buildDateField(),
                        ),
                        _buildRow(
                          label: AppStrings.get(AppStrings.nutritionKeyHeight),
                          input: MonitoringInputField(
                            controller: controller.resultCmController,
                            hint: '0',
                          ),
                        ),
                        _buildRow(
                          label: AppStrings.get(AppStrings.nutritionKeyWeight),
                          input: MonitoringInputField(
                            controller: controller.resultController,
                            hint: '0',
                          ),
                        ),
                        const SizedBox(height: 16),
                        _calculateButton(onPressed: controller.submitNutrition),
                        Obx(() {
                          if (!controller.isCalculated.value) return const SizedBox.shrink();
                          return Column(
                            children: [
                              const SizedBox(height: 24),
                              _buildRow(
                                label: AppStrings.get(AppStrings.nutritionKeyBmi),
                                input: MonitoringInputField(
                                  isEdit: true,
                                  controller: controller.imtController,
                                  hint: AppStrings.get(AppStrings.commonKeyAutofill),
                                ),
                              ),
                              _buildRow(
                                label: 'BMI/Age Z-Score',
                                input: MonitoringInputField(
                                  isEdit: true,
                                  controller: controller.zScoreController,
                                  hint: AppStrings.get(AppStrings.commonKeyAutofill),
                                ),
                              ),
                              _buildRow(
                                label: AppStrings.get(AppStrings.nutritionKeyIdealWeight),
                                input: MonitoringInputField(
                                  isEdit: true,
                                  controller: controller.idealController,
                                  hint: AppStrings.get(AppStrings.commonKeyAutofill),
                                ),
                              ),
                            ],
                          );
                        }),
                        const SizedBox(height: 16),
                        Text(
                          AppStrings.get(AppStrings.nutritionKeyWeeklyReminder),
                          style: const TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Obx(() {
                      if (controller.errorMessage.isNotEmpty) {
                        return Center(child: Text(controller.errorMessage.value, style: const TextStyle(color: Colors.redAccent)));
                      }
                      if (controller.chartData.isEmpty) {
                        return Center(
                          child: Text(
                            AppStrings.get(AppStrings.nutritionKeyNoData),
                            style: const TextStyle(color: Colors.black45, fontWeight: FontWeight.w600),
                          ),
                        );
                      }
                      return BodyweightChart(data: controller.chartData);
                    }),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _buildRow({required String label, required Widget input}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textDark),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(flex: 2, child: input),
      ],
    ),
  );

  Widget _calculateButton({required VoidCallback? onPressed}) => SizedBox(
    width: double.infinity,
    height: 50,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.orangeLight,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        AppStrings.get(AppStrings.nutritionKeyCalculate),
        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
      ),
    ),
  );

  Widget _buildDateField() {
    return GestureDetector(
      onTap: controller.selectDate,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.orangeLight.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Obx(
          () => Center(
            child: Text(
              controller.selectedDate.value.isEmpty
                  ? AppStrings.get(AppStrings.nutritionKeySelectDate)
                  : controller.selectedDate.value,
              style: const TextStyle(color: AppColors.orangeLight, fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
    );
  }
}
