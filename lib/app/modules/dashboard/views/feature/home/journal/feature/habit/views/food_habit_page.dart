// ignore_for_file: unnecessary_to_list_in_spreads, curly_braces_in_flow_control_structures, deprecated_member_use, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/localization/app_strings.dart';
import 'package:sehati/app/common/widgets/simple_text_appbar.dart';
import 'package:sehati/app/common/utils/time_utils.dart';
import 'package:sehati/app/data/models/response/habit_question_model.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/journal/widgets/custom_switch.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/journal/widgets/header_title.dart';
import '../controllers/food_habit_controller.dart';

class FoodHabitPage extends GetView<FoodHabitController> {
  const FoodHabitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Obx(
          () => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator(color: AppColors.orangeLight))
              : _buildBody(context),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeHeader(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDateField(),
                const SizedBox(height: 24),
                HeaderTitleWidget(title: AppStrings.getOr("Habit Questionnaire", "Kuesioner Kebiasaan")),
                const SizedBox(height: 16),
                ...controller.groupedQuestions.entries.map((entry) {
                  return _buildCategorySection(entry.key, entry.value);
                }).toList(),
                const SizedBox(height: 32),
                _buildSubmitButton(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 24, 24),
      decoration: const BoxDecoration(
        color: AppColors.richBrown,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: AnimatedIn(
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
                      padding: const EdgeInsets.only(right: 48), // Balancing IconButton width
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
            Text(
              AppStrings.get(AppStrings.habitKeyDailyJournal),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              AppStrings.get(AppStrings.habitKeyConsistency),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.calendar_today_rounded, color: Color(0xFF4CAF50), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.get(AppStrings.foodKeyJournalDate),
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w600),
                ),
                Text(
                  TimeUtils.formatShortDate(DateTime.now()),
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(String title, List<HabitQuestionModel> questions) {
    return Obx(() {
      final isExpanded = controller.expandedCategories[title] ?? false;
      final shownQuestions = isExpanded ? questions : questions.take(1).toList();

      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  ...shownQuestions.map((q) => _buildQuestionItem(q)).toList(),
                  if (questions.length > 1)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: TextButton(
                        onPressed: () => controller.toggleCategory(title),
                        child: Text(
                          isExpanded ? AppStrings.get(AppStrings.habitKeyShowLess) : "${AppStrings.get(AppStrings.foodKeyViewAll)} ${questions.length - 1} ${AppStrings.get(AppStrings.habitKeyViewMore)}",
                          style: const TextStyle(
                            color: Color(0xFF4CAF50),
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildQuestionItem(HabitQuestionModel question) {
    final bool? currentValue = question.selectedOption == null
        ? null
        : question.selectedOption == "yes";

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

  Widget _buildSubmitButton() {
    final total = controller.questions.length;
    final filled = controller.questions.where((q) => q.selectedOption != null).length;
    final enabled = total == filled;

    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: enabled ? controller.submitAllAnswers : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4CAF50),
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.shade300,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Text(
          enabled ? AppStrings.get(AppStrings.habitKeySubmit) : "${AppStrings.get(AppStrings.habitKeyCompleteAll)} ($filled/$total)",
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
        ),
      ),
    );
  }
}
