import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/localization/app_strings.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/data/services/local_storage_service.dart';
import 'package:sehati/app/modules/profile/controllers/profile_controller.dart';
import 'package:sehati/app/modules/profile/widgets/change_photo_dialog.dart';
import 'package:sehati/app/services/notification_service.dart';
import 'package:sehati/app/modules/dashboard/controllers/dashboard_controller.dart';

class ProfileTab extends GetView<ProfileController> {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ProfileController>()) {
      Get.lazyPut(() => ProfileController());
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Obx(() {
          final profile = controller.dataProfile.value;
  
          return RefreshIndicator(
            color: AppColors.orangeLight,
            onRefresh: () => controller.loadProfile(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                  vertical: MediaQuery.of(context).size.height * 0.03),
              child: Column(
                children: [
                  _buildProfileHeader(profile, context),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  _buildInfoSection(profile, context),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  _buildLogoutButton(context),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildProfileHeader(profile, BuildContext context) {
    return Column(
      children: [
        AnimatedIn(
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.orangeLight.withValues(alpha: 0.2), width: 3),
                ),
                child: CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 0.15,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: (profile != null && profile.picture.isNotEmpty)
                      ? CachedNetworkImageProvider('$BASE_URL${profile.picture}')
                      : null,
                  child: (profile == null || profile.picture.isEmpty)
                      ? Icon(Icons.person, size: MediaQuery.of(context).size.width * 0.15, color: Colors.grey)
                      : null,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => showDialog(
                    context: context,
                    builder: (_) => ChangePhotoDialog(controller: controller),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.orangeLight,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.edit_rounded, color: Colors.white, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          AppStrings.get(AppStrings.commonKeyEdit),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        AnimatedIn(
          child: Text(
            profile?.fullname ?? '-',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.textDark),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.005),
        AnimatedIn(
          child: Text(
            profile?.email ?? '-',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection(profile, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(AppStrings.get(AppStrings.profileKeyInfo)),
          SizedBox(height: MediaQuery.of(context).size.height * 0.025),
          _buildDetailRow(AppStrings.get(AppStrings.profileKeyNickname), profile?.nickname ?? '-', AppAssets.profileIcon, Colors.blue, context),
          _buildDivider(),
          _buildDetailRow(AppStrings.get(AppStrings.profileKeyPhone), profile?.phoneNumber ?? '-', AppAssets.phoneIcon, Colors.green, context),
          _buildDivider(),
          _buildDetailRow(AppStrings.get(AppStrings.profileKeyGenderLabel), profile?.gender ?? '-', AppAssets.genderIcon, Colors.purple, context),
          _buildDivider(),
          _buildDetailRow(AppStrings.get(AppStrings.profileKeyDateOfBirth), profile?.dateOfBirth ?? '-', AppAssets.dateIcon, Colors.orange, context),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.065,
      child: ElevatedButton.icon(
        onPressed: () async {
          await NotificationService.cancelAll();
          await LocalStorageService.clearTokens();
          Get.offAllNamed('/welcome');
        },
        icon: Icon(Icons.logout_rounded, size: MediaQuery.of(context).size.width * 0.05),
        label: Text(AppStrings.get(AppStrings.profileKeySignOut), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.richBrown,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Text(
    title,
    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.textDark),
  );

  Widget _buildDetailRow(String label, String value, String iconPath, Color iconColor, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.01),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.025),
            decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: AppAssetUtils.svg(iconPath, width: MediaQuery.of(context).size.width * 0.05, height: MediaQuery.of(context).size.width * 0.05, color: iconColor),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w700)),
                SizedBox(height: MediaQuery.of(context).size.height * 0.003),
                Text(value.isEmpty ? '-' : value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile({required IconData icon, required Color color, required String text, required VoidCallback onTap, required BuildContext context}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.015, horizontal: MediaQuery.of(context).size.width * 0.01),
        child: Row(
          children: [
            Icon(icon, color: color, size: MediaQuery.of(context).size.width * 0.06),
            SizedBox(width: MediaQuery.of(context).size.width * 0.04),
            Expanded(child: Text(text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark))),
            Icon(Icons.arrow_forward_ios_rounded, size: MediaQuery.of(context).size.width * 0.04, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() => Divider(height: 24, thickness: 1, color: Colors.grey.shade100);
}
