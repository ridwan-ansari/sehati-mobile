import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/localization/app_strings.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:sehati/app/common/widgets/app_error_widget.dart';
import 'package:sehati/app/common/widgets/custom_appbar.dart';
import 'package:sehati/app/modules/dashboard/views/feature/forum/widget/post_card.dart';
import 'package:sehati/app/modules/dashboard/views/feature/forum/controller/forum_controller.dart';
import 'package:sehati/app/modules/dashboard/controllers/dashboard_controller.dart';

class ForumTab extends GetView<ForumController> {
  const ForumTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: CustomAppBar(
        showBackButton: true,
        showProfile: false,
        onBack: () => Get.find<DashboardController>().changeTab(0),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.orangeLight));
        }

        if (controller.errorMessage.isNotEmpty) {
          return AppErrorWidget(
            message: controller.errorMessage.value,
            onRetry: controller.fetchForums,
          );
        }

        if (controller.content.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.forum_outlined, size: 64, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                Text(
                  AppStrings.getOr('No posts yet.\nBe the first to share!', 'Belum ada postingan.\nJadilah yang pertama berbagi!'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black45, height: 1.5, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: AppColors.orangeLight,
          onRefresh: () async => controller.onRefreshData(),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: controller.content.length,
            itemBuilder: (context, index) {
              final item = controller.content[index];
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: PostCard(post: item),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/take_photo'),
        backgroundColor: AppColors.richBrown,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: AppAssetUtils.svg(
          AppAssets.socialCamera,
          width: 24,
          height: 24,
          color: Colors.white,
        ),
      ),
    );
  }
}
