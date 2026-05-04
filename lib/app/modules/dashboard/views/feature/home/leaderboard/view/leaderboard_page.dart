// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/localization/app_strings.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:sehati/app/common/utils/formatter.dart';
import 'package:sehati/app/data/models/leaderboard_model.dart';
import 'package:sehati/app/data/services/language_service.dart';
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.surface,
          body: Obx(() {
            Get.find<LanguageService>().currentLanguage.value;

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildSliverAppBar(),
                if (controller.isLoading.value)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.gold),
                    ),
                  )
                else if (controller.leaderboardList.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _EmptyState(),
                  )
                else
                  ..._buildContent(),
              ],
            );
          }),
        ),
        Obx(() {
          if (!controller.showLottie.value) return const SizedBox();
          return Positioned.fill(
            child: IgnorePointer(
              child: Lottie.asset(AppAssets.coinLottieAnimation),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      backgroundColor: AppColors.richBrown,
      foregroundColor: Colors.white,
      pinned: true,
      expandedHeight: 0,
      elevation: 0,
      title: Text(
        AppStrings.get(AppStrings.leaderboardKeyTitle),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 18,
          letterSpacing: -0.3,
        ),
      ),
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  List<Widget> _buildContent() {
    final list = controller.leaderboardList;
    final top3 = list.take(3).toList();
    final rest = list.length > 3 ? list.sublist(3) : <LeaderboardModel>[];

    return [
      SliverToBoxAdapter(
        child: _PodiumSection(top3: top3, currentUser: controller.username.value),
      ),
      if (rest.isNotEmpty)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 18,
                  decoration: BoxDecoration(
                    color: AppColors.orangeLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  AppStrings.get(AppStrings.leaderboardKeyOtherPlayers),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final item = rest[index];
              final actualRank = index + 4;
              final isMe = item.nickname == controller.username.value;
              return AnimatedIn(
                child: _PlayerRow(
                  rank: actualRank,
                  player: item,
                  isMe: isMe,
                ),
              );
            },
            childCount: rest.length,
          ),
        ),
      ),
    ];
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.emoji_events_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            AppStrings.get(AppStrings.leaderboardKeyNoData),
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PodiumSection extends StatelessWidget {
  const _PodiumSection({required this.top3, required this.currentUser});

  final List<LeaderboardModel> top3;
  final String currentUser;

  @override
  Widget build(BuildContext context) {
    final first = top3.isNotEmpty ? top3[0] : null;
    final second = top3.length > 1 ? top3[1] : null;
    final third = top3.length > 2 ? top3[2] : null;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.richBrown, Color(0xFF5C3D2E)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.emoji_events_rounded, color: AppColors.gold, size: 22),
                const SizedBox(width: 8),
                Text(
                  AppStrings.get(AppStrings.leaderboardKeyTopPlayers),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: _PodiumPlace(
                    rank: 2,
                    player: second,
                    isMe: second?.nickname == currentUser,
                    barColor: const Color(0xFFB8B8C5),
                    medalColor: const Color(0xFFB8B8C5),
                    height: 110,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _PodiumPlace(
                    rank: 1,
                    player: first,
                    isMe: first?.nickname == currentUser,
                    barColor: AppColors.gold,
                    medalColor: AppColors.gold,
                    height: 150,
                    isCrown: true,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _PodiumPlace(
                    rank: 3,
                    player: third,
                    isMe: third?.nickname == currentUser,
                    barColor: const Color(0xFFCD7F32),
                    medalColor: const Color(0xFFCD7F32),
                    height: 80,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PodiumPlace extends StatelessWidget {
  const _PodiumPlace({
    required this.rank,
    required this.player,
    required this.isMe,
    required this.barColor,
    required this.medalColor,
    required this.height,
    this.isCrown = false,
  });

  final int rank;
  final LeaderboardModel? player;
  final bool isMe;
  final Color barColor;
  final Color medalColor;
  final double height;
  final bool isCrown;

  @override
  Widget build(BuildContext context) {
    if (player == null) {
      return SizedBox(height: height + 80);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isCrown)
          const Padding(
            padding: EdgeInsets.only(bottom: 4),
            child: Icon(
              Icons.workspace_premium_rounded,
              color: AppColors.gold,
              size: 28,
            ),
          ),
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [medalColor, medalColor.withOpacity(0.6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: medalColor.withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: _Avatar(
                nickname: player!.nickname,
                size: rank == 1 ? 60 : 50,
              ),
            ),
            Positioned(
              bottom: -6,
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: medalColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.richBrown, width: 2),
                ),
                child: Center(
                  child: Text(
                    '$rank',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          player!.nickname,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontWeight: isMe ? FontWeight.w800 : FontWeight.w700,
            fontSize: rank == 1 ? 14 : 13,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star_rounded, color: AppColors.gold, size: 12),
              const SizedBox(width: 3),
              Text(
                Formatter.compactNumber(player!.achievementPoints),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [barColor, barColor.withOpacity(0.7)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: Center(
            child: Text(
              '$rank',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.w900,
                fontSize: rank == 1 ? 36 : 28,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.icon,
    required this.color,
    required this.value,
  });

  final IconData icon;
  final Color color;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _CoinPill extends StatelessWidget {
  const _CoinPill({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.orangeLight.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppAssetUtils.svg(
            AppAssets.coinIcon,
            width: 14,
            height: 14,
            color: AppColors.orangeLight,
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.orangeLight,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayerRow extends StatelessWidget {
  const _PlayerRow({
    required this.rank,
    required this.player,
    required this.isMe,
  });

  final int rank;
  final LeaderboardModel player;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isMe ? AppColors.orangeLight.withOpacity(0.08) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isMe ? AppColors.orangeLight.withOpacity(0.4) : Colors.grey.shade100,
          width: isMe ? 1.5 : 1,
        ),
        boxShadow: isMe
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Text(
              '#$rank',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: isMe ? AppColors.orangeLight : Colors.grey.shade500,
              ),
            ),
          ),
          _Avatar(nickname: player.nickname, size: 38),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              player.nickname,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isMe ? FontWeight.w800 : FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
          ),
          _StatPill(
            icon: Icons.star_rounded,
            color: AppColors.gold,
            value: Formatter.compactNumber(player.achievementPoints),
          ),
          const SizedBox(width: 6),
          _CoinPill(value: Formatter.compactNumber(player.creditPoints)),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.nickname, this.size = 40});

  final String nickname;
  final double size;

  Color _colorFromName(String name) {
    if (name.isEmpty) return Colors.grey;
    const palette = [
      Color(0xFF4CAF50),
      Color(0xFF2196F3),
      Color(0xFF9C27B0),
      Color(0xFFFF5722),
      Color(0xFF009688),
      Color(0xFF3F51B5),
      Color(0xFF8BC34A),
      Color(0xFFE91E63),
      Color(0xFF5C6BC0),
      Color(0xFFFF9800),
    ];
    int hash = 0;
    for (var i = 0; i < name.length; i++) {
      hash = name.codeUnitAt(i) + ((hash << 5) - hash);
    }
    return palette[hash.abs() % palette.length];
  }

  @override
  Widget build(BuildContext context) {
    final color = _colorFromName(nickname);
    final initial = nickname.isNotEmpty ? nickname[0].toUpperCase() : '?';

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: size * 0.42,
          ),
        ),
      ),
    );
  }
}
