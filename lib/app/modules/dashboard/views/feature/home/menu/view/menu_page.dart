import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/animations/swing_animation.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/localization/app_strings.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:sehati/app/common/widgets/custom_appbar.dart';
import 'package:sehati/app/data/services/language_service.dart';
import 'package:sehati/app/common/utils/app_logger.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  static const List<Map<String, dynamic>> _features = [
    {'icon': AppAssets.monitoringIcon, 'labelKey': AppStrings.menuKeyMonitoring, 'route': '/monitoring', 'categoryKey': AppStrings.menuCatHealth, 'color': Color(0xFF4CAF50)},
    {'icon': AppAssets.appointmentIcon, 'labelKey': AppStrings.menuKeyAppointment, 'route': '/appointment', 'categoryKey': AppStrings.menuCatHealth, 'color': Color(0xFF2196F3)},
    {'icon': AppAssets.sleepIcon, 'labelKey': AppStrings.menuKeySleep, 'route': '/sleep', 'categoryKey': AppStrings.menuCatHealth, 'color': Color(0xFF5C6BC0)},
    {'icon': AppAssets.reminderIcon, 'labelKey': AppStrings.menuKeyReminder, 'route': '/reminder', 'categoryKey': AppStrings.menuCatHealth, 'color': Color(0xFFFF9800)},
    {'icon': AppAssets.tvIcon, 'labelKey': AppStrings.menuKeyEdutainment, 'route': '/edutainment', 'categoryKey': AppStrings.menuCatLearn, 'color': Color(0xFF9C27B0)},
    {'icon': AppAssets.gameIcon, 'labelKey': AppStrings.menuKeyGame, 'route': '/game', 'categoryKey': AppStrings.menuCatLearn, 'color': Color(0xFFFF5722)},
    {'icon': AppAssets.dailyIcon, 'labelKey': AppStrings.menuKeyDailyJournal, 'route': '/journal', 'categoryKey': AppStrings.menuCatLearn, 'color': Color(0xFF009688)},
    {'icon': AppAssets.healthyMenuIcon, 'labelKey': AppStrings.menuKeyRecipes, 'route': '/healthy_menu', 'categoryKey': AppStrings.menuCatNutrition, 'color': Color(0xFF8BC34A)},
    {'icon': AppAssets.chatIcon, 'labelKey': AppStrings.menuKeyChat, 'route': '/chatting', 'categoryKey': AppStrings.menuCatSocial, 'color': Color(0xFF3F51B5)},
    {'icon': AppAssets.giftBoxIcon, 'labelKey': AppStrings.menuKeyMerchandise, 'route': '/merchandise', 'categoryKey': AppStrings.menuCatRewards, 'color': Color(0xFFE91E63)},
  ];

  List<Map<String, dynamic>> get _filtered {
    if (_query.isEmpty) return _features;
    return _features
        .where((f) => AppStrings.get(f['labelKey'] as String).toLowerCase().contains(_query.toLowerCase()))
        .toList();
  }

  Map<String, List<Map<String, dynamic>>> get _grouped {
    final result = <String, List<Map<String, dynamic>>>{};
    for (final f in _filtered) {
      final cat = f['categoryKey'] as String;
      result.putIfAbsent(cat, () => []).add(f);
    }
    return result;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      Get.find<LanguageService>().currentLanguage.value;
      final grouped = _grouped;

      return Scaffold(
        backgroundColor: AppColors.surface,
        appBar: CustomAppBar(
          title: AppStrings.get(AppStrings.menuKeyAllFeatures),
          controller: _searchController,
          onSearchChanged: (v) => setState(() => _query = v),
          showBackButton: true,
        ),
        body: grouped.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off_rounded, size: 64, color: Colors.grey.shade300),
                    const SizedBox(height: 16),
                    Text(
                      AppStrings.get(AppStrings.menuKeyNoFeatureFound),
                      style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
                itemCount: grouped.length,
                itemBuilder: (context, index) {
                  final entry = grouped.entries.elementAt(index);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _CategoryHeader(title: AppStrings.get(entry.key)),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final width = constraints.maxWidth;
                          int crossAxisCount = (width / 85).floor();
                          if (crossAxisCount < 2) crossAxisCount = 2;
                          return GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: crossAxisCount,
                            mainAxisSpacing: MediaQuery.of(context).size.height * 0.02,
                            crossAxisSpacing: MediaQuery.of(context).size.width * 0.03,
                            childAspectRatio: 0.75,
                            children: entry.value
                                .map(
                                  (f) => AnimatedIn(
                                    child: _FeatureItem(
                                      icon: f['icon']!,
                                      label: AppStrings.get(f['labelKey']!),
                                      color: f['color'] as Color,
                                      shouldAnimate: f['icon'] == AppAssets.reminderIcon,
                                      onTap: () {
                                        AppLogger.log("💎 MenuPage: Navigating to ${f['route']}");
                                        Get.toNamed(f['route']!);
                                      },
                                    ),
                                  ),
                                )
                                .toList(),
                          );
                        },
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    ],
                  );
                },
              ),
      );
    });
  }
}

class _CategoryHeader extends StatelessWidget {
  const _CategoryHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
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
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
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
          const SizedBox(height: 8),
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
