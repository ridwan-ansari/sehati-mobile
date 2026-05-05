import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/localization/app_strings.dart';
import 'package:sehati/app/common/widgets/app_error_widget.dart';
import 'package:sehati/app/common/widgets/custom_appbar.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/data/models/response/game_model.dart';
import '../controllers/game_controller.dart';

class GamePage extends GetView<GameController> {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: CustomAppBar(
        logoSvg: AppAssets.gameIcon,
        title: AppStrings.get(AppStrings.menuKeyGame),
        onSearchChanged: (value) {},
        showBackButton: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.orangeLight));
        }
        if (controller.errorMessage.isNotEmpty) {
          return AppErrorWidget(
            message: controller.errorMessage.value,
            onRetry: controller.fetchGames,
          );
        }
        if (controller.games.isEmpty) {
          return Center(
            child: Text(
              AppStrings.get(AppStrings.menuKeyNoGamesYet),
              style: const TextStyle(color: Colors.black45, fontWeight: FontWeight.w600),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: controller.games.length,
          itemBuilder: (context, index) {
            final game = controller.games[index];
            return _buildGameCard(game);
          },
        );
      }),
    );
  }

  Widget _buildGameCard(GameModel game) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: game.isClaim ? () => controller.onGameTap(game.id) : null,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: '$BASE_URL${game.imageUrl}',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(color: Colors.grey[100]),
                        errorWidget: (_, __, ___) => Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey[100],
                          child: const Icon(Icons.videogame_asset_rounded, color: Colors.grey),
                        ),
                      ),
                      if (game.isClaim)
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                            child: const Icon(Icons.check, color: Colors.white, size: 10),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        game.name,
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.textDark),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        game.description,
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.4),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.amber.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.stars_rounded, size: 14, color: Colors.amber),
                                const SizedBox(width: 4),
                                Text(
                                  "${game.pricePoints} pts",
                                  style: const TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.w800),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            height: 36,
                            child: ElevatedButton(
                              onPressed: game.isClaim
                                  ? () => controller.onGameTap(game.id)
                                  : () => controller.claimGame(game.id),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: game.isClaim ? Colors.green : AppColors.orangeLight,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              child: Text(
                                game.isClaim ? AppStrings.get(AppStrings.commonKeyPlay) : AppStrings.get(AppStrings.commonKeyClaim),
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                              ),
                            ),
                          ),
                        ],
                      ),
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
}
