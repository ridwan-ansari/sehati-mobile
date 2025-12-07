// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:sehati/app/common/utils/formatter.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/leaderboard/controller/leaderboard_controller.dart';

class LeaderboardView extends GetView<LeaderboardController> {
  const LeaderboardView({super.key});

  String ordinalNumber(int number) {
    if (number >= 11 && number <= 13) return "${number}th";
    switch (number % 10) {
      case 1:
        return "${number}st";
      case 2:
        return "${number}nd";
      case 3:
        return "${number}rd";
      default:
        return "${number}th";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (controller.init == false) {
      controller.init.value = true;
      controller.startOpenPage();
    }
    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xFFF8E36A),
          appBar: AppBar(
            backgroundColor: const Color(0xFF3E2E1A),
            title: const Text(
              "Leaderboard Rank",
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Obx(() {
            if (controller.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.gold),
              );
            }

            if (controller.leaderboardList.isEmpty) {
              return const Center(child: Text("No data available."));
            }

            final list = controller.leaderboardList;

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.black, width: 2),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: AnimatedIn(
                      child: const Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              "Rank",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Name",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Total Point",
                              textAlign: TextAlign.right,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Saldo",
                              textAlign: TextAlign.right,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: AnimatedIn(
                      child: ListView.separated(
                        itemCount: list.length,
                        separatorBuilder: (_, __) =>
                            const Divider(color: Colors.black26),
                        itemBuilder: (context, index) {
                          final item = list[index];
                          final isMe = item.nickname == controller.username.value;
                      
                          return Container(
                            decoration: BoxDecoration(
                              color: isMe
                                  ? Colors.white.withOpacity(0.5)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    ordinalNumber(index + 1),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: isMe
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    item.nickname,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: isMe
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    Formatter.compactNumber(
                                      item.achievementPoints,
                                    ),
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: isMe
                                          ? FontWeight.bold
                                          : FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      AppAssetUtils.svg(
                                        AppAssets.coinIcon,
                                        width: 16,
                                        color: AppColors.orangeLight,
                                      ),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        Formatter.compactNumber(
                                          item.creditPoints,
                                        ),
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: isMe
                                              ? FontWeight.bold
                                              : FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
        Obx(() {
          if (!controller.showLottie.value) return const SizedBox();

          return Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Lottie.asset(AppAssets.coinLottieAnimation),
            ),
          );
        }),
      ],
    );
  }
}
