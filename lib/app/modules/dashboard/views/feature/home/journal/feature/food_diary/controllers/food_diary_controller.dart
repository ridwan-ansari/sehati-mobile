import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FoodDiaryController extends GetxController {
  final dateController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // set tanggal default
    dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  @override
  void onClose() {
    dateController.dispose();
    super.onClose();
  }
}
