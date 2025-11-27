import 'package:flutter/material.dart';

class CustomChatAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String profileUrl;
  final String name;
  final String status;

  const CustomChatAppbar({
    super.key,
    required this.profileUrl,
    required this.name,
    required this.status,
  });

  @override
  Size get preferredSize => const Size.fromHeight(90);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF3B2B27),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            // CircleAvatar(
            //   radius: 24,
            //   backgroundImage: NetworkImage(profileUrl),
            // ),
            const SizedBox(width: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  status,
                  style: TextStyle(
                    color: status.toLowerCase() == "online"
                        ? Colors.greenAccent
                        : Colors.grey[300],
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            const Spacer(),

            // More button
            const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
