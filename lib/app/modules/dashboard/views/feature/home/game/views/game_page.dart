// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/widgets/custom_appbar.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/data/models/response/game_model.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/game/widgets/gradien_game_label.dart';
import '../controllers/game_controller.dart';

class GamePage extends GetView<GameController> {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        logoSvg: AppAssets.gameIcon,
        onSearchChanged: (value) {},
        onProfileTap: () {},
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12.0),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.black,
              child: AnimatedIn(
                child: const Text(
                  "Play the games by exchange your point!",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Obx(
              () => ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.games.length,
                itemBuilder: (context, index) {
                  final game = controller.games[index];
                  return _buildGameCard(game);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameCard(GameModel game) {
    RxBool isExpanded = false.obs;

    return Obx(() {
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            color: Colors.grey.shade200,
                            child: Image.network(
                              "$BASE_URL${game.imageUrl}",
                              fit: BoxFit.cover,
                            ),
                          ),
                          if (game.isClaim)
                            Positioned(
                              top: 6,
                              right: 6,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: AnimatedIn(
                                  child: const Text(
                                    "Claimed",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),
                    SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        onPressed: game.isClaim
                            ? () => controller.onGameTap(game.id)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: game.isClaim
                              ? AppColors.orangeLight
                              : Colors.grey.shade400,
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: AnimatedIn(
                          child: const Text(
                            "Play",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GradienGameLabel(title: game.name, fontSize: 15),

                      const SizedBox(height: 6),

                      AnimatedIn(
                        child: AnimatedIn(
                          child: Text(
                            game.description,
                            maxLines: isExpanded.value ? 10 : 2,
                            overflow: isExpanded.value
                                ? TextOverflow.visible
                                : TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: Colors.black87,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () => isExpanded.value = !isExpanded.value,
                        child: Text(
                          isExpanded.value ? "Less" : "More",
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE082),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: AnimatedIn(
                          child: Text(
                            "Unlock: ${game.pricePoints} pts",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
