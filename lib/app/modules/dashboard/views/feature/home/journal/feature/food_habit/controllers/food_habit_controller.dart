import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FoodHabitController extends GetxController {
  final frequencyController = TextEditingController();
  final fastFoodController = TextEditingController();
  final fruitController = TextEditingController();
  final vegetableController = TextEditingController();

  @override
  void onClose() {
    frequencyController.dispose();
    fastFoodController.dispose();
    fruitController.dispose();
    vegetableController.dispose();
    super.onClose();
  }
}
