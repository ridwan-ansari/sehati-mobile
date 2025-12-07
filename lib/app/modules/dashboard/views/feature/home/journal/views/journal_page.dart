import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/journal/widgets/gradien_label_right.dart';
import '../controllers/journal_controller.dart';

class JournalPage extends GetView<JournalController> {
  const JournalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final journals = [
      {
        "title": "Food Diary",
        "image": AppAssets.foodDiary,
        "reward": "100 points",
        "route": "/food_diary",
      },
      {
        "title": "Food Habit",
        "image": AppAssets.habits,
        "reward": "100 points",
        "route": "/food_habit",
      },
      {
        "title": "Exercise Habit",
        "image": AppAssets.exercise,
        "reward": "100 points",
        "route": "/exercise",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.gold,
        title: Text("Daily Journal"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12.0),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(color: Colors.black87),
            child: const Text(
              "Write Down Your Daily Journal, Here!",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Container(
              color: AppColors.yellowLight,
              child: Column(
                children: [
                  ListView.builder(
                    itemCount: journals.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final item = journals[index];
                      return _buildJournalCard(item);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJournalCard(Map<String, String> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),

      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedIn(child: AppAssetUtils.image(item['image']??'' , width: 125)),
          const SizedBox(width: 12),

          // Informasi
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GradienLabelRight(title: item["title"] ?? "", fontSize: 14),
                const SizedBox(height: 8),

                AnimatedIn(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed(item['route'] ?? '');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.black,
                      side: const BorderSide(color: Colors.black, width: 2),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      "START JOURNALLING",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                AnimatedIn(
                  child: Text(
                    "Reward: ${item["reward"]}",
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
