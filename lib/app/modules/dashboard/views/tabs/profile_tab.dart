import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/localization/app_strings.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:sehati/app/common/widgets/custom_appbar.dart';
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
      appBar: CustomAppBar(
        showBackButton: true,
        showProfile: false,
        onBack: () => Get.find<DashboardController>().changeTab(0),
      ),
      body: Obx(() {
        final profile = controller.dataProfile.value;

        return RefreshIndicator(
          color: AppColors.orangeLight,
          onRefresh: () => controller.loadProfile(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              children: [
                _buildProfileHeader(profile),
                const SizedBox(height: 32),
                _buildInfoSection(profile),
                const SizedBox(height: 24),
                _buildSettingsSection(context),
                const SizedBox(height: 32),
                _buildLogoutButton(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildProfileHeader(profile) {
    return Column(
      children: [
        AnimatedIn(
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.orangeLight.withValues(alpha: 0.2), width: 3),
            ),
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: (profile != null && profile.picture.isNotEmpty)
                  ? CachedNetworkImageProvider('$BASE_URL${profile.picture}')
                  : null,
              child: (profile == null || profile.picture.isEmpty)
                  ? const Icon(Icons.person, size: 60, color: Colors.grey)
                  : null,
            ),
          ),
        ),
        const SizedBox(height: 16),
        AnimatedIn(
          child: Text(
            profile?.fullname ?? '-',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.textDark),
          ),
        ),
        const SizedBox(height: 4),
        AnimatedIn(
          child: Text(
            profile?.email ?? '-',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection(profile) {
    return Container(
      padding: const EdgeInsets.all(20),
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
          const SizedBox(height: 20),
          _buildDetailRow(AppStrings.get(AppStrings.profileKeyNickname), profile?.nickname ?? '-', AppAssets.profileIcon, Colors.blue),
          _buildDivider(),
          _buildDetailRow(AppStrings.get(AppStrings.profileKeyPhone), profile?.phoneNumber ?? '-', AppAssets.phoneIcon, Colors.green),
          _buildDivider(),
          _buildDetailRow(AppStrings.get(AppStrings.profileKeyGenderLabel), profile?.gender ?? '-', AppAssets.genderIcon, Colors.purple),
          _buildDivider(),
          _buildDetailRow(AppStrings.get(AppStrings.profileKeyDateOfBirth), profile?.dateOfBirth ?? '-', AppAssets.dateIcon, Colors.orange),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
          _buildSectionTitle(AppStrings.get(AppStrings.profileKeySettings)),
          const SizedBox(height: 12),
          _buildMenuTile(
            icon: Icons.camera_alt_rounded,
            color: AppColors.orangeLight,
            text: AppStrings.get(AppStrings.profileKeyChangePhoto),
            onTap: () => showDialog(context: context, builder: (_) => ChangePhotoDialog(controller: controller)),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: () async {
          await NotificationService.cancelAll();
          await LocalStorageService.clearTokens();
          Get.offAllNamed('/welcome');
        },
        icon: const Icon(Icons.logout_rounded, size: 20),
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

  Widget _buildDetailRow(String label, String value, String iconPath, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: AppAssetUtils.svg(iconPath, width: 22, height: 22, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(value.isEmpty ? '-' : value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile({required IconData icon, required Color color, required String text, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 16),
            Expanded(child: Text(text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark))),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() => Divider(height: 24, thickness: 1, color: Colors.grey.shade100);
}
