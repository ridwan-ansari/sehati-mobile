import 'package:flutter/material.dart';

class GradientLabel extends StatelessWidget {
  final String title;
  final double fontSize;

  const GradientLabel({super.key, required this.title , this.fontSize = 16.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF5ACD), Color.fromARGB(0, 221, 215, 213)],
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
