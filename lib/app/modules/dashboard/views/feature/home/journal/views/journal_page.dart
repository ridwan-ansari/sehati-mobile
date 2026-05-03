import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/localization/app_strings.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:sehati/app/data/services/language_service.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/journal/widgets/gradien_label_right.dart';
import '../controllers/journal_controller.dart';

class JournalPage extends GetView<JournalController> {
  const JournalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      Get.find<LanguageService>().currentLanguage.value;

      final journals = [
        {
          "title": AppStrings.get(AppStrings.menuKeyFoodDiary),
          "image": AppAssets.foodDiary,
          "reward": "100 points",
          "route": "/food_diary",
        },
        {
          "title": AppStrings.get(AppStrings.menuKeyFoodHabit),
          "image": AppAssets.habits,
          "reward": "100 points",
          "route": "/food_habit",
        },
        {
          "title": AppStrings.get(AppStrings.menuKeyExerciseHabit),
          "image": AppAssets.exercise,
          "reward": "100 points",
          "route": "/exercise",
        },
      ];

      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.richBrown,
          foregroundColor: Colors.white,
          title: Text(AppStrings.get(AppStrings.menuKeyDailyJournal)),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12.0),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const BoxDecoration(color: Colors.black87),
              child: Text(
                AppStrings.get(AppStrings.menuKeyWriteJournal),
                style: const TextStyle(
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
    });
  }

  Widget _buildJournalCard(Map<String, String> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedIn(child: AppAssetUtils.image(item['image'] ?? '', width: 125)),
          const SizedBox(width: 12),

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
                    child: Text(
                      AppStrings.get(AppStrings.menuKeyStartJournalling).toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                AnimatedIn(
                  child: Text(
                    "${AppStrings.get(AppStrings.menuKeyReward)}: ${item["reward"]}",
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
