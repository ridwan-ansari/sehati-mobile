import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/widgets/app_error_widget.dart';
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
        controller: controller.searchController,
        onSearchChanged: controller.onSearchChanged,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          AnimatedIn(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.richBrown,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Explore healthy recipes!',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.recipes.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.orangeLight),
                );
              }
              if (controller.errorMessage.isNotEmpty && controller.recipes.isEmpty) {
                return AppErrorWidget(
                  message: controller.errorMessage.value,
                  onRetry: () => controller.fetchRecipes(reset: true),
                );
              }
              return Container(
                color: AppColors.yellowLight,
                child: SingleChildScrollView(
                  controller: controller.scrollController,
                  child: Column(
                    children: [
                      ListView.builder(
                        itemCount: controller.recipes.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return _RecipeCard(recipe: controller.recipes[index]);
                        },
                      ),
                      if (controller.isLoading.value)
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(
                            color: AppColors.orangeLight,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _RecipeCard extends StatelessWidget {
  const _RecipeCard({required this.recipe});

  final RecipeModel recipe;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedIn(
            child: Container(
              height: 125,
              width: 125,
              decoration: BoxDecoration(
                color: AppColors.gold.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.brown, width: 2),
                image: DecorationImage(
                  image: CachedNetworkImageProvider('$BASE_URL${recipe.imageUrl}'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedIn(
                  child: GradienLabelRight(title: recipe.title, fontSize: 14),
                ),
                const SizedBox(height: 8),
                AnimatedIn(
                  child: ElevatedButton(
                    onPressed: () => Get.to(RecipeDetailPage(recipe: recipe)),
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
                      'View Details',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
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
