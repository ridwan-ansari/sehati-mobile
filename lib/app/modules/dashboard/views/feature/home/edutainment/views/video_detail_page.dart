import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      body: Column(
        children: [
          YoutubePlayerWidget(
            videoId: videoId,
            onVideoEnded: _claimReward,
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.video.description,
                  style: const TextStyle(fontSize: 14),
                ),

                const SizedBox(height: 20),

                if (!rewardClaimed)
                  const Text(
                    "Watching video... reward will be claimed automatically when finished.",
                    style: TextStyle(color: Colors.orange),
                  ),

                if (rewardClaimed)
                  Text(
                    "Reward claimed: +${widget.video.rewardPoints} points 🎉",
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _claimReward() async {
    if (rewardClaimed) return;

    final success = await EdutainmentService().claimReward(widget.video.id);

    if (success) {
      setState(() => rewardClaimed = true);

      Get.snackbar(
        "Reward Added",
        "You earned +${widget.video.rewardPoints} points 🎉",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } else {
      Get.snackbar(
        "Failed",
        "Reward could not be claimed.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }
}
