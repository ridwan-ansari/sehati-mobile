// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/localization/app_strings.dart';
import 'package:sehati/app/data/services/language_service.dart';
import '../controllers/dashboard_controller.dart';
import 'tabs/home_tab.dart';
import 'tabs/schedule_tab.dart';
import 'tabs/forum_tab.dart';
import 'tabs/profile_tab.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({super.key});

  static const List<_NavItem> _items = [
    _NavItem(
      activeIcon: Icons.home_rounded,
      inactiveIcon: Icons.home_outlined,
      labelKey: AppStrings.menuKeyHome,
    ),
    _NavItem(
      activeIcon: Icons.explore_rounded,
      inactiveIcon: Icons.explore_outlined,
      labelKey: AppStrings.menuKeyCommunity,
    ),
    _NavItem(
      activeIcon: Icons.calendar_month_rounded,
      inactiveIcon: Icons.calendar_month_outlined,
      labelKey: AppStrings.menuKeySchedule,
    ),
    _NavItem(
      activeIcon: Icons.person_rounded,
      inactiveIcon: Icons.person_outline_rounded,
      labelKey: AppStrings.menuKeyProfile,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomeTab(),
      const ForumTab(),
      const ScheduleTab(),
      const ProfileTab(),
    ];

    return Obx(() {
      Get.find<LanguageService>().currentLanguage.value;
      return PopScope(
        canPop: false,
        onPopInvoked: (pop) {
          if (pop) return;
          controller.onWillPop(context);
        },
        child: Scaffold(
          backgroundColor: AppColors.surface,
          extendBody: true,
          body: pages[controller.selectedIndex.value],
          bottomNavigationBar: _ModernNavBar(
            currentIndex: controller.selectedIndex.value,
            onTap: controller.changeTab,
            items: _items,
          ),
        ),
      );
    });
  }
}

class _NavItem {
  const _NavItem({
    required this.activeIcon,
    required this.inactiveIcon,
    required this.labelKey,
  });

  final IconData activeIcon;
  final IconData inactiveIcon;
  final String labelKey;
}

class _ModernNavBar extends StatelessWidget {
  const _ModernNavBar({
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<_NavItem> items;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.04,
          vertical: MediaQuery.of(context).size.height * 0.015,
        ),
        height: MediaQuery.of(context).size.height * 0.08,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.02,
            vertical: MediaQuery.of(context).size.height * 0.01,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(items.length, (i) {
              return Expanded(
                child: _NavBarItem(
                  item: items[i],
                  isActive: i == currentIndex,
                  onTap: () => onTap(i),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final label = AppStrings.get(item.labelKey);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, anim) =>
                ScaleTransition(scale: anim, child: child),
            child: Icon(
              isActive ? item.activeIcon : item.inactiveIcon,
              key: ValueKey<bool>(isActive),
              size: 24,
              color: isActive ? AppColors.orangeLight : Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isActive ? AppColors.orangeLight : Colors.grey.shade400,
              fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
              fontSize: 10,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}
