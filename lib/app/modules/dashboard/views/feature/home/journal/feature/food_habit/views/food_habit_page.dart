import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/widgets/custom_appbar.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/journal/feature/food_diary/widget/row_input_field.dart';
import '../controllers/food_habit_controller.dart';

class FoodHabitPage extends GetView<FoodHabitController> {
  const FoodHabitPage({super.key});

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== HEADER =====
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                "Welcome to Your Food Habit Journal!",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 20),

            // ===== SECTION 1: DAILY EATING HABIT =====
            _buildSection(
              title: "Daily Eating Habit",
              child: Column(
                children: [
                  RowInputField(
                    label: "Meal Frequency / Day",
                    controller: controller.frequencyController,
                    hintText: "e.g. 3 times/day",
                  ),
                  const SizedBox(height: 4.0),
                  RowInputField(
                    label: "Fast Food Frequency / Week",
                    controller: controller.fastFoodController,
                    hintText: "e.g. 2 times/week",
                  ),
                  const SizedBox(height: 4.0),
                  RowInputField(
                    label: "Fruit Intake / Day",
                    controller: controller.fruitController,
                    hintText: "e.g. 1 portion",
                  ),
                  const SizedBox(height: 4.0),
                  RowInputField(
                    label: "Vegetable Intake / Day",
                    controller: controller.vegetableController,
                    hintText: "e.g. 2 portions",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ===== SECTION 2: EATING BEHAVIOR =====
            _buildSection(
              title: "Eating Behavior",
              child: Column(
                children: [
                  _buildRadioGroup("Eat while watching TV?"),
                  _buildRadioGroup("Eat late at night?"),
                  _buildRadioGroup("Skip breakfast?"),
                  _buildRadioGroup("Consume sugary drinks daily?"),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ===== SUBMIT BUTTON =====
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.snackbar(
                    "Saved",
                    "Your food habit data has been recorded!",
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.TOP,
                  );
                },
                icon: const Icon(Icons.save),
                label: const Text("Save Habit Record"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 54.0),
          ],
        ),
      ),
    );
  }

  // ===== Reusable Section Wrapper =====
  Widget _buildSection({required String title, required Widget child}) {
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
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.yellow.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: child,
          ),
        ],
      ),
    );
  }

  // ===== Reusable Radio Group =====
  Widget _buildRadioGroup(String question) {
    final RxString selected = "".obs;

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: RadioListTile<String>(
                  title: const Text("Yes"),
                  value: "Yes",
                  groupValue: selected.value,
                  onChanged: (val) => selected.value = val!,
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  title: const Text("No"),
                  value: "No",
                  groupValue: selected.value,
                  onChanged: (val) => selected.value = val!,
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
