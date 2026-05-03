import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/localization/app_strings.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:sehati/app/data/services/language_service.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  static const List<Map<String, String>> _features = [
    {'icon': AppAssets.monitoringIcon, 'labelKey': AppStrings.menuKeyMonitoring, 'route': '/monitoring', 'categoryKey': AppStrings.menuCatHealth},
    {'icon': AppAssets.appointmentIcon, 'labelKey': AppStrings.menuKeyAppointment, 'route': '/appointment', 'categoryKey': AppStrings.menuCatHealth},
    {'icon': AppAssets.sleepIcon, 'labelKey': AppStrings.menuKeySleep, 'route': '/sleep', 'categoryKey': AppStrings.menuCatHealth},
    {'icon': AppAssets.reminderIcon, 'labelKey': AppStrings.menuKeyReminder, 'route': '/reminder', 'categoryKey': AppStrings.menuCatHealth},
    {'icon': AppAssets.tvIcon, 'labelKey': AppStrings.menuKeyEdutainment, 'route': '/edutainment', 'categoryKey': AppStrings.menuCatLearn},
    {'icon': AppAssets.gameIcon, 'labelKey': AppStrings.menuKeyGame, 'route': '/game', 'categoryKey': AppStrings.menuCatLearn},
    {'icon': AppAssets.dailyIcon, 'labelKey': AppStrings.menuKeyDailyJournal, 'route': '/journal', 'categoryKey': AppStrings.menuCatLearn},
    {'icon': AppAssets.healthyMenuIcon, 'labelKey': AppStrings.menuKeyRecipes, 'route': '/healthy_menu', 'categoryKey': AppStrings.menuCatNutrition},
    {'icon': AppAssets.chatIcon, 'labelKey': AppStrings.menuKeyChat, 'route': '/chatting', 'categoryKey': AppStrings.menuCatSocial},
    {'icon': AppAssets.giftBoxIcon, 'labelKey': AppStrings.menuKeyMerchandise, 'route': '/merchandise', 'categoryKey': AppStrings.menuCatRewards},
  ];

  List<Map<String, String>> get _filtered {
    if (_query.isEmpty) return _features;
    return _features
        .where((f) => AppStrings.get(f['labelKey']!).toLowerCase().contains(_query.toLowerCase()))
        .toList();
  }

  Map<String, List<Map<String, String>>> get _grouped {
    final result = <String, List<Map<String, String>>>{};
    for (final f in _filtered) {
      result.putIfAbsent(f['categoryKey']!, () => []).add(f);
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
        appBar: AppBar(
          title: Text(AppStrings.get(AppStrings.menuKeyAllFeatures)),
          backgroundColor: AppColors.gold,
          foregroundColor: AppColors.textDark,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                controller: _searchController,
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: AppStrings.get(AppStrings.menuKeySearchFeatures),
                  prefixIcon: const Icon(Icons.search, color: Colors.black54),
                  suffixIcon: _query.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.black54),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _query = '');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: AppColors.orangeLight, width: 1.5),
                  ),
                ),
              ),
            ),
            Expanded(
              child: grouped.isEmpty
                  ? Center(
                      child: Text(
                        AppStrings.get(AppStrings.menuKeyNoFeatureFound),
                        style: const TextStyle(color: Colors.black54),
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: grouped.entries.map((entry) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _CategoryHeader(title: AppStrings.get(entry.key)),
                              const SizedBox(height: 8),
                              GridView.count(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: 4,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 10,
                                childAspectRatio: 0.75,
                                children: entry.value
                                    .map(
                                      (f) => AnimatedIn(
                                        child: _FeatureItem(
                                          icon: f['icon']!,
                                          label: AppStrings.get(f['labelKey']!),
                                          onTap: () => Get.toNamed(f['route']!),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                              const SizedBox(height: 16),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
            ),
          ],
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
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
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
    this.onTap,
  });

  final String icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.richBrown,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: AppAssetUtils.svg(
                icon,
                width: 28,
                height: 28,
                color: AppColors.yellowLight,
              ),
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
