import 'package:flutter/material.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/constants/app_colors.dart';

class GradienLabelRight extends StatelessWidget {
  final String title;
  final double fontSize;

  const GradienLabelRight({super.key, required this.title , this.fontSize = 16.0});

  @override
  Widget build(BuildContext context) {
    return Container(
       width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [ Color.fromARGB(0, 221, 215, 213),AppColors.orangeLight],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: AnimatedIn(
        child: Text(
          title,
          style:  TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
