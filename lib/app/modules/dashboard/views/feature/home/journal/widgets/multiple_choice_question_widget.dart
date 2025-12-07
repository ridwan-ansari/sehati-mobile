// ignore_for_file: unnecessary_to_list_in_spreads

import 'package:flutter/material.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/data/models/response/exercise_question_model.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/journal/feature/exercise/controllers/exercise_controller.dart';

class MultipleChoiceQuestionWidget extends StatelessWidget {
  final ExerciseQuestionModel question;
  final int index;
  final int totalSoal;
  final PageController pageController;
  final ExerciseController controller;

  const MultipleChoiceQuestionWidget({
    super.key,
    required this.question,
    required this.index,
    required this.totalSoal,
    required this.pageController,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    int jawabanTerisi = controller.exerciseList
        .where((q) => q.selectedOption != null || q.answerText != null)
        .length;
    bool semuaTerisi = jawabanTerisi == totalSoal;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
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
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.yellow.shade50,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question ${index + 1} / $totalSoal',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  AnimatedIn(
                    child: Row(
                      children: [
                        const Icon(Icons.monetization_on, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          '+${question.rewardPoints}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              AnimatedIn(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: SingleChildScrollView(
                    child: Text(
                      question.question,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ...question.options.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: AnimatedIn(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: question.selectedOption == entry.key
                            ? AppColors.orangeLight
                            : const Color(0xFF3D2C1C),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        question.selectedOption = entry.key;
                        question.answerText = entry.value;
                        controller.exerciseList.refresh();
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(entry.value),
                      ),
                    ),
                  ),
                );
              }).toList(),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (index > 0)
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color(0xFFFFB74D),
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        foregroundColor: Color(0xFFFFB74D),
                      ),
                      onPressed: () => pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      ),
                      child: const Text("Previous"),
                    ),
                  if (index < totalSoal - 1)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.orangeLight,
                      ),
                      onPressed: () => pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      ),
                      child: const Text("Next"),
                    ),
                  if (index == totalSoal - 1)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: semuaTerisi
                            ? AppColors.orangeLight
                            : Colors.grey,
                      ),
                      onPressed: semuaTerisi
                          ? () => controller.submitAllAnswers()
                          : null,
                      child: const Text("Submit"),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
