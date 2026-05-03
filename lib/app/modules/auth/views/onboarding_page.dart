import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/data/services/language_service.dart';
import 'package:sehati/app/routes/app_routes.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  int _page = 0;

  List<_PageData> get _pages {
    final langService = Get.find<LanguageService>();
    final isEn = langService.isEnglish();
    return [
      _PageData(
        icon: Icons.favorite_border,
        title: isEn ? 'Welcome to SEHATI' : 'Selamat Datang di SEHATI',
        subtitle: isEn
            ? 'Monitor your nutrition, activity, and health in one place.'
            : 'Pantau nutrisi, aktivitas, dan kesehatan Anda di satu tempat.',
      ),
      _PageData(
        icon: Icons.restaurant_menu,
        title: isEn ? 'Track Your Food & Activity' : 'Catat Makanan & Aktivitas Anda',
        subtitle: isEn
            ? 'Log your daily meals and physical activity to stay on top of your health goals.'
            : 'Catat makanan harian dan aktivitas fisik Anda untuk mencapai tujuan kesehatan.',
      ),
      _PageData(
        icon: Icons.emoji_events_outlined,
        title: isEn ? 'Earn Rewards' : 'Dapatkan Hadiah',
        subtitle: isEn
            ? 'Complete daily tasks and earn points for staying healthy!'
            : 'Selesaikan tugas harian dan dapatkan poin untuk tetap sehat!',
      ),
    ];
  }

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);
    Get.offAllNamed(AppRoutes.INPUTPROFILE);
  }

  void _nextPage() {
    _controller.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _SkipRow(visible: _page < 2, onSkip: _finish),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _page = i),
                itemCount: _pages.length,
                itemBuilder: (_, i) => _OnboardingSlide(data: _pages[i]),
              ),
            ),
            _DotIndicator(count: _pages.length, current: _page),
            const SizedBox(height: 32),
            _CtaButton(
              label: _page < _pages.length - 1
                  ? (Get.find<LanguageService>().isEnglish() ? 'Next' : 'Lanjut')
                  : (Get.find<LanguageService>().isEnglish() ? 'Start' : 'Mulai'),
              onPressed: _page < _pages.length - 1 ? _nextPage : _finish,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ─── Data ─────────────────────────────────────────────────────────────────────

class _PageData {
  final IconData icon;
  final String title;
  final String subtitle;
  const _PageData({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

// ─── Slide ────────────────────────────────────────────────────────────────────

class _OnboardingSlide extends StatelessWidget {
  const _OnboardingSlide({required this.data});
  final _PageData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(data.icon, size: 120, color: AppColors.orangeLight),
          const SizedBox(height: 40),
          Text(
            data.title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A2E),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            data.subtitle,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF555555),
            ),
            textAlign: TextAlign.center,
            maxLines: 4,
          ),
        ],
      ),
    );
  }
}

// ─── Skip row ─────────────────────────────────────────────────────────────────

class _SkipRow extends StatelessWidget {
  const _SkipRow({required this.visible, required this.onSkip});
  final bool visible;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: visible
          ? Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: TextButton(
                  onPressed: onSkip,
                  child: Text(
                    Get.find<LanguageService>().isEnglish() ? 'Skip' : 'Lewati',
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}

// ─── Dot indicator ────────────────────────────────────────────────────────────

class _DotIndicator extends StatelessWidget {
  const _DotIndicator({required this.count, required this.current});
  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active ? AppColors.orangeLight : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

// ─── CTA button ───────────────────────────────────────────────────────────────

class _CtaButton extends StatelessWidget {
  const _CtaButton({required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.orangeLight,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text(
              label,
              key: ValueKey(label),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
