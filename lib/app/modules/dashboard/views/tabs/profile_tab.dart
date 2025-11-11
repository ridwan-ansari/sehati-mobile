import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/widgets/app_button.dart';
import 'package:sehati/app/data/services/local_storage_service.dart'
    show LocalStorageService;
import 'package:sehati/app/global_controllers/theme_controller.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 50)),
          const SizedBox(height: 16),
          const Text("Admin User", style: TextStyle(fontSize: 18)),
          const SizedBox(height: 24),
          AppButton(
            text: themeController.isDarkMode.value
                ? "Ubah ke Light Mode"
                : "Ubah ke Dark Mode",
            onPressed: () => themeController.toggleTheme(),
          ),
          const SizedBox(height: 16),
          AppButton(
            text: "Logout",
            onPressed: () {
              LocalStorageService.clearTokens();
              Get.offAllNamed('/login');
            },
          ),
        ],
      ),
    );
  }
}
