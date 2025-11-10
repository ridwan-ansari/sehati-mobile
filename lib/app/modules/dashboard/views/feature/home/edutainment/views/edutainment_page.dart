import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/widgets/custom_appbar.dart';
import '../controllers/edutainment_controller.dart';
import 'youtube_player_widget.dart';

class EdutainmentPage extends GetView<EdutainmentController> {
  const EdutainmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final videos = [
      {
        "title": "How to read nutrition label",
        "videoId": "nPt8bK2gbaU",
        "desc": [
          "Learn how to read nutrition labels properly.",
          "Understand daily value and serving size.",
          "Identify good vs bad fats quickly.",
        ],
        "reward": "20 points",
      },
      {
        "title": "Understanding my plate",
        "videoId": "nPt8bK2gbaU",
        "desc": [
          "Visualize balanced meals with MyPlate guide.",
          "Know the 5 major food groups.",
          "Plan healthy portions every day.",
        ],
        "reward": "20 points",
      },
      {
        "title": "Simple exercise at home",
        "videoId": "UItWltVZZmE",
        "desc": [
          "5-minute morning exercise.",
          "Stretching to improve metabolism.",
          "Stay active without gym equipment.",
        ],
        "reward": "20 points",
      },
    ];

    return Scaffold(
      appBar: CustomAppBar(
        logoSvg: AppAssets.tvIcon,
        onSearchChanged: (_) {},
        onProfileTap: () {},
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            ...videos.map((video) => _buildVideoCard(context, video)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.brown.shade700,
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Text(
        "Enjoy the video and get the reward point!",
        style: TextStyle(color: Colors.white, fontSize: 14),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildVideoCard(BuildContext context, Map<String, dynamic> video) {
    final thumbnailUrl =
        "https://img.youtube.com/vi/${video["videoId"]}/hqdefault.jpg";

    return GestureDetector(
      onTap: () => Get.to(() => _VideoDetailPage(video: video)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFE082),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                thumbnailUrl,
                width: 120,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.red.shade400,
                  width: 120,
                  height: 80,
                  child: const Icon(Icons.play_circle_fill,
                      color: Colors.white, size: 40),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade400,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      video["title"],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  ...video["desc"]
                      .map<Widget>(
                        (text) => Text(
                          text,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
                          ),
                        ),
                      )
                      .toList(),
                  const SizedBox(height: 6),
                  Text(
                    "Reward: ${video["reward"]}",
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.brown,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VideoDetailPage extends StatelessWidget {
  final Map<String, dynamic> video;
  const _VideoDetailPage({required this.video});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(video["title"]),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          YoutubePlayerWidget(videoId: video["videoId"]),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ...video["desc"]
                    .map<Widget>((text) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text(
                            text,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ))
                    .toList(),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    Get.snackbar(
                      "Reward Added",
                      "You earned +20 points 🎉",
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.TOP,
                    );
                  },
                  icon: const Icon(Icons.card_giftcard),
                  label: const Text("Claim Reward"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade400,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
