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
      appBar: AppBar(backgroundColor: AppColors.gold, title: Text("Sleep")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.black,
              child: AnimatedIn(
                child: const Text(
                  "Welcome to your self-monitoring page!",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            _buildBodyweightMonitoring(),
          ],
        ),
      ),
    );
  }

  // ===== Bodyweight Monitoring =====
  Widget _buildBodyweightMonitoring() {
    return RefreshIndicator(
      onRefresh: () => controller.fetchInitial(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            MonitoringSectionHeader(
              title: "Welcome to your sleep habit journal",
            ),
            const SizedBox(height: 16),
            MonitoringInputCard(
              children: [
                _buildRow(
                  label: "Date of measurement",
                  input: _buildDateField(),
                  subtitle: "Record your sleep time from yesterday",
                ),
                _buildRow(
                  label: "Sleep time",
                  input: _buildTimeField(controller.sleepTime),
                ),
                _buildRow(
                  label: "Wake up time",
                  input: _buildTimeField(controller.wakeUpTime),
                ),
                _buildRow(
                  label: "Sleep Duration",
                  input: MonitoringInputField(
                    isEdit: true,
                    controller: controller.durationSleepController,
                    hint: "Autofill",
                  ),
                ),
                _buildRow(
                  label: "Target Sleep Duration/day",
                  input: MonitoringInputField(
                    controller: controller.targetSleepController,
                    hint: 'Hours',
                    // keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(height: 16.0),
                _saveButton(onPressed: controller.submitSleep),

                const SizedBox(height: 8.0),
                Text(
                  "Maintain your ideal sleep duration at 8 hours per day",
                  style: TextStyle(fontSize: 12.0, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Obx(() {
              if (controller.chartData.isEmpty) {
                return AnimatedIn(child: const Text("No data yet."));
              }
              return SleepChart(data: controller.chartData);
            }),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildRow({
    required String label,
    required Widget input,
    String? subtitle,
  }) => Padding(
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
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
              ),
              AnimatedIn(
                child: Text(
                  subtitle ?? "",
                  style: TextStyle(
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

  Widget _saveButton({required void Function()? onPressed}) => SizedBox(
    width: double.infinity,
    child: ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.calculate, color: AppColors.orangeLight, size: 24),
      label: AnimatedIn(
        child: const Text(
          "Calculate",
          style: TextStyle(
            color: AppColors.orangeLight,
            fontWeight: FontWeight.bold,
          ),
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
      onTap: () => controller.selectDate(),
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
                    ? "Date of Measurement"
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
                  ? "Select Time"
                  : "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}",
              style: const TextStyle(color: Colors.orange, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          );
        }),
      ),
    );
  }
}
