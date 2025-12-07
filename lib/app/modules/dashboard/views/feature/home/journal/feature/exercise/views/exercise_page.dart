// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/utils/dialog_utils.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/journal/widgets/boolean_question_widget.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/journal/widgets/multiple_choice_question_widget.dart';
import '../controllers/exercise_controller.dart';

class ExerciseView extends GetView<ExerciseController> {
  const ExerciseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.gold,
        title: Text("Exercise Diary Journal"),
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.exerciseList.isEmpty) {
          return const Center(child: Text('Tidak ada data'));
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
              title: "Confirm",
              message:
                  "By exiting, all filled answers will be lost. Are you sure you want to exit?",
            );
            return exit;
          },
          child: SafeArea(
            child: Column(
              children: [
                // Header Progress
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: jawabanTerisi / totalSoal,
                          minHeight: 8,
                          backgroundColor: Colors.grey.shade300,
                          color: AppColors.orangeLight,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "$jawabanTerisi / $totalSoal",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // PageView soal
                Expanded(
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: totalSoal,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final item = controller.exerciseList[index];

                      switch (item.questionType) {
                        case "multiple_choice":
                          return MultipleChoiceQuestionWidget(
                            question: item,
                            index: index,
                            totalSoal: totalSoal,
                            pageController: pageController,
                            controller: controller,
                          );
                        case "boolean":
                          return BooleanQuestionWidget(
                            question: item,
                            index: index,
                            totalSoal: totalSoal,
                            pageController: pageController,
                            controller: controller,
                          );
                        default:
                          return const SizedBox();
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      }),
    );
  }
}
