import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/journal/feature/food_diary/widget/row_input_field.dart';
import '../controllers/food_habit_controller.dart';

class FoodHabitPage extends GetView<FoodHabitController> {
  const FoodHabitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            _buildSection(
              title: "Eating Behavior",
              child: _buildQuestionsList(),
            ),

            const SizedBox(height: 16),

            Center(
              child: Obx(() {
                final totalSoal = controller.questions.length;
                final jawabanTerisi = controller.questions
                    .where((q) => q.selectedOption != null)
                    .length;
                final semuaTerisi = jawabanTerisi == totalSoal;

                return ElevatedButton.icon(
                  onPressed: semuaTerisi
                      ? () {
                         controller.submitAllAnswers(); 
                        }
                      : null,
                  icon: const Icon(Icons.check),
                  label: const Text("Submit"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: semuaTerisi
                        ? AppColors.orangeLight
                        : Colors.grey,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                );
              }),
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

  Widget _buildQuestionsList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.questions.isEmpty) {
        return const Center(child: Text('Tidak ada pertanyaan'));
      }

      return Column(
        children: controller.questions.map((question) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question.question,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Reward: ${question.rewardPoints} coins',
                  style: const TextStyle(fontSize: 12, color: Colors.orange),
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        activeColor: AppColors.orangeLight,
                        title: const Text("Yes"),
                        value: "Yes",
                        groupValue: question.selectedOption,
                        onChanged: (val) {
                          controller.selectOption(question, val!, val);
                        },
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        activeColor: AppColors.orangeLight,
                        title: const Text("No"),
                        value: "No",
                        groupValue: question.selectedOption,
                        onChanged: (val) {
                          controller.selectOption(question, val!, val);
                        },
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
                Divider(),
              ],
            ),
          );
        }).toList(),
      );
    });
  }
}
