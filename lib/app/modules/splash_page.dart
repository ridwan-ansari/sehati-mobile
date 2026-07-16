import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:sehati/app/data/services/auth_service.dart';
import 'package:sehati/app/data/services/language_service.dart';
import 'package:sehati/app/data/services/local_storage_service.dart';
import 'package:sehati/app/data/services/user_service.dart';
import 'package:sehati/app/services/fcm_service.dart';
import 'package:sehati/app/services/awesome_notifications_service.dart';
import '../routes/app_routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final _authService = AuthService();
  final _userService = UserService();

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    await Get.putAsync<LanguageService>(() => LanguageService.initialize());
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final token = LocalStorageService.getAccessToken();

    if (token != null && token.isNotEmpty) {
      await _refreshToken();

      if (LocalStorageService.getAccessToken() == null) {
        Get.offAllNamed(AppRoutes.LOGIN);
        return;
      }

      final nutritionData = await _userService.getUserNutrition();

      if (LocalStorageService.getAccessToken() == null) {
        return;
      }

      if (nutritionData == null) {
        Get.offAllNamed(AppRoutes.DASHBOARD);
        _handlePendingNotifications();
        return;
      }

      if (nutritionData.isEmpty) {
        Get.offAllNamed(AppRoutes.NUTRITION);
        return;
      }
      
      Get.offAllNamed(AppRoutes.DASHBOARD);
      _handlePendingNotifications();
    } else {
      final prefs = await SharedPreferences.getInstance();
      final hasSelectedLanguage = prefs.getBool('has_selected_language') ?? false;

      if (!hasSelectedLanguage) {
        Get.offAllNamed(AppRoutes.LANGUAGE);
        return;
      }

      final hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;
      Get.offAllNamed(
        hasSeenOnboarding ? AppRoutes.WELCOME : AppRoutes.ONBOARDING,
      );
    }
  }

  void _handlePendingNotifications() {
    // Memberikan waktu yang lebih panjang (1.2 detik) agar animasi transisi Get.offAllNamed 
    // selesai sepenuhnya. Jika terlalu cepat, Get.toNamed akan diabaikan oleh GetX.
    Future.delayed(const Duration(milliseconds: 1200), () {
      debugPrint("SplashPage: Executing pending notifications...");
      if (FCMService.pendingInitialMessage != null) {
        debugPrint("SplashPage: Routing FCM pending message");
        FCMService.handleNotificationClick(FCMService.pendingInitialMessage!);
        FCMService.pendingInitialMessage = null;
      } else if (AwesomeNotificationService.pendingInitialAction != null) {
        debugPrint("SplashPage: Routing AwesomeNotifications pending action");
        AwesomeNotificationService.executeAction(AwesomeNotificationService.pendingInitialAction!);
        AwesomeNotificationService.pendingInitialAction = null;
      }
    });
  }

  Future<void> _refreshToken() async {
    final token = LocalStorageService.getRefreshToken();
    if (token == null) return;
    try {
      final newAccess = await _authService.refreshToken(refreshToken: token);
      if (newAccess != null) {
        LocalStorageService.setAccessToken(newAccess);
      }
    } catch (_) {}
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
          child: AppAssetUtils.svg(AppAssets.logoSehati, width: MediaQuery.of(context).size.width * 0.6),
        ),
      ),
    );
  }
}
