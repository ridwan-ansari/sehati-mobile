import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:sehati/app/common/utils/formatter.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/leaderboard/controller/leaderboard_controller.dart';

class LeaderboardView extends StatefulWidget {
  const LeaderboardView({super.key});

  @override
  State<LeaderboardView> createState() => _LeaderboardViewState();
}

class _LeaderboardViewState extends State<LeaderboardView> {
  late final LeaderboardController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<LeaderboardController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.startOpenPage();
    });
  }

  String _ordinalSuffix(int number) {
    if (number >= 11 && number <= 13) return '${number}th';
    switch (number % 10) {
      case 1:
        return '${number}st';
      case 2:
        return '${number}nd';
      case 3:
        return '${number}rd';
      default:
        return '${number}th';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.yellowLight,
          appBar: AppBar(
            backgroundColor: AppColors.richBrown,
            title: const Text(
              'Leaderboard',
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
              return const Center(child: Text('No data available.'));
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
                    child: const AnimatedIn(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Rank',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Name',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Points',
                              textAlign: TextAlign.right,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Balance',
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
                                    _ordinalSuffix(index + 1),
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
                                      const SizedBox(width: 4),
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

          return Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Lottie.asset(AppAssets.coinLottieAnimation),
            ),
          );
        }),
      ],
    );
  }
}
