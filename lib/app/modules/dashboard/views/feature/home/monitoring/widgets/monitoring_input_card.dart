import 'package:flutter/material.dart';
import 'package:sehati/app/common/constants/app_colors.dart';

class MonitoringInputCard extends StatelessWidget {
  final List<Widget> children;

  const MonitoringInputCard({required this.children, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.gold,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gold, width: 1.5),
      ),
      child: Column(
        children: children),
    );
  }
}
