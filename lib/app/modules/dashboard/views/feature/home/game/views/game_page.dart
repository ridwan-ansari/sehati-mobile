// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/widgets/custom_appbar.dart';
import '../controllers/game_controller.dart';

class GamePage extends GetView<GameController> {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final games = [
      {
        "title": "Healthy Fruit Hunter",
        "desc": [
          "Deskripsi Game.....",
          "Deskripsi Game.....",
          "Deskripsi Game.....",
        ],
        "unlock": "100 points",
      },
      {
        "title": "Pokemon",
        "desc": [
          "Deskripsi Game.....",
          "Deskripsi Game.....",
          "Deskripsi Game.....",
        ],
        "unlock": "100 points",
      },
      {
        "title": "Math Quizes",
        "desc": [
          "Deskripsi Game.....",
          "Deskripsi Game.....",
          "Deskripsi Game.....",
        ],
        "unlock": "100 points",
      },
      {
        "title": "Meal creations",
        "desc": [
          "Deskripsi Game.....",
          "Deskripsi Game.....",
          "Deskripsi Game.....",
        ],
        "unlock": "100 points",
      },
    ];

    return Scaffold(
      appBar: CustomAppBar(
        logoSvg: AppAssets.gameIcon,
        onSearchChanged: (value) {},
        onProfileTap: () {},
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ======= Header =======
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.brown.shade700,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                "Play the games by exchange your point!",
                style: TextStyle(color: Colors.white, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 20),

            // ======= List of Games =======
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: games.length,
              itemBuilder: (context, index) {
                final game = games[index];
                return _buildGameCard(game);
              },
            ),
          ],
        ),
      ),
    );
  }

  // ======= Game Card Widget =======
  Widget _buildGameCard(Map<String, dynamic> game) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE082),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tombol PLAY
          Column(
            children: [
              Container(
                width: 80,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.pinkAccent.shade100,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.deepPurple.shade700, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      offset: const Offset(0, 3),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.lock, color: Colors.deepPurple, size: 18),
                    SizedBox(width: 4),
                    Text(
                      "PLAY",
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Unlock: ${game["unlock"]}",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black87,
                ),
              ),
            ],
          ),

          const SizedBox(width: 12),

          // Informasi game
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.orangeAccent, Colors.deepOrangeAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    game["title"],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 6),

                // Deskripsi
                ...game["desc"]
                    .map<Widget>(
                      (d) => Text(
                        d,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                    )
                    .toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
