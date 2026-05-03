import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/monitoring/widgets/monitoring_input_card.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/monitoring/widgets/monitoring_input_field.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/monitoring/widgets/monitoring_section_header.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/sleep/controller/sleep_controller.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/sleep/widget/sleep_chart.dart';

class SleepPage extends GetView<SleepController> {
  const SleepPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.richBrown,
        foregroundColor: Colors.white,
        title: const Text('Sleep Tracker'),
      ),
      body: RefreshIndicator(
        onRefresh: controller.fetchInitial,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: Colors.black,
                child: const AnimatedIn(
                  child: Text(
                    'Welcome to your sleep journal!',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    MonitoringSectionHeader(
                      title: 'Sleep Habit Journal',
                    ),
                    const SizedBox(height: 16),
                    MonitoringInputCard(
                      children: [
                        _buildRow(
                          label: 'Date of measurement',
                          input: _buildDateField(),
                          subtitle: 'Record your sleep time from yesterday',
                        ),
                        _buildRow(
                          label: 'Sleep time',
                          input: _buildTimeField(controller.sleepTime),
                        ),
                        _buildRow(
                          label: 'Wake-up time',
                          input: _buildTimeField(controller.wakeUpTime),
                        ),
                        _buildRow(
                          label: 'Sleep duration',
                          input: MonitoringInputField(
                            isEdit: true,
                            controller: controller.durationSleepController,
                            hint: 'Autofill',
                          ),
                        ),
                        _buildRow(
                          label: 'Target duration / day',
                          input: MonitoringInputField(
                            controller: controller.targetSleepController,
                            hint: 'Hours',
                          ),
                        ),
                        const SizedBox(height: 16),
                        _saveButton(onPressed: controller.submitSleep),
                        const SizedBox(height: 8),
                        const Text(
                          'Aim for 8 hours of sleep per day.',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Obx(() {
                      if (controller.chartData.isEmpty) {
                        return const AnimatedIn(child: Text('No data yet.'));
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
    );
  }

  Widget _buildRow({
    required String label,
    required Widget input,
    String? subtitle,
  }) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedIn(
                    child: Text(
                      label,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  if (subtitle != null)
                    AnimatedIn(
                      child: Text(
                        subtitle,
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(flex: 2, child: input),
          ],
        ),
      );

  Widget _saveButton({required VoidCallback? onPressed}) => SizedBox(
    width: double.infinity,
    child: ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.save_alt, color: AppColors.orangeLight, size: 24),
      label: const Text(
        'Save',
        style: TextStyle(
          color: AppColors.orangeLight,
          fontWeight: FontWeight.bold,
        ),
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
            child: AnimatedIn(
              child: Text(
                controller.selectedDate.value.isEmpty
                    ? 'Select Date'
                    : controller.selectedDate.value,
                style: const TextStyle(color: Colors.orange, fontSize: 16),
              ),
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.orangeLight),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Obx(() {
          final time = timeRx.value;
          return AnimatedIn(
            child: Text(
              time == null
                  ? 'Select Time'
                  : '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(color: Colors.orange, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          );
        }),
      ),
    );
  }
}
