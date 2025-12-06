import 'package:flutter/material.dart';
import 'package:sehati/app/common/constants/app_colors.dart';

class GradienGameLabel extends StatelessWidget {
  final String title;
  final double fontSize;

  const GradienGameLabel({super.key, required this.title , this.fontSize = 16.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
      decoration: BoxDecoration(
        gradient:  LinearGradient(
          colors: [AppColors.orangeLight, Color.fromARGB(0, 221, 215, 213)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Text(
        title,
        style:  TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
