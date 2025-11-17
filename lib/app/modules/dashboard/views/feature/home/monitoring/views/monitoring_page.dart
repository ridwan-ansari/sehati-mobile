import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
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
        backgroundColor: AppColors.gold,
        title: Text("Self Monitoring"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.black,
              child: const Text(
                "Welcome to your self–monitoring page!",
                style: TextStyle(color: Colors.white, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
            // Container(
            //   margin: const EdgeInsets.all(12),
            //   decoration: BoxDecoration(
            //     color: Colors.amber.shade100,
            //     borderRadius: BorderRadius.circular(12),
            //   ),
            //   child: TabBar(
            //     controller: controller.tabController,
            //     indicator: BoxDecoration(
            //       gradient: const LinearGradient(
            //         colors: [Color(0xFFFF80AB), Color(0xFFFFC107)],
            //       ),
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //     labelColor: Colors.black,
            //     unselectedLabelColor: Colors.grey,
            //     tabs: const [
            //       Tab(text: "Bodyweight"),
            //       Tab(text: "Step Count"),
            //     ],
            //   ),
            // ),
            // Expanded(
            //   child: TabBarView(
            //     controller: controller.tabController,
            //     children: [
            //       _buildStepCountMonitoring(),
            //     ],
            //   ),
            // ),
            _buildBodyweightMonitoring(),
          ],
        ),
      ),
    );
  }

  // ===== Bodyweight Monitoring =====
  Widget _buildBodyweightMonitoring() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          MonitoringSectionHeader(title: "Bodyweight Monitoring"),
          const SizedBox(height: 16),
          MonitoringInputCard(
            children: [
              _buildRow("Date of measurement", _buildDateField()),
              _buildRow(
                "Result (cm)",
                MonitoringInputField(
                  controller: controller.resultCmController,
                  hint: '0',
                ),
              ),
              _buildRow(
                "Result (kg)",
                MonitoringInputField(
                  controller: controller.resultController,
                  hint: '0',
                ),
              ),

              const SizedBox(height: 16.0),
              _saveButton(onPressed: controller.submitNutrition),
              const SizedBox(height: 16.0),
              _buildRow(
                "IMT (kg/m²)",
                MonitoringInputField(
                  isEdit: true,
                  controller: controller.imtController,
                  hint: "Autofill",
                ),
              ),
              _buildRow(
                "IMT/U Z-Score",
                MonitoringInputField(
                  isEdit: true,
                  controller: controller.zScoreController,
                  hint: "Autofill",
                ),
              ),
              _buildRow(
                "Ideal Bodyweight (kg)",
                MonitoringInputField(
                  isEdit: true,
                  controller: controller.idealController,
                  hint: "Autofill",
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                "Record your body weight at least once a week!",
                style: TextStyle(fontSize: 12.0, color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          Obx(() {
            if (controller.chartData.isEmpty) {
              return const Text("No data yet.");
            }
            return BodyweightChart(data: controller.chartData);
          }),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ===== Step Count Monitoring =====
  // Widget _buildStepCountMonitoring() {
  //   final data = List.generate(20, (i) {
  //     return {
  //       "date": "${(i + 1).toString().padLeft(2, '0')}/06/25",
  //       "actual": 3000 + (i * 200),
  //       "target": 6000 + ((i % 3) * 500),
  //     };
  //   });

  //   return SingleChildScrollView(
  //     padding: const EdgeInsets.all(16),
  //     child: Column(
  //       children: [
  //         MonitoringSectionHeader(title: "Step Count Monitoring"),
  //         const SizedBox(height: 16),
  //         MonitoringInputCard(
  //           children: [
  //             _buildRow(
  //               "Date of measurement",
  //               MonitoringInputField(
  //                 controller: TextEditingController(),
  //                 hint: "Autorecord",
  //               ),
  //             ),
  //             _buildRow(
  //               "Actual step counts",
  //               MonitoringInputField(
  //                 isEdit: true,
  //                 controller: TextEditingController(),
  //                 hint: "Autorecord",
  //               ),
  //             ),
  //             _buildRow(
  //               "Your target daily steps",
  //               MonitoringInputField(
  //                 isEdit: true,
  //                 controller: TextEditingController(),
  //                 hint: "6000",
  //               ),
  //             ),
  //             _buildRow(
  //               "You need more",
  //               MonitoringInputField(
  //                 isEdit: true,
  //                 controller: TextEditingController(),
  //                 hint: "Autofill",
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 20),
  //         StepCountChart(data: data),
  //       ],
  //     ),
  //   );
  // }

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

  Widget _saveButton({required void Function()? onPressed}) => SizedBox(
    width: double.infinity,
    child: ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.calculate, color: AppColors.orangeLight, size: 24),
      label: const Text(
        "Calculate",
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
            child: Text(
              controller.selectedDate.value.isEmpty
                  ? "Date of Measurement"
                  : controller.selectedDate.value,
              style: const TextStyle(color: Colors.orange, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
