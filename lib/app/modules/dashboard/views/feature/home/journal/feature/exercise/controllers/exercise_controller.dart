import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sehati/app/data/models/response/exercise_question_model.dart';
import 'package:sehati/app/data/services/exercise_service.dart';
import 'package:sehati/app/data/services/local_storage_service.dart';

class ExerciseController extends GetxController {
  final ExerciseService _service = ExerciseService();

  final pageController = PageController();
  final isLoading = false.obs;
  final isSubmittedToday = false.obs;
  final RxList<ExerciseQuestionModel> exerciseList =
      <ExerciseQuestionModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    checkSubmissionStatus();
    fetchExerciseQuestions();
  }

  void checkSubmissionStatus() {
    final lastSubmit = LocalStorageService.getLastExerciseSubmit();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    if (lastSubmit == today) {
      isSubmittedToday.value = true;
    }
  }

  Future<void> fetchExerciseQuestions() async {
    try {
      isLoading.value = true;
      final data = await _service.getExerciseQuestions();
      if (data != null) {
        _sortExerciseQuestions(data);
        exerciseList.assignAll(data);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void _sortExerciseQuestions(List<ExerciseQuestionModel> questions) {
    final orderMap = {
      'type': 0,
      'total expenditure': 1,
      'target intake': 2,
      'actual intake': 3,
    };

    questions.sort((a, b) {
      final aKey = a.question.toLowerCase();
      final bKey = b.question.toLowerCase();

      int aOrder = 999;
      int bOrder = 999;

      orderMap.forEach((key, order) {
        if (aKey.contains(key)) aOrder = order;
        if (bKey.contains(key)) bOrder = order;
      });

      return aOrder.compareTo(bOrder);
    });
  }

  Future<void> submitAllAnswers() async {
    List<Map<String, dynamic>> answers = [];

    for (var question in exerciseList) {
      answers.add({
        "question_id": question.id,
        "selected_option": question.selectedOption,
        "answer_text": question.answerText,
      });
    }

    final success = await _service.submitExerciseAnswersBatch(answers: answers);

    if (success) {
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      await LocalStorageService.setLastExerciseSubmit(today);
      isSubmittedToday.value = true;
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
    exerciseList.clear();
  }
}
