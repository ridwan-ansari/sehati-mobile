import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/widgets/custom_appbar.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/journal/feature/food_diary/widget/row_input_field.dart';
import '../controllers/food_diary_controller.dart';

class FoodDiaryPage extends GetView<FoodDiaryController> {
  const FoodDiaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        logoSvg: AppAssets.dayliIcon,
        onSearchChanged: (value) {},
        onProfileTap: () {},
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // === HEADER ===
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                "Welcome to Your Food Diary Journal!",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 20),

            // === DATE FIELD ===
            RowInputField(
              label: "Date",
              controller: controller.dateController,
              readOnly: true,
              hintText: "Select Date",
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  controller.dateController.text = DateFormat(
                    'dd/MM/yyyy',
                  ).format(picked);
                }
              },
            ),

            const SizedBox(height: 16),

            // === FOOD DIARY SECTION ===
            _buildSection(
              title: "Record Your Food Diary!",
              actions: const Icon(Icons.menu, color: Colors.black),
              child: Column(
                children: [
                  _buildMealRow("Breakfast", "Instant Noodle (500 Kcal)"),
                  _buildMealRow("Lunch", "Fried Rice (800 Kcal)"),
                  _buildMealRow("Snack", "Ice Tea (200 Kcal)"),
                  _buildMealRow("Dinner", "Instant Noodle (500 Kcal)"),
                  const Divider(thickness: 1, color: Colors.black54),
                  _buildMealRow("Total Intake", "3050 Kcal", isTotal: true),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // === ANALYSIS SECTION ===
            _buildSection(
              title: "Analysis",
              actions: const Icon(Icons.menu, color: Colors.black),
              child: Column(
                children: [
                  _buildAnalysisRow(
                    "Energy Requirement (RDA)/Day",
                    "2000 Kcal",
                  ),
                  _buildAnalysisRow(
                    "Desired Energy Requirement/Day",
                    "1700 Kcal",
                  ),
                  _buildAnalysisRow("Actual Energy Intake", "3050 Kcal"),
                  const SizedBox(height: 16),
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.orange.shade300,
                        width: 2,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "📊 Bar Chart (Target vs Actual)",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // === Section Container ===
  Widget _buildSection({
    required String title,
    required Widget child,
    Widget? actions,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFE082), Color(0xFFFFB74D)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              if (actions != null) actions,
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.yellow.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: child,
          ),
        ],
      ),
    );
  }

  // === Food Row ===
  Widget _buildMealRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(width: 6),
              const Icon(Icons.add_circle, color: Colors.blue, size: 22),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isTotal ? Colors.orange.shade100 : Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.orange.shade300),
            ),
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black87,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // === Analysis Row ===
  Widget _buildAnalysisRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.orange.shade300),
            ),
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
