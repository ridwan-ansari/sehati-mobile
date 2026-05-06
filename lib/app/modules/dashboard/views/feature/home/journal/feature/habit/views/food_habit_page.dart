// ignore_for_file: unnecessary_to_list_in_spreads, curly_braces_in_flow_control_structures, deprecated_member_use, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/localization/app_strings.dart';
import 'package:sehati/app/common/utils/time_utils.dart';
import 'package:sehati/app/data/models/response/habit_question_model.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/journal/widgets/custom_switch.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/journal/widgets/header_title.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/journal/widgets/journal_success_view.dart';
import '../controllers/food_habit_controller.dart';

class FoodHabitPage extends GetView<FoodHabitController> {
  const FoodHabitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator(color: AppColors.orangeLight));
          }

          if (controller.isSubmittedToday.value) {
            return Column(
              children: [
                _buildSimpleHeader(),
                Expanded(
                  child: JournalSuccessView(
                    title: AppStrings.get(AppStrings.habitKeyCompletedTitle),
                    message: AppStrings.get(AppStrings.habitKeyCompletedMsg),
                    onBack: () => Get.back(),
                  ),
                ),
              ],
            );
          }

          if (controller.groupedQuestions.isEmpty) {
            return const Center(child: Text("No questions available"));
          }

          final categories = controller.groupedQuestions.keys.toList();
          final totalSteps = categories.length;
          final currentStep = controller.currentPage.value;

          return Column(
            children: [
              _buildProgressHeader(currentStep, totalSteps),
              Expanded(
                child: PageView.builder(
                  controller: controller.pageController,
                  onPageChanged: controller.onPageChanged,
                  itemCount: totalSteps,
                  physics: const NeverScrollableScrollPhysics(), // Force navigation via buttons
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final questions = controller.groupedQuestions[category]!;
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: _buildCategoryCard(category, questions, index, totalSteps),
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildSimpleHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 24, 24),
      decoration: const BoxDecoration(
        color: AppColors.richBrown,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 48),
                child: Text(
                  AppStrings.get(AppStrings.habitKeyFoodHabit),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressHeader(int current, int total) {
    double progress = (current + 1) / total;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 24, 24),
      decoration: const BoxDecoration(
        color: AppColors.richBrown,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 48),
                    child: Text(
                      AppStrings.get(AppStrings.habitKeyFoodHabit),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.get(AppStrings.habitKeyDailyJournal),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
              ),
              Text(
                "${current + 1} / $total",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              color: const Color(0xFF4CAF50),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String title, List<HabitQuestionModel> questions, int index, int total) {
    return AnimatedIn(
      child: Obx(() {
        // ignore: unused_local_variable
        final _ = controller.questions.value;
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: questions.length,
                  itemBuilder: (context, qIndex) => _buildQuestionItem(questions[qIndex]),
                ),
              ),
              const SizedBox(height: 24),
              _buildNavigation(index, total, questions),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildNavigation(int index, int total, List<HabitQuestionModel> questionsInCategory) {
    final allAnsweredInCategory = questionsInCategory.every((q) => q.selectedOption != null);
    final isLastStep = index == total - 1;
    final allQuestionsAnswered = controller.questions.every((q) => q.selectedOption != null);

    return Row(
      children: [
        if (index > 0)
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: controller.previousPage,
              child: Text(AppStrings.get(AppStrings.commonKeyBack),
                  style: const TextStyle(color: AppColors.textMedium, fontWeight: FontWeight.w700)),
            ),
          ),
        if (index > 0) const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey.shade300,
              padding: const EdgeInsets.symmetric(vertical: 14),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: !allAnsweredInCategory
                ? null
                : (isLastStep
                    ? (allQuestionsAnswered ? controller.submitAllAnswers : null)
                    : controller.nextPage),
            child: Text(
              isLastStep ? AppStrings.get(AppStrings.habitKeySubmit) : AppStrings.get(AppStrings.commonKeyNext),
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionItem(HabitQuestionModel question) {
    final bool? currentValue = question.selectedOption == null ? null : question.selectedOption == "yes";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              question.question,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppColors.textDark,
              ),
            ),
          ),
          const SizedBox(width: 16),
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
        ],
      ),
    );
  }
}
