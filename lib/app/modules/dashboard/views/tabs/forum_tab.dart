import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:sehati/app/modules/dashboard/views/feature/forum/widget/post_card.dart';
import 'package:sehati/app/modules/dashboard/views/feature/forum/controller/forum_controller.dart';

class ForumTab extends GetView<ForumController> {
  const ForumTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Social",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        actions: [
          GestureDetector(
            onTap: () => Get.toNamed('/take_photo'),
            child: AppAssetUtils.svg(
              AppAssets.socialCamera,
              width: 32,
              height: 32,
            ),
          ),
          const SizedBox(width: 16),
          // GestureDetector(
          //   onTap: () => Get.toNamed('/social_profile'),
          //   child: AppAssetUtils.svg(
          //     AppAssets.scoialProfile,
          //     width: 32,
          //     height: 32,
          //   ),
          // ),
          // const SizedBox(width: 16),
        ],
        backgroundColor: Colors.white,
      ),

      // BODY
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.content.isEmpty) {
          return const Center(child: Text("Belum ada postingan"));
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
