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
        backgroundColor: AppColors.richBrown,
        foregroundColor: Colors.white,
        title: Text("Food Habit Journal"),
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
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

          const SizedBox(height: 16),
          HeaderTitleWidget(title: "Record Your Food Habit!"),

          const SizedBox(height: 8),
          RowInputField(
            isEditable: false,
            label: "Date",
            controller: controller.vegetableController,
            hintText: TimeUtils.formatShortDate(DateTime.now()),
          ),

          const SizedBox(height: 12),

          ...controller.groupedQuestions.entries.map((entry) {
            final category = entry.key;
            final questions = entry.value;

            return AnimatedIn(
              child: _buildSection(
                title: category,
                questions: questions,
              ),
            );
          }).toList(),

          const SizedBox(height: 12.0),
          _buildSubmitButton(),
          const SizedBox(height: 54.0),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<HabitQuestionModel> questions,
  }) {
    final isExpanded = controller.expandedCategories[title] ?? false;
    final shownQuestions = isExpanded ? questions : questions.take(1).toList();

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
            children: [
              GradientLabel(
                title: "Do you consume kind of $title listed below",
              ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    ...shownQuestions.map((q) => _buildQuestionItem(q)).toList(),

                    if (questions.length > 1)
                      TextButton(
                        onPressed: () => controller.toggleCategory(title),
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
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionItem(HabitQuestionModel question) {
    final bool? currentValue = question.selectedOption == null
        ? null
        : question.selectedOption == "yes";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: currentValue == true ? 3 : 4,
            child: Text(
              question.question,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),

          const SizedBox(width: 10),

          Flexible(
            flex:  1,
            child: Row(
              children: [
                YesNoSwitch(
                  value: currentValue,
                  onChanged: (val) {
                    controller.selectOption(
                      question,
                      val ? "yes" : "no",
                      val ? 1 : 0,
                    );
                  },
                ),

                // if (currentValue == true) ...[
                //   const SizedBox(width: 8),
                //   Expanded(
                //     child: FrequencyInputWidget(
                //       initialValue: question.frequency ?? 1,
                //       onChanged: (val) {
                //         question.frequency = val;
                //         controller.questions.refresh();
                //       },
                //     ),
                //   ),
                // ]
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    final total = controller.questions.length;
    final filled = controller.questions.where((q) => q.selectedOption != null).length;
    final enabled = total == filled;

    return Center(
      child: ElevatedButton.icon(
        onPressed: enabled ? controller.submitAllAnswers : null,
        icon: const Icon(Icons.check),
        label: const Text("Submit"),
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled ? AppColors.orangeLight : Colors.grey,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }
}
