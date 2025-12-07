import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 250,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: YoutubePlayerWidget(
                      videoId: videoId,
                      onVideoEnded: _claimReward,
                    ),
                  ),

                  // Floating back button
                  Positioned(
                    top: 10,
                    left: 10,
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withOpacity(0.5),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Get.back(),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedIn(
                      child: Text(
                        widget.video.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          height: 1.3,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade600,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: AnimatedIn(
                        child: Text(
                          "+${widget.video.rewardPoints} Reward Points",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    AnimatedIn(
                      child: Text(
                        widget.video.description,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade800,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Divider(color: Colors.grey.shade300),
                    const SizedBox(height: 12),
                    if (!rewardClaimed)
                      Row(
                        children: [
                          Icon(
                            Icons.timelapse,
                            color: Colors.grey.shade700,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Watching video... reward will be claimed automatically when finished.",
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),

                    if (rewardClaimed)
                      Row(
                        children: [
                          const Icon(
                            Icons.verified,
                            color: Colors.green,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Reward claimed: +${widget.video.rewardPoints} points 🎉",
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
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
        margin: const EdgeInsets.all(12),
      );
    } else {
      Get.snackbar(
        "Failed",
        "Reward could not be claimed.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
      );
    }
  }
}
