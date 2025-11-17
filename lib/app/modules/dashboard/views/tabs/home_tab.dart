// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/widgets/custom_appbar.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:sehati/app/common/constants/app_assets.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        logoSvg: AppAssets.logoSehati,
        onSearchChanged: (value) {
          print("Search keyword: $value");
        },
        onProfileTap: () {
          print("Profile tapped");
        },
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ======== Top Stats ========
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B2B27),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      icon: AppAssets.stepIcon,
                      label: "My Steps",
                      value: "3000",
                    ),
                    _buildStatItem(
                      icon: AppAssets.myPointIconCircle,
                      label: "My Points",
                      value: "1000 pts",
                    ),
                    _buildStatItem(
                      icon: AppAssets.badgesCircleIcon,
                      label: "My Badges",
                      value: "3 out 6",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ======== Notification ========
              Text(
                "Notification & Recent Update!",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B2B27),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    AppAssetUtils.svg(AppAssets.menuIcon , width: 24 , height: 24),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Hi Dear, Did you missed to record your daily journal?",
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ======== Features ========
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Features",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  AppAssetUtils.svg(AppAssets.menuIcon , width: 24 , height: 24 , color: const Color(0xFF3B2B27)),
                ],
              ),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                mainAxisSpacing: 20,
                crossAxisSpacing: 10,
                childAspectRatio: 0.75,
                children: [
                  _buildFeatureItem(AppAssets.monitoringIcon,"Self\nmonitoring",onTap: ()=> Get.toNamed('/monitoring')),
                  _buildFeatureItem(AppAssets.appointmentIcon, "Appointment",onTap: ()=> Get.toNamed('/appointment')),
                  _buildFeatureItem(AppAssets.tvIcon, "Video\nEdutainment",onTap: ()=> Get.toNamed('/edutainment')),
                  _buildFeatureItem(AppAssets.gameIcon, "Game",onTap: ()=> Get.toNamed('/game')),
                  _buildFeatureItem(AppAssets.dayliIcon, "Daily\nJournal",onTap: ()=> Get.toNamed('/journal')),
                  _buildFeatureItem(AppAssets.chatIcon, "Chatting",onTap: ()=> Get.toNamed('/chatting')),
                  _buildFeatureItem(AppAssets.healthyMenuIcon, "Healthy\nMenu",onTap: ()=> Get.toNamed('/healthy_menu')),
                  _buildFeatureItem(AppAssets.riminderIcon, "Reminder",onTap: ()=> Get.toNamed('/reminder')),
                ],
              ),
              const SizedBox(height: 20),

              // ======== Playing Games ========
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Playing Games",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                   AppAssetUtils.svg(AppAssets.menuIcon , width: 24 , height: 24 , color: const Color(0xFF3B2B27)),
                ],
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildGameCard("Game 1"),
                    const SizedBox(width: 10),
                    _buildGameCard("Game 2"),
                    const SizedBox(width: 10),
                    _buildGameCard("Game 3"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================== Widgets ==================

  Widget _buildStatItem({
    required String icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        AppAssetUtils.svg(icon, width: 36, height: 36),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(color: Colors.white, fontSize: 12)),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureItem(String icon, String label ,{void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF3B2B27),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: AppAssetUtils.svg(
                icon,
                width: 28,
                height: 28,
                color: Colors.yellow,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.black87),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildGameCard(String title) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        border: Border.all(color: const Color(0xFF3B2B27), width: 1),
      ),
      child: Column(
        children: [
         AppAssetUtils.svg(AppAssets.gameIcon , height: 80 , width: 100),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          Text(
            "Point 15 pts",
            style: TextStyle(fontSize: 12, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
