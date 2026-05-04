// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import '../localization/app_strings.dart' as locale;
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:sehati/app/common/utils/dialog_utils.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/modules/profile/controllers/profile_controller.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onSearchTap;
  final VoidCallback? onProfileTap;
  final String? logoSvg;
  final String? title;
  final ValueChanged<String>? onSearchChanged;
  final TextEditingController? controller;
  final bool showBackButton;
  final bool showProfile;
  final VoidCallback? onBack;

  const CustomAppBar({
    super.key,
    this.onSearchTap,
    this.onProfileTap,
    this.onSearchChanged,
    this.controller,
    this.logoSvg,
    this.title,
    this.showBackButton = true,
    this.showProfile = true,
    this.onBack,
  });

  @override
  Size get preferredSize {
    final bool hasTitle = title != null && title!.isNotEmpty;
    final bool hasSearch = controller != null || onSearchChanged != null;
    return Size.fromHeight(hasTitle && hasSearch ? 140 : 100);
  }

  @override
  Widget build(BuildContext context) {
    final profileController = Get.put(ProfileController(), permanent: true);
    final bool hasTitle = title != null && title!.isNotEmpty;
    final bool hasSearch = controller != null || onSearchChanged != null;
    final double appBarHeight = hasTitle && hasSearch ? 165 : 125;

    return Container(
      height: appBarHeight,
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
              if (showBackButton)
                IconButton(
                  onPressed: onBack ?? () => Get.back(),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                )
              else
                Tooltip(
                  message: 'Back to Home',
                  child: GestureDetector(
                    onTap: () => Get.offAllNamed('/dashboard'),
                    child: (logoSvg != null && logoSvg!.isNotEmpty)
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
                  ),
                ),
              if (hasTitle)
                Expanded(
                  child: Center(
                    child: Text(
                      title!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
              else if (hasSearch)
                Expanded(
                  child: _buildSearchField(),
                ),
              if (showProfile)
                Obx((() {
                  final profile = profileController.dataProfile.value;
                  return GestureDetector(
                    onTap:
                        onProfileTap ??
                        () {
                          DialogUtils.showCustomDialog(
                            context: context,
                            content: Container(
                              height: 192.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                    "$BASE_URL${profile?.picture}",
                                  ),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(12.0),
                                ),
                              ),
                            ),
                          );
                        },
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage:
                          (profile != null && profile.picture.isNotEmpty)
                          ? CachedNetworkImageProvider("$BASE_URL${profile.picture}")
                          : null,
                      child: (profile == null || profile.picture.isEmpty)
                          ? const Icon(Icons.person, color: Colors.grey)
                          : null,
                    ),
                  );
                }))
              else
                const SizedBox(width: 48), // Spacer to keep title centered
            ],
          ),
          if (hasTitle && hasSearch)
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 4),
              child: _buildSearchField(),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 46,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFC107),
        borderRadius: BorderRadius.circular(25),
      ),
      child: AnimatedIn(
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
            hintText: locale.AppStrings.get(locale.AppStrings.commonKeySearchPlaceholder),
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
    );
  }
}
