import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:sehati/app/data/services/language_service.dart';
import 'package:sehati/app/routes/app_routes.dart';

class LanguageSelectionPage extends StatefulWidget {
  const LanguageSelectionPage({super.key});

  @override
  State<LanguageSelectionPage> createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  String? _selectedLanguage;

  Future<void> _continue() async {
    if (_selectedLanguage == null) return;

    final languageService = Get.find<LanguageService>();
    await languageService.setLanguage(_selectedLanguage!);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_selected_language', true);

    Get.offAllNamed(AppRoutes.ONBOARDING);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppAssetUtils.svg(AppAssets.logoSehati, width: MediaQuery.of(context).size.width * 0.3),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  const Text(
                    'Choose Your Language',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A2E),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Pilih Bahasa',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.06),
                    child: Column(
                      children: [
                        _LanguageCard(
                          flag: '🇬🇧',
                          label: 'English',
                          value: 'en',
                          isSelected: _selectedLanguage == 'en',
                          onTap: () => setState(() => _selectedLanguage = 'en'),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                        _LanguageCard(
                          flag: '🇮🇩',
                          label: 'Bahasa Indonesia',
                          value: 'id',
                          isSelected: _selectedLanguage == 'id',
                          onTap: () => setState(() => _selectedLanguage = 'id'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.06),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _selectedLanguage == null ? null : _continue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orangeLight,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Continue / Lanjutkan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  const _LanguageCard({
    required this.flag,
    required this.label,
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  final String flag;
  final String label;
  final String value;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 72,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.orangeLight.withValues(alpha: 0.08) : Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.orangeLight : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(flag, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.orangeLight : const Color(0xFF1A1A2E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
