// ignore_for_file: unnecessary_to_list_in_spreads, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/localization/app_strings.dart';
import 'package:sehati/app/data/models/response/exercise_question_model.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/journal/feature/exercise/controllers/exercise_controller.dart';

class MultipleChoiceQuestionWidget extends StatefulWidget {
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
  State<MultipleChoiceQuestionWidget> createState() =>
      _MultipleChoiceQuestionWidgetState();
}

class _MultipleChoiceQuestionWidgetState
    extends State<MultipleChoiceQuestionWidget> {
  late String formattedQuestion = "";

  @override
  void initState() {
    super.initState();
    formattedQuestion = widget.question.question;
  }

  @override
  Widget build(BuildContext context) {
    int jawabanTerisi = widget.controller.exerciseList
        .where((q) => q.selectedOption != null || q.answerText != null)
        .length;
    bool semuaTerisi = jawabanTerisi == widget.totalSoal;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${AppStrings.get(AppStrings.exerciseKeyQuestion)} ${widget.index + 1} ${AppStrings.get(AppStrings.exerciseKeyOf)} ${widget.totalSoal}',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500, fontWeight: FontWeight.w600),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.stars_rounded, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '+${widget.question.rewardPoints} ${AppStrings.get(AppStrings.commonKeyPointsLabel)}',
                    style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.amber, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        AnimatedIn(
          child: Text(
            formattedQuestion,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 18,
              color: AppColors.textDark,
              height: 1.4,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: ListView(
            children: widget.question.options.entries.map((entry) {
              bool isSelected = widget.question.selectedOption == entry.key;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AnimatedIn(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        widget.question.selectedOption = entry.key;
                        widget.question.answerText = entry.value;
                        widget.controller.exerciseList.refresh();
                      });
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF2196F3) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF2196F3) : Colors.grey.shade200,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSelected ? Icons.check_circle_rounded : Icons.circle_outlined,
                            color: isSelected ? Colors.white : Colors.grey.shade400,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              entry.value,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: isSelected ? Colors.white : AppColors.textDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 24),
        _buildNavigation(semuaTerisi),
      ],
    );
  }

  Widget _buildNavigation(bool semuaTerisi) {
    return Row(
      children: [
        if (widget.index > 0)
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () => widget.pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              ),
              child: Text(AppStrings.get(AppStrings.commonKeyBack), style: const TextStyle(color: AppColors.textMedium, fontWeight: FontWeight.w700)),
            ),
          ),
        if (widget.index > 0) const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.index == widget.totalSoal - 1 
                  ? (semuaTerisi ? const Color(0xFF2196F3) : Colors.grey.shade300)
                  : const Color(0xFF2196F3),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () {
              if (widget.index < widget.totalSoal - 1) {
                widget.pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } else if (semuaTerisi) {
                widget.controller.submitAllAnswers();
              }
            },
            child: Text(
              widget.index == widget.totalSoal - 1 ? AppStrings.get(AppStrings.exerciseKeyFinish) : AppStrings.get(AppStrings.exerciseKeyNext),
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }
}
