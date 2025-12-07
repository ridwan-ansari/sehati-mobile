// ignore_for_file: unnecessary_to_list_in_spreads, curly_braces_in_flow_control_structures, deprecated_member_use, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/utils/time_utils.dart';
import 'package:sehati/app/data/models/response/habit_question_model.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/journal/feature/food/widget/row_input_field.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/journal/widgets/custom_switch.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/journal/widgets/frequency_input_widget.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/journal/widgets/gradien_label.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/journal/widgets/header_title.dart';
import '../controllers/food_habit_controller.dart';

class FoodHabitPage extends GetView<FoodHabitController> {
  const FoodHabitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.gold,
        title: Text("Food Habit Journal"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12.0),
            AnimatedIn(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: AnimatedIn(
                  child: const Text(
                    "Welcome to Your Food Habit Journal!",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            AnimatedIn(child: HeaderTitleWidget(title: "Record Your Food Habit!")),
            const SizedBox(height: 8),
            AnimatedIn(
              child: RowInputField(
                isEditable: false,
                label: "Date",
                controller: controller.vegetableController,
                hintText: TimeUtils.formatShortDate(DateTime.now()),
              ),
            ),
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.groupedQuestions.isEmpty) {
                return Center(child: const Text("No questions asked"));
              }

              return ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: controller.groupedQuestions.entries.map((entry) {
                  final category = entry.key;
                  final questions = entry.value;

                  return AnimatedIn(
                    child: _buildSection(
                      title: category,
                      child: Obx(() {
                        final isExpanded =
                            controller.expandedCategories[category] ?? false;
                        final shownQuestions = isExpanded
                            ? questions
                            : questions.take(1).toList();
                    
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...shownQuestions
                                .map((q) => _buildQuestionsList(q))
                                .toList(),
                            if (questions.length > 1)
                              TextButton(
                                onPressed: () =>
                                    controller.toggleCategory(category),
                                child: Text(
                                  isExpanded ? "Show Less..." : "Click More...",
                                  style: const TextStyle(
                                    color: Colors.black38,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        );
                      }),
                    ),
                  );
                }).toList(),
              );
            }),
            const SizedBox(height: 12.0),
            Center(
              child: Obx(() {
                final totalSoal = controller.questions.length;
                final jawabanTerisi = controller.questions
                    .where((q) => q.selectedOption != null)
                    .length;
                final semuaTerisi = jawabanTerisi == totalSoal;
                if (controller.groupedQuestions.isEmpty)
                  return SizedBox.shrink();

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

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        HeaderTitleWidget(title: "Record Your Food Diary!"),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.gold,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GradientLabel(
                title: "Do you consume kind of $title listed below",
              ),
              Padding(padding: const EdgeInsets.all(10.0), child: child),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionsList(HabitQuestionModel question) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.questions.isEmpty) {
        return const Center(child: Text('Tidak ada pertanyaan'));
      }

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: question.selectedOption == 'yes' ? 3 : 4,
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
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            if (question.selectedOption == 'yes')
              Flexible(
                flex: 2,
                child: Row(
                  children: [
                    Flexible(
                      child: YesNoSwitch(
                        value: true,
                        onChanged: (val) {
                          controller.selectOption(
                            question,
                            val ? "yes" : "no",
                            val ? "yes" : "no",
                            val == 'yes' ? 1 : 0,
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: FrequencyInputWidget(
                        initialValue: question.frequency ?? 0,
                        onChanged: (value) {
                          question.frequency = value;
                          controller.questions.refresh();
                        },
                      ),
                    ),
                  ],
                ),
              )
            else
              Flexible(
                flex: 0,
                child: YesNoSwitch(
                  value: false,
                  onChanged: (val) {
                    controller.selectOption(
                      question,
                      val ? "yes" : "no",
                      val ? "yes" : "no",
                      val == 'true' ? 0 : 1,
                    );
                  },
                ),
              ),
          ],
        ),
      );
    });
  }
}
