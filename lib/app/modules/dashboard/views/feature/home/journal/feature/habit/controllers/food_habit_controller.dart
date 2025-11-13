import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/data/models/response/habit_question_model.dart';
import 'package:sehati/app/data/services/habit_service.dart';

class FoodHabitController extends GetxController {
  final frequencyController = TextEditingController();
  final fastFoodController = TextEditingController();
  final fruitController = TextEditingController();
  final vegetableController = TextEditingController();

  final HabitService _service = HabitService();
  var isLoading = false.obs;
  var questions = <HabitQuestionModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    try {
      isLoading.value = true;
      final data = await _service.getFoodQuestions();
      questions.assignAll(data ?? []);
    } catch (e) {
      print('Error fetching questions: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void selectOption(HabitQuestionModel question, String key, String value) {
    question.selectedOption = key;
    question.answerText = value;
    questions.refresh();
  }

  Future<void> submitAllAnswers() async {
    List<Map<String, dynamic>> answers = [];
    for (var question in questions) {
      print('ini apa ya : ${question.selectedOption}');
      answers.add({
        "question_id": question.id,
        "answer": question.selectedOption?.toLowerCase(),
        "frequency": 0,
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
