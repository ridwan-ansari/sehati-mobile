
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/localization/app_strings.dart';
import 'package:sehati/app/common/utils/snackbar_utils.dart';
import 'package:sehati/app/data/models/response/habit_question_model.dart';
import 'package:sehati/app/data/services/habit_service.dart';
import 'package:sehati/app/common/utils/app_logger.dart';

import 'package:intl/intl.dart';
import 'package:sehati/app/data/services/local_storage_service.dart';

class FoodHabitController extends GetxController {
  final frequencyController = TextEditingController();
  final fastFoodController = TextEditingController();
  final fruitController = TextEditingController();
  final vegetableController = TextEditingController();
  final PageController pageController = PageController();

  final HabitService _service = HabitService();
  var isLoading = false.obs;
  var isSubmittedToday = false.obs;
  var currentPage = 0.obs;
  var questions = <HabitQuestionModel>[].obs;
  var groupedQuestions = <String, List<HabitQuestionModel>>{}.obs;
  var expandedCategories = <String, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    checkSubmissionStatus();
    fetchQuestions();
  }

  void checkSubmissionStatus() {
    final lastSubmit = LocalStorageService.getLastHabitSubmit();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    if (lastSubmit == today) {
      isSubmittedToday.value = true;
    }
  }

  void nextPage() {
    if (currentPage.value < groupedQuestions.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void onPageChanged(int index) {
    currentPage.value = index;
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
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      await LocalStorageService.setLastHabitSubmit(today);
      isSubmittedToday.value = true;
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
