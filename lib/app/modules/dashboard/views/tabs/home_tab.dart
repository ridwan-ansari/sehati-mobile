// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/utils/formatter.dart';
import 'package:sehati/app/routes/app_routes.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/leaderboard/controller/leaderboard_controller.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {

  @override
  Widget build(BuildContext context) {
    final LeaderboardController leader = Get.find();


    print("---------------------------------");

    return SafeArea(
      child: RefreshIndicator(
        color: AppColors.orangeLight,
        onRefresh: () => leader.fetchLeaderboard(),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 192,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.orangeLight,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x19000000),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                    image: DecorationImage(image: AssetImage(AppAssets.bgCard)),
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [AppColors.orangeLight, AppColors.yellowLight],
                    ),
                  ),
                  child: Column(
                    children: [
                      AppAssetUtils.svg(
                        AppAssets.logoSehati,
                        width: 76,
                        height: 76,
                      ),
                      const SizedBox(height: 10),
                      Obx(() {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3B2B27),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: _buildStatItem(
                                  icon: AppAssets.coinsIcon,
                                  label: "Points",
                                  value: "${leader.myAchievement}",
                                ),
                              ),
                              Expanded(
                                child: _buildStatItem(
                                  icon: AppAssets.saldoIcon,
                                  label: "Saldo",
                                  value: Formatter.compactNumber(
                                    leader.mySaldo,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () =>
                                      Get.toNamed(AppRoutes.LEADERBOARD),
                                  child: _buildStatItem(
                                    icon: AppAssets.rankIcon,
                                    label: "Rank",
                                    value: leader.userRank == -1
                                        ? "-"
                                        : "#${leader.userRank}",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Notification & Recent Update!",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                      AppAssetUtils.svg(
                        AppAssets.menuIcon,
                        width: 24,
                        height: 24,
                      ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Features",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed('/menu_feature'),
                      child: AppAssetUtils.svg(
                        AppAssets.menuIcon,
                        width: 24,
                        height: 24,
                        color: const Color(0xFF3B2B27),
                      ),
                    ),
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
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Playing Games",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    AppAssetUtils.svg(
                      AppAssets.menuIcon,
                      width: 24,
                      height: 24,
                      color: const Color(0xFF3B2B27),
                    ),
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
      ),
    );
  }

  Widget _buildStatItem({
    required String icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 36.0,
          height: 36.0,
          decoration: BoxDecoration(
            color: AppColors.yellowLight,
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: AppAssetUtils.svg(icon, color: AppColors.black),
          ),
        ),
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
          AppAssetUtils.svg(AppAssets.gameIcon, height: 80, width: 100),
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
