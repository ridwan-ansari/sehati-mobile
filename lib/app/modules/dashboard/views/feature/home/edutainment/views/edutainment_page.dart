import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/widgets/custom_appbar.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/edutainment/controllers/edutainment_controller.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/edutainment/views/video_detail_page.dart';

class EdutainmentPage extends GetView<EdutainmentController> {
  const EdutainmentPage({super.key});

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        logoSvg: AppAssets.tvIcon,
        onSearchChanged: controller.onSearchChanged,
        controller: controller.searchController,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.yellowLight),
          );
        }

        if (controller.videos.isEmpty) {
          return const Center(child: Text("No videos found."));
        }

        return Column(
          children: [
            const SizedBox(height: 12.0),
            _buildHeader(),
            Expanded(
              child: ListView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: controller.hasMore
                    ? controller.videos.length + 1
                    : controller.videos.length,
                itemBuilder: (context, index) {
                  if (index == controller.videos.length) {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final video = controller.videos[index];

                  return Column(children: [buildVideoCard(context, video)]);
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.black),
      child: AnimatedIn(
        child: const Text(
          "Enjoy the video and get the reward point!",
          style: TextStyle(color: Colors.white, fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget buildVideoCard(BuildContext context, video) {
    final videoId = extractYouTubeId(video.youtubeUrl);
    final thumbnailUrl = "https://img.youtube.com/vi/$videoId/hqdefault.jpg";

    return GestureDetector(
      onTap: () => Get.to(() => VideoDetailPage(video: video)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail + Overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: AnimatedIn(
                    child: Image.network(
                      thumbnailUrl,
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: double.infinity,
                        height: 180,
                        color: Colors.grey.shade300,
                        child: const Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                // Play icon overlay
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: AnimatedIn(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(10),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ),

                // Reward badge
                // Positioned(
                //   right: 12,
                //   top: 12,
                //   child: Container(
                //     padding: const EdgeInsets.symmetric(
                //       horizontal: 10,
                //       vertical: 6,
                //     ),
                //     decoration: BoxDecoration(
                //       color: Colors.orange.shade600,
                //       borderRadius: BorderRadius.circular(12),
                //     ),
                //     child: Text(
                //       "+${video.rewardPoints} pts",
                //       style: const TextStyle(
                //         color: Colors.white,
                //         fontWeight: FontWeight.w600,
                //         fontSize: 13,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedIn(
                    child: Text(
                      video.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        height: 1.3,
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),

                  AnimatedIn(
                    child: Text(
                      video.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        height: 1.4,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  if (video.durationSeconds != null)
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          video.durationSeconds == null
                              ? "Duration not available"
                              : "${(video.durationSeconds! ~/ 60)} menit",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
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

  // Extract YT video ID
  String extractYouTubeId(String url) {
    final uri = Uri.parse(url);
    if (uri.queryParameters.containsKey('v')) {
      return uri.queryParameters['v']!;
    }
    return uri.pathSegments.last;
  }

  Widget titleContent({required String title}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.orangeLight, Color.fromARGB(60, 255, 255, 255)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
