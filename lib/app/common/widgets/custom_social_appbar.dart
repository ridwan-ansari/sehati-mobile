import 'package:flutter/material.dart';

class CustomSocialAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomSocialAppbar({super.key});
  @override
  Size get preferredSize => const Size.fromHeight(65);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF3B2B27),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
      ),
      child: Row(children: [
        
      ]),
    );
  }
}
