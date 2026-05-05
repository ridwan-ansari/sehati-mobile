import 'package:flutter/material.dart';
import 'package:sehati/app/common/constants/app_colors.dart';

/// A template to ensure consistent padding, safe areas, and scroll behavior across the app.
class PageTemplate extends StatelessWidget {
  final Widget child;
  final bool isScrollable;
  final Color backgroundColor;

  const PageTemplate({
    super.key,
    required this.child,
    this.isScrollable = true,
    this.backgroundColor = AppColors.surface,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: isScrollable
            ? SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: child,
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: child,
              ),
      ),
    );
  }
}
