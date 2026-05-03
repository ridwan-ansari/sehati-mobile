import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:sehati/app/common/widgets/app_error_widget.dart';
import 'package:sehati/app/modules/dashboard/views/feature/forum/widget/post_card.dart';
import 'package:sehati/app/modules/dashboard/views/feature/forum/controller/forum_controller.dart';

class ForumTab extends GetView<ForumController> {
  const ForumTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
        backgroundColor: AppColors.richBrown,
        foregroundColor: Colors.white,
        actions: [
          GestureDetector(
            onTap: () => Get.toNamed('/take_photo'),
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: AppAssetUtils.svg(
                AppAssets.socialCamera,
                width: 28,
                height: 28,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.orangeLight),
          );
        }

        if (controller.errorMessage.isNotEmpty) {
          return AppErrorWidget(
            message: controller.errorMessage.value,
            onRetry: controller.fetchForums,
          );
        }

        if (controller.content.isEmpty) {
          return const Center(
            child: Text(
              'No posts yet.\nBe the first to share!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, height: 1.5),
            ),
          );
        }

        return RefreshIndicator(
          color: AppColors.orangeLight,
          onRefresh: () async => controller.onRefreshData(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.content.length,
            itemBuilder: (context, index) {
              final item = controller.content[index];
              return PostCard(post: item);
            },
          ),
        );
      }),
    );
  }
}
