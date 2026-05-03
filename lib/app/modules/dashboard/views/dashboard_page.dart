import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/localization/app_strings.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:sehati/app/data/services/language_service.dart';
import '../controllers/dashboard_controller.dart';
import 'tabs/home_tab.dart';
import 'tabs/schedule_tab.dart';
import 'tabs/forum_tab.dart';
import 'tabs/profile_tab.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomeTab(),
      const ForumTab(),
      const ScheduleTab(),
      const ProfileTab(),
    ];

    return Obx(
      () {
        Get.find<LanguageService>().currentLanguage.value;
        return PopScope(
        canPop: false,
        onPopInvoked: (pop) {
          if (pop) return;
          controller.onWillPop(context);
        },
        child: Scaffold(
          body: pages[controller.selectedIndex.value],
          bottomNavigationBar: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.richBrown,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  spreadRadius: 1,
                  blurRadius: 10,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: controller.selectedIndex.value,
                onTap: controller.changeTab,
                showUnselectedLabels: true,
                selectedItemColor: AppColors.gold,
                unselectedItemColor: Colors.white,
                selectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
                backgroundColor: Colors.transparent,
                items: [
                  BottomNavigationBarItem(
                    icon: AppAssetUtils.svg(
                      AppAssets.homeIcon,
                      width: 24,
                      height: 24,
                    ),
                    label: AppStrings.get(AppStrings.menuKeyHome),
                  ),
                  BottomNavigationBarItem(
                    icon: AppAssetUtils.svg(
                      AppAssets.forumIcon,
                      width: 32,
                      height: 32,
                      color: AppColors.gold,
                    ),
                    label: AppStrings.get(AppStrings.menuKeyCommunity),
                  ),
                  BottomNavigationBarItem(
                    icon: AppAssetUtils.svg(
                      AppAssets.scheduleIcon,
                      width: 24,
                      height: 24,
                    ),
                    label: AppStrings.get(AppStrings.menuKeySchedule),
                  ),
                  BottomNavigationBarItem(
                    icon: AppAssetUtils.svg(
                      AppAssets.profileIcon,
                      width: 24,
                      height: 24,
                    ),
                    label: AppStrings.get(AppStrings.menuKeyProfile),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      },
    );
  }
}
