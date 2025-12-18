import 'package:flutter/material.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/constants/app_colors.dart';

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
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Add Food",
          style: TextStyle(fontWeight: FontWeight.bold),
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

            /// Kcal per 100g
            Text(
              "$kcalPer100g kcal / 100g",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),

            const SizedBox(height: 16),

            /// Input gram
            TextField(
              controller: gramC,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Input gram",
                suffixText: "g",
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(color: AppColors.black.withOpacity(0.5)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange, // warna tombol
              foregroundColor: Colors.white, // warna teks & icon
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              final gram = int.tryParse(gramC.text) ?? 0;
              final totalKcal = ((kcalPer100g / 100) * gram).round();

              Navigator.pop(context);
              onSubmit(gram, totalKcal);
            },
            child: AnimatedIn(child: const Text("Add")),
          ),
        ],
      );
    },
  );
}
