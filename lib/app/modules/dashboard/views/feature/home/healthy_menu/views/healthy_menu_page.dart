// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/widgets/custom_appbar.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/data/models/recipe_model.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/healthy_menu/views/detail_healthy_page.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/journal/widgets/gradien_label_right.dart';
import '../controllers/healthy_menu_controller.dart';

class HealthyMenuPage extends GetView<HealthyMenuController> {
  const HealthyMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        logoSvg: AppAssets.healthyMenuIcon,
        onProfileTap: () => print("Profile tapped"),
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
              "Welcome to various healthy menu recipe!",
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
              child: SingleChildScrollView(
                controller: ScrollController(),
                child: Column(
                  children: [
                    Obx(
                      () => ListView.builder(
                        itemCount: controller.recipes.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final item = controller.recipes[index];
                          return _recipeCard(item);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _recipeCard(RecipeModel recipe) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),

      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 125,
            width: 125,
            decoration: BoxDecoration(
              color: AppColors.gold.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: BoxBorder.all(color: Colors.brown, width: 2),
              image: DecorationImage(
                image: NetworkImage("$BASE_URL${recipe.imageUrl}"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Informasi
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GradienLabelRight(title: recipe.title, fontSize: 14),
                const SizedBox(height: 8),

                ElevatedButton(
                  onPressed: () {
                    Get.to(RecipeDetailPage(recipe: recipe));
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
                    "More Details",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
                const SizedBox(height: 6),
                // Text(
                //   "Reward: ${recipe.}",
                //   style: const TextStyle(
                //     color: Colors.black87,
                //     fontSize: 13,
                //     fontWeight: FontWeight.w500,
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
