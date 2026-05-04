import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/localization/app_strings.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:sehati/app/common/widgets/custom_appbar.dart';
import 'package:sehati/app/data/services/language_service.dart';
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
          "icon": AppAssets.healthyMenuIcon,
          "reward": "100 ${AppStrings.get(AppStrings.menuKeyPointsReward)}",
          "route": "/food_diary",
          "color": const Color(0xFFFF9A3D), // Orange
        },
        {
          "title": AppStrings.get(AppStrings.menuKeyFoodHabit),
          "icon": AppAssets.circleChecklistIcon,
          "reward": "100 ${AppStrings.get(AppStrings.menuKeyPointsReward)}",
          "route": "/food_habit",
          "color": const Color(0xFF4CAF50), // Green
        },
        {
          "title": AppStrings.get(AppStrings.menuKeyExerciseHabit),
          "icon": AppAssets.activityIcon,
          "reward": "100 ${AppStrings.get(AppStrings.menuKeyPointsReward)}",
          "route": "/exercise",
          "color": const Color(0xFF2196F3), // Blue
        },
      ];

      return Scaffold(
        backgroundColor: AppColors.surface,
        appBar: CustomAppBar(
          title: AppStrings.get(AppStrings.menuKeyDailyJournal),
          showBackButton: true,
          onBack: () => Get.offAllNamed('/dashboard'),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: journals.length,
          itemBuilder: (context, index) {
            final item = journals[index];
            return _buildJournalCard(item);
          },
        ),
      );
    });
  }

  Widget _buildJournalCard(Map<String, dynamic> item) {
    final Color itemColor = item['color'] as Color;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => Get.toNamed(item['route'] ?? ''),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: itemColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: AppAssetUtils.svg(
                    item['icon'] ?? '',
                    width: 32,
                    height: 32,
                    color: itemColor,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item["title"] ?? "",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          AppAssetUtils.svg(
                            AppAssets.myPointIconCircle,
                            width: 14,
                            height: 14,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            item["reward"] ?? "",
                            style: const TextStyle(
                              color: AppColors.orangeLight,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                  color: Colors.grey.shade300,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
