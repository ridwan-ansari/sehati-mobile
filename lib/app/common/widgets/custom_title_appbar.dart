// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';

class CustomTitleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackTap;
  final VoidCallback? onActionTap;
  final String? actionIconSvg;
  final bool centerTitle;

  const CustomTitleAppBar({
    super.key,
    required this.title,
    this.onBackTap,
    this.onActionTap,
    this.actionIconSvg,
    this.centerTitle = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(90);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF3B2B27),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // === BACK BUTTON (opsional) ===
            if (onBackTap != null)
              GestureDetector(
                onTap: onBackTap,
                child: AppAssetUtils.svg(
                  AppAssets.arrowRightCircle,
                  width: 24,
                  height: 24,
                  color: Colors.white,
                ),
              )
            else
              const SizedBox(width: 24),

            // === TITLE ===
            Expanded(
              child: Text(
                title,
                textAlign: centerTitle ? TextAlign.center : TextAlign.start,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // === ACTION ICON (opsional) ===
            if (actionIconSvg != null)
              GestureDetector(
                onTap: onActionTap,
                child: AppAssetUtils.svg(
                  actionIconSvg!,
                  width: 24,
                  height: 24,
                  color: Colors.white,
                ),
              )
            else
              const SizedBox(width: 24),
          ],
        ),
      ),
    );
  }
}
