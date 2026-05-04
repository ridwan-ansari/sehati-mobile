import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/animations/swing_animation.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:sehati/app/common/utils/formatter.dart';
import 'package:sehati/app/common/widgets/app_error_widget.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/data/models/response/game_model.dart';
import 'package:sehati/app/common/localization/app_strings.dart';
import 'package:sehati/app/data/services/language_service.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/game/controllers/game_controller.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/leaderboard/controller/leaderboard_controller.dart';
import 'package:sehati/app/routes/app_routes.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final LeaderboardController leader = Get.find<LeaderboardController>();
    final GameController gameController = Get.find<GameController>();

    return Obx(() {
      return SafeArea(
        child: RefreshIndicator(
          color: AppColors.orangeLight,
          onRefresh: () => leader.fetchLeaderboard(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeroSection(leader: leader),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _NotificationBanner(leader: leader),
                      const SizedBox(height: 24),
                      _SectionHeader(
                        title: AppStrings.get(AppStrings.menuKeyFeatures),
                        actionLabel: AppStrings.get(AppStrings.menuKeySeeAll),
                        onAction: () => Get.toNamed('/menu_feature')
                            ?.then((_) => leader.onInit()),
                      ),
                      const SizedBox(height: 14),
                      _FeatureGrid(leader: leader),
                      const SizedBox(height: 24),
                      _SectionHeader(
                        title: AppStrings.get(AppStrings.menuKeyGames),
                        actionLabel: AppStrings.get(AppStrings.menuKeyAllGames),
                        onAction: () => Get.toNamed('/game')
                            ?.then((_) => leader.onInit()),
                      ),
                      const SizedBox(height: 14),
                    ],
                  ),
                ),
              SizedBox(
                height: 220,
                child: Obx(
                  () => gameController.errorMessage.isNotEmpty
                      ? AppErrorWidget(
                          message: gameController.errorMessage.value,
                          onRetry: gameController.fetchGames,
                        )
                      : gameController.games.isEmpty
                          ? Center(
                              child: Text(
                                AppStrings.get(AppStrings.menuKeyNoGamesYet),
                                style: const TextStyle(color: Colors.black54),
                              ),
                            )
                          : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                          itemCount: gameController.games.length,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            final game = gameController.games[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 14),
                              child: _GameCard(
                                game: game,
                                onTap: game.isClaim
                                    ? () => gameController.onGameTap(game.id)
                                    : () => gameController.claimGame(game.id),
                              ),
                            );
                          },
                        ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      );
    });
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.leader});

  final LeaderboardController leader;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.richBrown, Color(0xFF5C3D2E)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppAssetUtils.svg(AppAssets.logoSehati, width: 54, height: 54),
              Obx(() => _RankBadge(rank: leader.userRank)),
            ],
          ),
          const SizedBox(height: 16),
          Obx(
            () {
              final langService = Get.find<LanguageService>();
              final isEn = langService.isEnglish();
              return AnimatedIn(
                child: Text(
                  leader.username.value.isNotEmpty
                      ? isEn
                          ? 'Hello, ${leader.username.value}! 👋'
                          : 'Halo, ${leader.username.value}! 👋'
                      : isEn
                          ? 'Welcome back! 👋'
                          : 'Selamat kembali! 👋',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 4),
          Obx(
            () {
              final langService = Get.find<LanguageService>();
              return Text(
                langService.isEnglish()
                    ? 'Keep track of your health today.'
                    : 'Pantau kesehatan Anda hari ini.',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          _StatsRow(leader: leader),
          Obx(() {
            if (leader.errorMessage.isEmpty) return const SizedBox.shrink();
            final langService = Get.find<LanguageService>();
            final isEn = langService.isEnglish();
            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 13,
                    color: Colors.orange.shade200,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      isEn ? 'Could not refresh data' : 'Gagal memperbarui data',
                      style: const TextStyle(color: Colors.white60, fontSize: 11),
                    ),
                  ),
                  GestureDetector(
                    onTap: leader.fetchLeaderboard,
                    child: Text(
                      isEn ? 'Retry' : 'Coba Lagi',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _RankBadge extends StatelessWidget {
  const _RankBadge({required this.rank});

  final int rank;

  @override
  Widget build(BuildContext context) {
    if (rank == -1) return const SizedBox.shrink();
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.LEADERBOARD),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.gold,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_events, size: 16, color: AppColors.richBrown),
            const SizedBox(width: 4),
            Text(
              'Rank #$rank',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.richBrown,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.leader});

  final LeaderboardController leader;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Obx(() => _StatCard(
            icon: Icons.star_rounded,
            iconColor: AppColors.gold,
            label: AppStrings.get(AppStrings.menuKeyPoints),
            value: '${leader.myAchievement}',
          )),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Obx(() => _StatCard(
            icon: Icons.account_balance_wallet_rounded,
            iconColor: Colors.greenAccent,
            label: AppStrings.get(AppStrings.menuKeyBalance),
            value: Formatter.compactNumber(leader.mySaldo),
          )),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.LEADERBOARD),
            child: Obx(() => _StatCard(
              icon: Icons.leaderboard_rounded,
              iconColor: Colors.lightBlueAccent,
              label: AppStrings.get(AppStrings.menuKeyRank),
              value: leader.userRank == -1 ? '-' : '#${leader.userRank}',
            )),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 18,
              decoration: BoxDecoration(
                color: AppColors.orangeLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
        if (onAction != null && actionLabel != null)
          GestureDetector(
            onTap: onAction,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.orangeLight.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                actionLabel!,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.orangeLight,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _NotificationBanner extends StatelessWidget {
  const _NotificationBanner({required this.leader});

  final LeaderboardController leader;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final msg = leader.dashboardNotif.value;
      if (msg.isEmpty) return const SizedBox.shrink();
      return AnimatedIn(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.gold.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.gold, width: 1),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.campaign_rounded,
                color: AppColors.brownDark,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  msg,
                  style: const TextStyle(
                    color: AppColors.brownDark,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _FeatureGrid extends StatefulWidget {
  const _FeatureGrid({required this.leader});

  final LeaderboardController leader;

  @override
  State<_FeatureGrid> createState() => _FeatureGridState();
}

class _FeatureGridState extends State<_FeatureGrid> {
  late TextEditingController _searchController;
  String _query = '';

  static const List<Map<String, dynamic>> _allFeatures = [
    {'icon': AppAssets.monitoringIcon, 'labelKey': AppStrings.menuKeyMonitoring, 'route': '/monitoring', 'color': Color(0xFF4CAF50)},
    {'icon': AppAssets.appointmentIcon, 'labelKey': AppStrings.menuKeyAppointment, 'route': '/appointment', 'color': Color(0xFF2196F3)},
    {'icon': AppAssets.tvIcon, 'labelKey': AppStrings.menuKeyEdutainment, 'route': '/edutainment', 'color': Color(0xFF9C27B0)},
    {'icon': AppAssets.gameIcon, 'labelKey': AppStrings.menuKeyGame, 'route': '/game', 'color': Color(0xFFFF5722)},
    {'icon': AppAssets.dailyIcon, 'labelKey': AppStrings.menuKeyJournal, 'route': '/journal', 'color': Color(0xFF009688)},
    {'icon': AppAssets.chatIcon, 'labelKey': AppStrings.menuKeyChat, 'route': '/chatting', 'color': Color(0xFF3F51B5)},
    {'icon': AppAssets.healthyMenuIcon, 'labelKey': AppStrings.menuKeyRecipes, 'route': '/healthy_menu', 'color': Color(0xFF8BC34A)},
    {'icon': AppAssets.reminderIcon, 'labelKey': AppStrings.menuKeyReminder, 'route': '/reminder', 'color': Color(0xFFFF9800)},
    {'icon': AppAssets.sleepIcon, 'labelKey': AppStrings.menuKeySleep, 'route': '/sleep', 'color': Color(0xFF5C6BC0)},
    {'icon': AppAssets.giftBoxIcon, 'labelKey': AppStrings.menuKeyMerchandise, 'route': '/merchandise', 'color': Color(0xFFE91E63)},
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() => _query = _searchController.text.toLowerCase());
  }

  List<Map<String, dynamic>> get _filteredFeatures {
    if (_query.isEmpty) return _allFeatures;
    return _allFeatures
        .where((f) => AppStrings.get(f['labelKey'] as String).toLowerCase().contains(_query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: AppStrings.get(AppStrings.menuKeySearchMenu),
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
                suffixIcon: _query.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          _onSearchChanged();
                        },
                        child: const Icon(Icons.close, color: Colors.grey, size: 20),
                      )
                    : null,
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          if (_filteredFeatures.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Text(
                  AppStrings.get(AppStrings.menuKeyNoMenuFound),
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ),
            )
        else
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            crossAxisCount: 4,
            mainAxisSpacing: 16,
            crossAxisSpacing: 12,
            childAspectRatio: 0.78,
            children: _filteredFeatures
                .map(
                  (f) => AnimatedIn(
                    child: _FeatureItem(
                      icon: f['icon'],
                      label: AppStrings.get(f['labelKey'] as String),
                      color: f['color'] as Color,
                      shouldAnimate: f['icon'] == AppAssets.reminderIcon,
                      onTap: () {
                        print("💎 HomeTab: Navigating to ${f['route']}");
                        Get.toNamed(f['route'] as String)
                          ?.then((_) => widget.leader.onInit());
                      },
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      );
    });
  }
}

class _FeatureItem extends StatelessWidget {
  const _FeatureItem({
    required this.icon,
    required this.label,
    required this.color,
    this.shouldAnimate = false,
    this.onTap,
  });

  final dynamic icon;
  final String label;
  final Color color;
  final bool shouldAnimate;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Widget iconWidget = icon is IconData
        ? Icon(icon as IconData, color: color, size: 26)
        : AppAssetUtils.svg(
            icon as String,
            width: 26,
            height: 26,
            color: color,
          );

    if (shouldAnimate) {
      iconWidget = SwingAnimation(child: iconWidget);
    }

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
            ),
            child: Center(
              child: iconWidget,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _GameCard extends StatelessWidget {
  const _GameCard({required this.game, required this.onTap});

  final GameModel game;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 148,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (game.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_URL${game.imageUrl}',
                  height: 110,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    height: 110,
                    color: Colors.grey.shade100,
                  ),
                  errorWidget: (_, __, ___) => Container(
                    height: 110,
                    color: Colors.grey.shade100,
                    alignment: Alignment.center,
                    child: const Icon(Icons.videogame_asset, size: 36, color: Colors.grey),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    game.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: AppColors.textDark,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.orangeLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${game.pricePoints} pts',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
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
