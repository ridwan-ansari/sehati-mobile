// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:sehati/app/data/models/post_model.dart';
import 'package:sehati/app/modules/dashboard/views/feature/forum/widget/post_card.dart';

class ForumTab extends StatelessWidget {
  const ForumTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data feed
    final List<PostModel> posts = [
      PostModel(
        id: "1",
        userName: "Melanie",
        userProfileImage: "assets/images/melanie.png",
        contentText: "Yuk.. siapa yang mau samaan menu sarapan pagi ini?",
        contentImage:
            "https://media.istockphoto.com/id/814423752/photo/eye-of-model-with-colorful-art-make-up-close-up.jpg?s=612x612&w=0&k=20&c=l15OdMWjgCKycMMShP8UK94ELVlEGvt7GmB_esHWPYE=",
        likesCount: 10,
        createdAt: DateTime.now(),
      ),
      PostModel(
        id: "2",
        userName: "Aisyah",
        userProfileImage: "assets/images/aisyah.png",
        contentText: "Lari pagi bikin segar dan semangat!",
        contentImage:
            "https://media.istockphoto.com/id/517188688/photo/mountain-landscape.jpg?s=612x612&w=0&k=20&c=A63koPKaCyIwQWOTFBRWXj_PwCrR4cEoOw2S9Q7yVl8=",
        likesCount: 8,
        createdAt: DateTime.now(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Social",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        actions: [
          GestureDetector(
            onTap: () => Get.toNamed('/social_profile'),
            child: AppAssetUtils.svg(
              AppAssets.socialCamera,
              width: 32,
              height: 32,
            ),
          ),

          const SizedBox(width: 16.0),
          GestureDetector(
            onTap: () => Get.toNamed('/social_profile'),
            child: AppAssetUtils.svg(
              AppAssets.scoialProfile,
              width: 32,
              height: 32,
            ),
          ),
          const SizedBox(width: 16.0),
        ],
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: posts.length,
        itemBuilder: (context, index) => PostCard(post: posts[index]),
      ),
    );
  }
}
