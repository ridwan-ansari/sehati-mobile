import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/localization/app_strings.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:sehati/app/common/widgets/app_error_widget.dart';
import 'package:sehati/app/common/widgets/custom_appbar.dart';
import 'package:sehati/app/modules/dashboard/views/feature/forum/widget/post_card.dart';
import 'package:sehati/app/routes/app_routes.dart';
import 'package:sehati/app/modules/dashboard/views/feature/forum/controller/forum_controller.dart';
import 'package:sehati/app/modules/dashboard/controllers/dashboard_controller.dart';

class ForumTab extends GetView<ForumController> {
  const ForumTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(AppStrings.get(AppStrings.forumKeyTitle), style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.textDark)),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.camera_alt_rounded, color: AppColors.richBrown, size: MediaQuery.of(context).size.width * 0.07), 
            onPressed: () => Get.toNamed(AppRoutes.TAKE_PHOTO),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.richBrown));
        }

        if (controller.content.isEmpty) {
          return _buildEmptyState(context);
        }

        return RefreshIndicator(
          color: AppColors.richBrown,
          onRefresh: () async => controller.onRefreshData(),
          child: ListView.builder(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.01,
              bottom: MediaQuery.of(context).size.height * 0.15,
            ),
            itemCount: controller.content.length,
            itemBuilder: (context, index) {
              final item = controller.content[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.04, vertical: MediaQuery.of(context).size.height * 0.008),
                child: PostCard(post: item),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.forum_outlined, size: MediaQuery.of(context).size.width * 0.2, color: Colors.grey.shade300),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Text(AppStrings.get(AppStrings.forumKeyNoPosts), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textMedium)),
        ],
      ),
    );
  }
}
