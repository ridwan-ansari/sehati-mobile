import 'package:flutter/material.dart';

class HeaderTitleWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onMenuTap;

  const HeaderTitleWidget({super.key, this.onMenuTap , required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFEB3B), 
            Color(0xFFFF9800),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
           Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),

          GestureDetector(
            onTap: onMenuTap,
            child: const Icon(
              Icons.menu,
              color: Colors.black,
              size: 26,
            ),
          ),
        ],
      ),
    );
  }
}
