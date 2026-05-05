
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/localization/app_strings.dart';
import 'package:sehati/app/common/utils/snackbar_utils.dart';
import 'package:sehati/app/data/models/response/habit_question_model.dart';
import 'package:sehati/app/data/services/habit_service.dart';
import 'package:sehati/app/common/utils/app_logger.dart';

class FoodHabitController extends GetxController {
  final frequencyController = TextEditingController();
  final fastFoodController = TextEditingController();
  final fruitController = TextEditingController();
  final vegetableController = TextEditingController();

  final HabitService _service = HabitService();
  var isLoading = false.obs;
  var questions = <HabitQuestionModel>[].obs;
  var groupedQuestions = <String, List<HabitQuestionModel>>{}.obs;
  var expandedCategories = <String, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchQuestions();
  }

  void toggleCategory(String category) {
    expandedCategories[category] = !(expandedCategories[category] ?? false);
    expandedCategories.refresh();
  }

  Future<void> fetchQuestions() async {
    try {
      isLoading.value = true;
      final data = await _service.getFoodQuestions();

      questions.assignAll(data ?? []);
      groupQuestions();
    } catch (e) {
      AppLogger.log('Error fetching questions: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void groupQuestions() {
    groupedQuestions.clear();

    for (var q in questions) {
      final cat = q.category;

      if (!groupedQuestions.containsKey(cat)) {
        groupedQuestions[cat] = [];
      }
      groupedQuestions[cat]!.add(q);

      /// RESET NILAI
      q.selectedOption = null;
      q.answerText = null;
      q.frequency = null;
    }
    groupedQuestions.refresh();
    questions.refresh();
  }

  void selectOption(
    HabitQuestionModel question,
    String option,
    int frequency,
  ) {
    question.selectedOption = option;
    question.frequency = frequency;

    questions.refresh();
  }

  Future<void> submitAllAnswers() async {
    final incomplete = questions.where((q) => q.selectedOption == null).toList();

    if (incomplete.isNotEmpty) {
      SnackbarUtils.show(AppStrings.get(AppStrings.habitKeyIncomplete));
      return;
    }

    List<Map<String, dynamic>> answers = [];

    for (var question in questions) {
      answers.add({
        "question_id": question.id,
        "answer": question.selectedOption,
        "frequency": question.frequency,
      });
    }

    final success = await _service.submiteHabitAnswer(answers: answers);

    if (success) {
      Get.toNamed('/journal');
    }
  }

  @override
  void onClose() {
    frequencyController.dispose();
    fastFoodController.dispose();
    fruitController.dispose();
    vegetableController.dispose();
    super.onClose();
  }
}
