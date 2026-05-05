import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/localization/app_strings.dart';
import 'package:sehati/app/common/widgets/app_error_widget.dart';
import 'package:sehati/app/common/widgets/custom_appbar.dart';
import 'package:sehati/app/data/models/video_model.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/edutainment/controllers/edutainment_controller.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/edutainment/views/video_detail_page.dart';

class EdutainmentPage extends GetView<EdutainmentController> {
  const EdutainmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      backgroundColor: AppColors.surface,
      appBar: CustomAppBar(
        logoSvg: AppAssets.tvIcon,
        title: AppStrings.get(AppStrings.menuKeyEdutainment),
        onSearchChanged: (v) => controller.onSearchChanged(v),
        controller: controller.searchController,
        showBackButton: true,
      ),
      body: Builder(builder: (context) {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.orangeLight));
        }

        if (controller.errorMessage.isNotEmpty) {
          return AppErrorWidget(
            message: controller.errorMessage.value,
            onRetry: () => controller.loadVideos(reset: true),
          );
        }

        if (controller.videos.isEmpty) {
          return Center(
            child: Text(
              AppStrings.get(AppStrings.eduKeyNoVideos),
              style: const TextStyle(color: Colors.black45, fontWeight: FontWeight.w600),
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.all(20),
                itemCount: controller.hasMore.value
                    ? controller.videos.length + 1
                    : controller.videos.length,
                itemBuilder: (context, index) {
                  if (index == controller.videos.length) {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(child: CircularProgressIndicator(color: AppColors.orangeLight)),
                    );
                  }

                  final video = controller.videos[index];
                  return buildVideoCard(context, video);
                },
              ),
            ),
          ],
        );
      }),
    ));
  }

  Widget buildVideoCard(BuildContext context, VideoModel video) {
    final videoId = extractYouTubeId(video.youtubeUrl);
    final thumbnailUrl = "https://img.youtube.com/vi/$videoId/hqdefault.jpg";

    return GestureDetector(
      onTap: () => Get.to(() => VideoDetailPage(video: video)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: CachedNetworkImage(
                    imageUrl: thumbnailUrl,
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(width: double.infinity, height: 180, color: Colors.grey[100]),
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.3), shape: BoxShape.circle),
                      padding: const EdgeInsets.all(12),
                      child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 40),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textDark, height: 1.3),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    video.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.5),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.orangeLight.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.timer_outlined, size: 14, color: AppColors.orangeLight),
                            const SizedBox(width: 6),
                            Text(
                              video.durationSeconds == null ? AppStrings.get(AppStrings.commonKeyNotSet) : "${(video.durationSeconds! ~/ 60)} ${AppStrings.get(AppStrings.eduKeyMinutes)}",
                              style: const TextStyle(fontSize: 12, color: AppColors.orangeLight, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String extractYouTubeId(String url) {
    try {
      final uri = Uri.parse(url);
      if (uri.queryParameters.containsKey('v')) return uri.queryParameters['v']!;
      return uri.pathSegments.last;
    } catch (_) {
      return "";
    }
  }
}
