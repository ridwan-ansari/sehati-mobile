// ignore_for_file: avoid_print

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
  var groupedQuestions = <String, List<HabitQuestionModel>>{}.obs;
  var expandedCategories = <String, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchQuestions();
  }

  void toggleCategory(String category) {
    expandedCategories[category] = !(expandedCategories[category] ?? false);
  }

  Future<void> fetchQuestions() async {
    try {
      isLoading.value = true;
      final data = await _service.getFoodQuestions();
      questions.assignAll(data ?? []);
      await groupQuestions();
    } catch (e) {
      print('Error fetching questions: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> groupQuestions() async {
    groupedQuestions.clear();

    for (var q in questions) {
      final cat = q.category;

      if (!groupedQuestions.containsKey(cat)) {
        groupedQuestions[cat] = [];
      }
      groupedQuestions[cat]!.add(q);
      q.answerText = 'false';
      q.selectedOption = 'false';
    }
    questions.refresh();
  }

  void selectOption(HabitQuestionModel question, String key, String value , int? frequency) {
    question.selectedOption = key;
    question.answerText = value;
    question.frequency = frequency;
    questions.refresh();
  }

  Future<void> submitAllAnswers() async {
    List<Map<String, dynamic>> answers = [];
    for (var question in questions) {
      answers.add({
        "question_id": question.id,
        "answer": question.selectedOption?.toLowerCase(),
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
