import 'package:flutter/material.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/localization/app_strings.dart';

Future<void> showFoodGramDialog({
  required BuildContext context,
  required String foodName,
  required int kcalPer100g,
  required void Function(int gram, int totalKcal) onSubmit,
}) async {
  final gramC = TextEditingController();

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setState) {
          bool isGramEmpty = gramC.text.isEmpty;
          gramC.addListener(() {
            setState(() {});
          });

          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(
              AppStrings.get(AppStrings.foodKeyAddFood),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  foodName,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Text(
                  "$kcalPer100g kcal / 100g",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      AppStrings.get(AppStrings.foodKeyGram),
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const Text(
                      " *",
                      style: TextStyle(fontSize: 14, color: Colors.red),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: gramC,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: AppStrings.get(AppStrings.foodKeyInputGram),
                    suffixText: "g",
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                if (isGramEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      AppStrings.get(AppStrings.foodKeyGramRequired),
                      style: TextStyle(fontSize: 12, color: Colors.red.shade600),
                    ),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  AppStrings.get(AppStrings.commonKeyCancel),
                  style: TextStyle(color: AppColors.black.withOpacity(0.5)),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isGramEmpty ? Colors.grey.shade300 : Colors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: isGramEmpty
                    ? null
                    : () {
                        final gram = int.tryParse(gramC.text) ?? 0;
                        final totalKcal = ((kcalPer100g / 100) * gram).round();
                        Navigator.pop(context);
                        onSubmit(gram, totalKcal);
                      },
                child: AnimatedIn(child: Text(AppStrings.get(AppStrings.commonKeyAdd))),
              ),
            ],
          );
        },
      );
    },
  );
}
