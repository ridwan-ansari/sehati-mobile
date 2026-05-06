import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/localization/app_strings.dart';
import 'package:sehati/app/common/widgets/app_error_widget.dart';
import 'package:sehati/app/common/widgets/custom_appbar.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/data/models/recipe_model.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/healthy_menu/views/detail_healthy_page.dart';
import '../controllers/healthy_menu_controller.dart';

class HealthyMenuPage extends GetView<HealthyMenuController> {
  const HealthyMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      backgroundColor: AppColors.surface,
      appBar: CustomAppBar(
        logoSvg: AppAssets.healthyMenuIcon,
        title: AppStrings.get(AppStrings.menuKeyRecipes),
        controller: controller.searchController,
        onSearchChanged: controller.onSearchChanged,
        showBackButton: true,
      ),
      body: RefreshIndicator(
        color: AppColors.orangeLight,
        onRefresh: () => controller.fetchRecipes(reset: true),
        child: Builder(builder: (context) {
          if (controller.isLoading.value && controller.recipes.isEmpty) {
            return const Center(child: CircularProgressIndicator(color: AppColors.orangeLight));
          }
          if (controller.errorMessage.isNotEmpty && controller.recipes.isEmpty) {
            return AppErrorWidget(
              message: controller.errorMessage.value,
              onRetry: () => controller.fetchRecipes(reset: true),
            );
          }
          if (controller.recipes.isEmpty) {
            return Center(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Center(
                    child: Text(
                      AppStrings.getOr("No recipes found.", "Resep tidak ditemukan."),
                      style: const TextStyle(color: Colors.black45, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            );
          }

          return ListView.builder(
            controller: controller.scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            itemCount: controller.recipes.length + (controller.isLoading.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == controller.recipes.length) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator(color: AppColors.orangeLight)),
                );
              }
              return _RecipeCard(recipe: controller.recipes[index]);
            },
          );
        }),
      ),
    ));
  }
}

class _RecipeCard extends StatelessWidget {
  const _RecipeCard({required this.recipe});
  final RecipeModel recipe;

  @override
  Widget build(BuildContext context) {
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
          onTap: () => Get.to(() => RecipeDetailPage(recipe: recipe)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    imageUrl: '$BASE_URL${recipe.imageUrl}',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(color: Colors.grey[100]),
                    errorWidget: (_, __, ___) => Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[100],
                      child: const Icon(Icons.restaurant_menu_rounded, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.orangeLight.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          AppStrings.getOr('View Details', 'Lihat Detail'),
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.orangeLight,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
