import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/localization/app_strings.dart';
import 'package:sehati/app/common/utils/youtube_utils.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/edutainment/views/youtube_player_widget.dart';
import 'package:sehati/app/data/models/video_model.dart';
import 'package:sehati/app/data/services/edutainment_service.dart';

class VideoDetailPage extends StatefulWidget {
  final VideoModel video;
  const VideoDetailPage({super.key, required this.video});

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  bool rewardClaimed = false;

  @override
  Widget build(BuildContext context) {
    final videoId = YoutubeUtils.extractVideoId(widget.video.youtubeUrl);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.richBrown,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.video.title,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 250,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
              child: YoutubePlayerWidget(
                videoId: videoId,
                onVideoEnded: _claimReward,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.orangeLight.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.stars_rounded, color: AppColors.orangeLight, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              "+${widget.video.rewardPoints} Points",
                              style: const TextStyle(color: AppColors.orangeLight, fontWeight: FontWeight.w800, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.video.title,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.textDark),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.video.description,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.6),
                  ),
                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 16),
                  _buildStatusIndicator(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator() {
    if (rewardClaimed) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.green, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                AppStrings.getOr('Reward claimed! You earned ${widget.video.rewardPoints} points.', 'Hadiah diklaim! Anda mendapatkan ${widget.video.rewardPoints} poin.'),
                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      );
    }

    return Row(
      children: [
        const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.orangeLight)),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            AppStrings.getOr('Watching video... reward will be claimed automatically.', 'Sedang menonton... hadiah akan diklaim otomatis.'),
            style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ),
      ],
    );
  }

  Future<void> _claimReward() async {
    if (rewardClaimed) return;
    final success = await EdutainmentService().claimReward(widget.video.id);
    if (success) {
      setState(() => rewardClaimed = true);
    }
  }
}
