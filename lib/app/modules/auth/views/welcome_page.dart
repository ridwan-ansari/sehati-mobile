import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:sehati/app/data/services/language_service.dart';
import 'package:sehati/app/routes/app_routes.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

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
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.07,
              vertical: MediaQuery.of(context).size.height * 0.03,
            ),
            child: Obx(() {
              final langService = Get.find<LanguageService>();
              final isEn = langService.isEnglish();
              return Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  AnimatedIn(
                    child: AppAssetUtils.svg(AppAssets.logoSehati, width: MediaQuery.of(context).size.width * 0.4),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.035),
                  AnimatedIn(
                    child: Text(
                      isEn ? 'Welcome\nto Sehati!' : 'Selamat Datang\ndi Sehati!',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                  AnimatedIn(
                    child: Text(
                      isEn
                          ? 'Sehati, your companion for a better life.'
                          : 'Sehati, teman Anda untuk hidup lebih baik.',
                      style: const TextStyle(fontSize: 14, color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                  AnimatedIn(
                    child: _AuthCard(
                      icon: Icons.login_rounded,
                      title: isEn ? 'Login' : 'Masuk',
                      subtitle: isEn
                          ? 'Already have an account? Sign in now'
                          : 'Sudah punya akun? Masuk sekarang',
                      filled: true,
                      onTap: () => Get.toNamed(AppRoutes.LOGIN),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  AnimatedIn(
                    child: _AuthCard(
                      icon: Icons.person_add_rounded,
                      title: isEn ? 'Sign Up' : 'Daftar',
                      subtitle: isEn
                          ? 'Don\'t have an account? Create a new one'
                          : 'Belum punya akun? Buat akun baru',
                      filled: false,
                      onTap: () => Get.toNamed(AppRoutes.INPUTPROFILE),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _AuthCard extends StatelessWidget {
  const _AuthCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.filled,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool filled;
  final VoidCallback onTap;

  static const _brown = Color(0xFF5D3A1A);
  static const _orange = Color(0xFFFF9A3D);

  @override
  Widget build(BuildContext context) {
    final cardColor = filled ? _brown : Colors.white;
    final textColor = filled ? Colors.white : _brown;
    final iconBgColor = filled
        ? Colors.white.withValues(alpha: 0.15)
        : _orange.withValues(alpha: 0.12);
    final iconColor = filled ? Colors.white : _orange;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          border: filled ? null : Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, size: 28, color: iconColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: textColor.withValues(alpha: 0.65),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: textColor.withValues(alpha: 0.55),
            ),
          ],
        ),
      ),
    );
  }
}
