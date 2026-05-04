import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/localization/app_strings.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/monitoring/widgets/monitoring_input_card.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/monitoring/widgets/monitoring_input_field.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/monitoring/widgets/monitoring_section_header.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/sleep/controller/sleep_controller.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/sleep/widget/sleep_chart.dart';

class SleepPage extends GetView<SleepController> {
  const SleepPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.richBrown,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppStrings.get(AppStrings.menuKeySleep),
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
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
                      title: AppStrings.getOr('Sleep Habit Journal', 'Jurnal Kebiasaan Tidur'),
                    ),
                    const SizedBox(height: 16),
                    MonitoringInputCard(
                      children: [
                        _buildRow(
                          label: AppStrings.get(AppStrings.nutritionKeyDateMeasurement),
                          input: _buildDateField(),
                        ),
                        _buildRow(
                          label: AppStrings.getOr('Sleep time', 'Waktu tidur'),
                          input: _buildTimeField(controller.sleepTime),
                        ),
                        _buildRow(
                          label: AppStrings.getOr('Wake-up time', 'Waktu bangun'),
                          input: _buildTimeField(controller.wakeUpTime),
                        ),
                        _buildRow(
                          label: AppStrings.getOr('Sleep duration', 'Durasi tidur'),
                          input: MonitoringInputField(
                            isEdit: true,
                            controller: controller.durationSleepController,
                            hint: 'Autofill',
                          ),
                        ),
                        _buildRow(
                          label: AppStrings.get(AppStrings.sleepKeyTarget),
                          input: MonitoringInputField(
                            controller: controller.targetSleepController,
                            hint: AppStrings.get(AppStrings.sleepKeyHours),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _saveButton(onPressed: controller.submitSleep),
                        const SizedBox(height: 8),
                        Text(
                          AppStrings.getOr('Aim for 8 hours of sleep per day.', 'Targetkan tidur 8 jam setiap hari.'),
                          style: const TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Obx(() {
                      if (controller.chartData.isEmpty) {
                        return Center(
                          child: Text(
                            AppStrings.get(AppStrings.sleepKeyNoData),
                            style: const TextStyle(color: Colors.black45, fontWeight: FontWeight.w600),
                          ),
                        );
                      }
                      return SleepChart(data: controller.chartData);
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

  Widget _buildRow({
    required String label,
    required Widget input,
  }) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: AppColors.textDark,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(flex: 2, child: input),
          ],
        ),
      );

  Widget _saveButton({required VoidCallback? onPressed}) => SizedBox(
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
        AppStrings.get(AppStrings.commonKeySave),
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

  Widget _buildTimeField(Rx<TimeOfDay?> timeRx) {
    return GestureDetector(
      onTap: () async {
        final picked = await showTimePicker(
          context: Get.context!,
          initialTime: timeRx.value ?? TimeOfDay.now(),
        );

        if (picked != null) {
          timeRx.value = picked;
          controller.calculateDuration();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.orangeLight.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Obx(() {
          final time = timeRx.value;
          return Center(
            child: Text(
              time == null
                  ? AppStrings.getOr('Select Time', 'Pilih Waktu')
                  : '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(color: AppColors.orangeLight, fontSize: 14, fontWeight: FontWeight.w700),
            ),
          );
        }),
      ),
    );
  }
}
