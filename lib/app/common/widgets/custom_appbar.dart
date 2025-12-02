// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/modules/profile/controllers/profile_controller.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onSearchTap;
  final VoidCallback? onProfileTap;
  final String? logoSvg;
  final ValueChanged<String>? onSearchChanged;
  final TextEditingController? controller;

  const CustomAppBar({
    super.key,
    this.onSearchTap,
    this.onProfileTap,
    this.onSearchChanged,
    this.controller,
    this.logoSvg,
  });

  @override
  Size get preferredSize => const Size.fromHeight(90);

  @override
  Widget build(BuildContext context) {
    ProfileController profileController = Get.find();
    return Container(
      height: 125,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF3B2B27),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              (logoSvg != null && logoSvg!.isNotEmpty)
                  ? Container(
                      height: 46,
                      width: 46,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFC107),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AppAssetUtils.svg(
                          logoSvg!,
                          width: 50,
                          height: 50,
                          color: Colors.black,
                        ),
                      ),
                    )
                  : AppAssetUtils.svg(
                      AppAssets.logoIcon,
                      width: 50,
                      height: 50,
                    ),

              // === SEARCH BOX ===
              Expanded(
                child: Container(
                  height: 46, // sedikit lebih kecil biar proporsional
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFC107),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextField(
                    controller: controller,
                    onChanged: onSearchChanged,
                    onTap: onSearchTap,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      height: 1.2,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      hintText: "Search here ...",
                      hintStyle: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 24),
                        child: AppAssetUtils.svg(
                          AppAssets.searchIcon,
                          width: 18,
                          height: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // === PROFILE AVATAR ===
              GestureDetector(
                onTap: onProfileTap,
                child: CircleAvatar(
                  radius: 22,
                  backgroundImage:
                      (profileController.dataProfile.value!.picture.isNotEmpty)
                      ? NetworkImage(
                          "$BASE_URL${profileController.dataProfile.value!.picture}",
                        )
                      : AssetImage(AppAssets.profileIcon),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
