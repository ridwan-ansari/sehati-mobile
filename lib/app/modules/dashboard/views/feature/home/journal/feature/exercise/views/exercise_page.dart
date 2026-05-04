// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/localization/app_strings.dart';
import 'package:sehati/app/common/utils/dialog_utils.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/journal/widgets/boolean_question_widget.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/journal/widgets/multiple_choice_question_widget.dart';
import '../controllers/exercise_controller.dart';

class ExerciseView extends GetView<ExerciseController> {
  const ExerciseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.richBrown,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppStrings.get(AppStrings.menuKeyExerciseHabit),
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.orangeLight));
        }

        if (controller.exerciseList.isEmpty) {
          return Center(
            child: Text(AppStrings.get(AppStrings.exerciseKeyNoQuestions)),
          );
        }

        int totalSoal = controller.exerciseList.length;
        int jawabanTerisi = controller.exerciseList
            .where((q) => q.selectedOption != null || q.answerText != null)
            .length;

        PageController pageController = PageController();

        return WillPopScope(
          onWillPop: () async {
            bool? exit = await DialogUtils.showConfirmDialog(
              context: context,
              title: AppStrings.get(AppStrings.exerciseKeyConfirmExit),
              message: AppStrings.get(AppStrings.exerciseKeyExitMessage),
            );
            return exit ?? false;
          },
          child: Column(
            children: [
              _buildProgressHeader(jawabanTerisi, totalSoal),
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  itemCount: totalSoal,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final item = controller.exerciseList[index];
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: _buildQuestionCard(item, index, totalSoal, pageController),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProgressHeader(int filled, int total) {
    double progress = filled / total;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      decoration: const BoxDecoration(
        color: AppColors.richBrown,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.get(AppStrings.exerciseKeyDailyQuiz),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
              ),
              Text(
                "$filled / $total",
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
              color: const Color(0xFF2196F3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(dynamic item, int index, int total, PageController pageController) {
    return AnimatedIn(
      child: Container(
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: _getQuestionWidget(item, index, total, pageController),
        ),
      ),
    );
  }

  Widget _getQuestionWidget(dynamic item, int index, int total, PageController pageController) {
    switch (item.questionType) {
      case "multiple_choice":
        return MultipleChoiceQuestionWidget(
          question: item,
          index: index,
          totalSoal: total,
          pageController: pageController,
          controller: controller,
        );
      case "boolean":
        return BooleanQuestionWidget(
          question: item,
          index: index,
          totalSoal: total,
          pageController: pageController,
          controller: controller,
        );
      default:
        return Center(child: Text(AppStrings.get(AppStrings.exerciseKeyUnknownType)));
    }
  }
}
