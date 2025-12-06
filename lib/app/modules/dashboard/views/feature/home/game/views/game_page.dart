// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
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
              child: const Text(
                "Play the games by exchange your point!",
                style: TextStyle(color: Colors.white, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 20),

            // ======= List of Games =======
            Obx(
              () => ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.games.length,
                itemBuilder: (context, index) {
                  final game = controller.games[index];
                  print("id : ${game.id}");
                  return _buildGameCard(game);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ======= Game Card Widget =======
  Widget _buildGameCard(GameModel game) {
    return GestureDetector(
      onTap: () {
        controller.onGameTap(game.id);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFFE082),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  height: 100.0,
                  width: 100.0,
                  decoration:  BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        "$BASE_URL${game.imageUrl}",
                      ),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Unlock: ${game.pricePoints} pts",
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GradienGameLabel(title: game.name, fontSize: 14),
                  const SizedBox(height: 6),
                  Text(
                    game.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: const TextStyle(fontSize: 12, color: Colors.black87 , ),
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
