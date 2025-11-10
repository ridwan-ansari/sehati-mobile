import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/widgets/custom_appbar.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/monitoring/widgets/bodyweight_chart.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/monitoring/widgets/monitoring_input_card.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/monitoring/widgets/monitoring_input_field.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/monitoring/widgets/monitoring_section_header.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/monitoring/widgets/stepcount_chart.dart';
import '../controllers/monitoring_controller.dart';

class MonitoringPage extends GetView<MonitoringController> {
  const MonitoringPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        logoSvg: AppAssets.monitoringIcon,
        onSearchChanged: (value) {},
        onProfileTap: () {},
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.brown.shade700,
            child: const Text(
              "Welcome to your self–monitoring page!",
              style: TextStyle(color: Colors.white, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: controller.tabController,
              indicator: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF80AB), Color(0xFFFFC107)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: "Bodyweight"),
                Tab(text: "Step Count"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: [
                _buildBodyweightMonitoring(),
                _buildStepCountMonitoring(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===== Bodyweight Monitoring =====
  Widget _buildBodyweightMonitoring() {
    final data = [
      {"date": "05/06", "actual": 70.0, "ideal": 60.0},
      {"date": "06/06", "actual": 68.5, "ideal": 60.0},
      {"date": "07/06", "actual": 67.0, "ideal": 60.0},
      {"date": "08/06", "actual": 66.0, "ideal": 60.0},
      {"date": "09/06", "actual": 65.0, "ideal": 60.0},
      {"date": "10/06", "actual": 64.0, "ideal": 60.0},
      {"date": "11/06", "actual": 63.0, "ideal": 60.0},
      {"date": "12/06", "actual": 62.0, "ideal": 60.0},
    ];

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
                "Result (kg)",
                MonitoringInputField(
                  controller: controller.resultController,
                  hint: "55",
                ),
              ),
              _buildRow(
                "IMT (kg/m²)",
                MonitoringInputField(
                  controller: controller.imtController,
                  hint: "Autofill",
                ),
              ),
              _buildRow(
                "IMT/U Z-Score",
                MonitoringInputField(
                  controller: controller.zScoreController,
                  hint: "Autofill",
                ),
              ),
              _buildRow(
                "Ideal Bodyweight (kg)",
                MonitoringInputField(
                  controller: controller.idealController,
                  hint: "Autofill",
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _saveButton(),
          const SizedBox(height: 20),
          BodyweightChart(data: data),
        ],
      ),
    );
  }

  // ===== Step Count Monitoring =====
  Widget _buildStepCountMonitoring() {
    final data = List.generate(20, (i) {
      return {
        "date": "${(i + 1).toString().padLeft(2, '0')}/06/25",
        "actual": 3000 + (i * 200),
        "target": 6000 + ((i % 3) * 500),
      };
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          MonitoringSectionHeader(title: "Step Count Monitoring"),
          const SizedBox(height: 16),
          MonitoringInputCard(
            children: [
              _buildRow(
                "Date of measurement",
                MonitoringInputField(
                  controller: TextEditingController(),
                  hint: "Autorecord",
                ),
              ),
              _buildRow(
                "Actual step counts",
                MonitoringInputField(
                  controller: TextEditingController(),
                  hint: "Autorecord",
                ),
              ),
              _buildRow(
                "Your target daily steps",
                MonitoringInputField(
                  controller: TextEditingController(),
                  hint: "6000",
                ),
              ),
              _buildRow(
                "You need more",
                MonitoringInputField(
                  controller: TextEditingController(),
                  hint: "Autofill",
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _saveButton(),
          const SizedBox(height: 20),
          StepCountChart(data: data),
        ],
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

  Widget _saveButton() => SizedBox(
    width: double.infinity,
    child: ElevatedButton.icon(
      onPressed: () => Get.snackbar(
        "Success",
        "Monitoring data saved successfully!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      ),
      icon: const Icon(Icons.save),
      label: const Text("Save / Submit"),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange.shade400,
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
