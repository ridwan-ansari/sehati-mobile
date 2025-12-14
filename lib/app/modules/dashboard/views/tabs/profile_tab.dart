// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/data/services/local_storage_service.dart';
import 'package:sehati/app/modules/profile/controllers/profile_controller.dart';
import 'package:sehati/app/modules/profile/widgets/change_photo_dialog.dart';
import 'package:sehati/app/services/notification_service.dart';

class ProfileTab extends GetView<ProfileController> {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ProfileController>()) {
      Get.lazyPut(() => ProfileController());
    }

    return Scaffold(
      body: Center(
        child: Obx(() {
          final profile = controller.dataProfile.value;

          return RefreshIndicator(
            color: AppColors.orangeLight,
            onRefresh: () => controller.loadProfile(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  const SizedBox(height: 56.0),
                  AnimatedIn(
                    child: CircleAvatar(
                      radius: 58,
                      backgroundColor: AppColors.orangeLight,
                      child: CircleAvatar(
                        radius: 56,
                        backgroundColor: Colors.grey.withOpacity(0.5),
                        backgroundImage:
                            (profile != null && profile.picture.isNotEmpty)
                            ? NetworkImage('$BASE_URL${profile.picture}')
                            : null,
                        child: (profile == null || profile.picture.isEmpty)
                            ? const Icon(Icons.person, size: 56)
                            : null,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  AnimatedIn(
                    child: Text(
                      profile?.fullname ?? "",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  AnimatedIn(
                    child: Text(
                      profile?.email ?? "",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  _buildInfoCard(profile),
                  const SizedBox(height: 12.0),
                  _buildSettingsCard(context),
                  const SizedBox(height: 12.0),
                  AnimatedIn(child: _buildLogoutButton()),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Card(
      child: _buildListTile(
        bgColor: Colors.blueGrey,
        icon: Icons.logout,
        color: Colors.white,
        text: 'Logout',
        textColor: Colors.white,
        onTap: () async {
          await NotificationService.cancelAll();
          await LocalStorageService.clearTokens();
          Get.offAllNamed('/splash');
          Get.offAllNamed('/login');
        },
      ),
    );
  }

  Widget _buildInfoCard(profile) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Information",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16.0),
            _textIconDetail(
              "Nickname",
              profile?.nickname ?? "",
              AppAssets.profileIcon,
            ),
            const SizedBox(height: 8.0),
            _textIconDetail(
              "Phone Number",
              profile?.phoneNumber ?? "",
              AppAssets.phoneIcon,
            ),
            const SizedBox(height: 8.0),
            _textIconDetail(
              "Gender",
              profile?.gender ?? "",
              AppAssets.genderIcon,
            ),
            const SizedBox(height: 8.0),
            _textIconDetail(
              "Date of Birth",
              profile?.dateOfBirth ?? "",
              AppAssets.dateIcon,
            ),
          ],
        ),
      ),
    );
  }

  Widget _textIconDetail(String text, String value, String iconPath) {
    return Row(
      children: [
        AppAssetUtils.svg(iconPath, width: 24, height: 24, color: Colors.black),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 4.0),
            AnimatedIn(
              child: Text(
                value.isEmpty ? '-' : value,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSettingsCard(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Settings",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          AnimatedIn(
            child: _buildListTile(
              bgColor: Colors.white,
              icon: Icons.person_pin,
              color: Colors.black,
              text: 'Change photo',
              textColor: Colors.black,
              onTap: () => showDialog(
                context: context,
                builder: (_) => ChangePhotoDialog(controller: controller),
              ),
            ),
          ),
          // const Divider(),
          // _buildListTile(
          //   bgColor: Colors.white,
          //   icon: Icons.password,
          //   color: Colors.black,
          //   text: 'Ubah Kata Sandi',
          //   textColor: Colors.black,
          //   onTap: () => Get.toNamed('/forgot_password'),
          // ),
        ],
      ),
    );
  }

  Widget _buildListTile({
    required Color bgColor,
    required IconData icon,
    required Color color,
    required String text,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Material(
        color: bgColor,
        child: InkWell(
          splashColor: Colors.orange.withOpacity(0.3),
          onTap: onTap,
          child: ListTile(
            leading: Icon(icon, color: color),
            title: Text(text, style: TextStyle(color: textColor, fontSize: 14)),
            trailing: Icon(Icons.arrow_forward_ios, size: 12, color: color),
          ),
        ),
      ),
    );
  }
}
