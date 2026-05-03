import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/widgets/app_error_widget.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/monitoring/widgets/bodyweight_chart.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/monitoring/widgets/monitoring_input_card.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/monitoring/widgets/monitoring_input_field.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/monitoring/widgets/monitoring_section_header.dart';

import '../controllers/monitoring_controller.dart';

class MonitoringPage extends GetView<MonitoringController> {
  const MonitoringPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.richBrown,
        foregroundColor: Colors.white,
        title: const Text('Self Monitoring'),
      ),
      body: RefreshIndicator(
        onRefresh: controller.fetchInitial,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: AnimatedIn(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.richBrown,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Welcome to your self-monitoring page!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    MonitoringSectionHeader(title: 'Bodyweight Monitoring'),
                    const SizedBox(height: 16),
                    MonitoringInputCard(
                      children: [
                        AnimatedIn(child: _buildRow('Date of measurement', _buildDateField())),
                        AnimatedIn(
                          child: _buildRow(
                            'Body height (cm)',
                            MonitoringInputField(
                              controller: controller.resultCmController,
                              hint: '0',
                            ),
                          ),
                        ),
                        AnimatedIn(
                          child: _buildRow(
                            'Body weight (kg)',
                            MonitoringInputField(
                              controller: controller.resultController,
                              hint: '0',
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        AnimatedIn(child: _saveButton(onPressed: controller.submitNutrition)),
                        const SizedBox(height: 16),
                        AnimatedIn(
                          child: _buildRow(
                            'BMI (kg/m²)',
                            MonitoringInputField(
                              isEdit: true,
                              controller: controller.imtController,
                              hint: 'Autofill',
                            ),
                          ),
                        ),
                        AnimatedIn(
                          child: _buildRow(
                            'BMI/Age Z-Score',
                            MonitoringInputField(
                              isEdit: true,
                              controller: controller.zScoreController,
                              hint: 'Autofill',
                            ),
                          ),
                        ),
                        AnimatedIn(
                          child: _buildRow(
                            'Ideal Bodyweight (kg)',
                            MonitoringInputField(
                              isEdit: true,
                              controller: controller.idealController,
                              hint: 'Autofill',
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Record your body weight at least once a week!',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Obx(() {
                      if (controller.errorMessage.isNotEmpty) {
                        return AppErrorWidget(
                          message: controller.errorMessage.value,
                          onRetry: controller.fetchInitial,
                        );
                      }
                      if (controller.isLoadingMore.value &&
                          controller.chartData.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(24),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.orangeLight,
                            ),
                          ),
                        );
                      }
                      if (controller.chartData.isEmpty) {
                        return const Text(
                          'No data yet. Start tracking above!',
                          style: TextStyle(color: Colors.black54, fontSize: 13),
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
    );
  }

  Widget _buildRow(String label, Widget input) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(flex: 2, child: Text(label)),
        const SizedBox(width: 10),
        Expanded(flex: 2, child: input),
      ],
    ),
  );

  Widget _saveButton({required VoidCallback? onPressed}) => SizedBox(
    width: double.infinity,
    child: ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.calculate, color: AppColors.orangeLight, size: 24),
      label: const Text(
        'Calculate',
        style: TextStyle(color: AppColors.orangeLight, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
  );

  Widget _buildDateField() {
    return GestureDetector(
      onTap: controller.selectDate,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.orangeLight),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Obx(
          () => Center(
            child: Text(
              controller.selectedDate.value.isEmpty
                  ? 'Select Date'
                  : controller.selectedDate.value,
              style: const TextStyle(color: Colors.orange, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
