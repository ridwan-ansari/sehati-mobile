import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../routes/app_routes.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    _checkLogin();
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFD84E), Color(0xFFFF9A3D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: AppAssetUtils.svg(AppAssets.logoSehati, width: 260),
          ),
        ),
      ),
    );
  }

  Future<void> _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    await Future.delayed(const Duration(seconds: 2));
    if (token != null && token.isNotEmpty) {
      Get.offAllNamed(AppRoutes.DASHBOARD);
    } else {
      Get.offAllNamed(AppRoutes.LOGIN);
    }
  }
}
