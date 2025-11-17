import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import '../controllers/monitoring_controller.dart';

class MonitoringInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool isDateField;
  final MonitoringController? monitoringController;
  final bool isEdit;

  const MonitoringInputField({
    required this.controller,
    required this.hint,
    this.isDateField = false,
    this.monitoringController,
     this.isEdit = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (isDateField) {
      return GestureDetector(
        onTap: () => monitoringController?.selectDate(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(color: AppColors.orangeLight),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Obx(() => Center(
            child: Text(
              monitoringController?.selectedDate.value.isEmpty ?? true
                  ? hint
                  : monitoringController!.selectedDate.value,
              style: const TextStyle(color: Colors.orange, fontSize: 16),
            ),
          )),
        ),
      );
    }

    return SizedBox(
      height: 36,
      child: TextFormField(
        controller: controller,
        textAlign: TextAlign.center,
        readOnly: isEdit,
        keyboardType: const TextInputType.numberWithOptions(),
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.orange),
          ),
        ),
      ),
    );
  }
}
