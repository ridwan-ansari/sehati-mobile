import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:sehati/app/data/services/auth_service.dart';
import 'package:sehati/app/data/services/local_storage_service.dart';
import '../routes/app_routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  final _authService = AuthService();

  Future<void> _checkLogin() async {
    final token = LocalStorageService.getAccessToken();
    print("token : $token");

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      if (token != null && token.isNotEmpty) {
        refreshToken();
        Get.offAllNamed(AppRoutes.DASHBOARD);
      } else {
        Get.offAllNamed(AppRoutes.LOGIN);
      }
    }
  }

  Future<void> refreshToken() async {
    final token = LocalStorageService.getRefreshToken();

    if (token == null) return;

    try {
      final newAccess = await _authService.refreshToken(refreshToken: token);
      if (newAccess != null) {
        LocalStorageService.setAccessToken(newAccess);
      }
    } catch (e) {
      print("Refresh token failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
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
        child: Center(
          child: AppAssetUtils.svg(AppAssets.logoSehati, width: 260),
        ),
      ),
    );
  }
}
