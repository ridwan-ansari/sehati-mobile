import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/menu/controller/menu_cotroller.dart';

class MenuPage extends GetView<MenuCotroller> {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Menu"),
        actions: const [],
        backgroundColor: AppColors.gold,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                mainAxisSpacing: 20,
                crossAxisSpacing: 10,
                childAspectRatio: 0.75,
                children: [
                  _buildFeatureItem(
                    AppAssets.monitoringIcon,
                    "Self\nmonitoring",
                    onTap: () => Get.toNamed('/monitoring'),
                  ),
                  _buildFeatureItem(
                    AppAssets.appointmentIcon,
                    "Appointment",
                    onTap: () => Get.toNamed('/appointment'),
                  ),
                  _buildFeatureItem(
                    AppAssets.tvIcon,
                    "Video\nEdutainment",
                    onTap: () => Get.toNamed('/edutainment'),
                  ),
                  _buildFeatureItem(
                    AppAssets.gameIcon,
                    "Game",
                    onTap: () => Get.toNamed('/game'),
                  ),
                  _buildFeatureItem(
                    AppAssets.dayliIcon,
                    "Daily\nJournal",
                    onTap: () => Get.toNamed('/journal'),
                  ),
                  _buildFeatureItem(
                    AppAssets.chatIcon,
                    "Chatting",
                    onTap: () => Get.toNamed('/chatting'),
                  ),
                  _buildFeatureItem(
                    AppAssets.healthyMenuIcon,
                    "Healthy\nMenu",
                    onTap: () => Get.toNamed('/healthy_menu'),
                  ),
                  _buildFeatureItem(
                    AppAssets.riminderIcon,
                    "Reminder",
                    onTap: () => Get.toNamed('/reminder'),
                  ),
                  _buildFeatureItem(
                    AppAssets.sleepIcon,
                    "Sleep",
                    onTap: () => Get.toNamed('/sleep'),
                  ),
                  _buildFeatureItem(
                    AppAssets.giftBoxIcon,
                    "Merchandise",
                    onTap: () => Get.toNamed('/merchandise'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(
    String icon,
    String label, {
    void Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
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
}
