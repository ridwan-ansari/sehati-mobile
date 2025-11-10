import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/utils/time_utils.dart';

class MonitoringController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  final dateController = TextEditingController();
  final resultController = TextEditingController();
  final imtController = TextEditingController();
  final zScoreController = TextEditingController();
  final idealController = TextEditingController();

  
  final selectedDate = ''.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    selectedDate.value = TimeUtils.formatShortDate(DateTime.now());
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  Future<void> selectDate() async {
    final now = DateTime.now();
    final picked = await Get.dialog<DateTime>(
      Theme(
        data: Theme.of(Get.context!).copyWith(
          datePickerTheme: DatePickerThemeData(
            backgroundColor: Colors.white,
            headerBackgroundColor: Colors.orange,
            headerForegroundColor: Colors.white,
            dayForegroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return Colors.white;
              }
              return Colors.black;
            }),
            todayBackgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return Colors.orange;
              }
              return Colors.orange.withOpacity(0.2);
            }),
            todayForegroundColor: WidgetStateProperty.all(Colors.white),
            todayBorder: const BorderSide(color: Colors.orange, width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            confirmButtonStyle: TextButton.styleFrom(
              foregroundColor: Colors.orange,
            ),
            cancelButtonStyle: TextButton.styleFrom(
              foregroundColor: Colors.grey[700],
            ),
          ),
        ),
        child: DatePickerDialog(
          initialDate: now,
          firstDate: DateTime(1950),
          lastDate: now,
        ),
      ),
    );

    if (picked != null) {
      selectedDate.value = TimeUtils.formatShortDate(picked);
    }
  }

}
