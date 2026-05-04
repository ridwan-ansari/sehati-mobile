import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sehati/app/common/localization/app_strings.dart';

class ProfileDraft extends StatelessWidget {
  const ProfileDraft({super.key});

  @override
  Widget build(BuildContext context) {
    final posts = [
      "https://images.unsplash.com/photo-1533050487297-09b450131914?ixlib=rb-4.0.3&auto=format&fit=crop&w=1170&q=80",
      "https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-4.0.3&auto=format&fit=crop&w=1170&q=80",
      "https://images.unsplash.com/photo-1556740749-887f6717d7e4?ixlib=rb-4.0.3&auto=format&fit=crop&w=1170&q=80",
      "https://images.unsplash.com/photo-1473187983305-f615310e7daa?ixlib=rb-4.0.3&auto=format&fit=crop&w=1170&q=80",
      "https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-4.0.3&auto=format&fit=crop&w=1170&q=80",
      "https://images.unsplash.com/photo-1473187983305-f615310e7daa?ixlib=rb-4.0.3&auto=format&fit=crop&w=1170&q=80",
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "andipratama",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: const [
          Padding(padding: EdgeInsets.only(right: 16), child: Icon(Icons.menu)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ===== Header Profile =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey,
                    child: Text(
                      "A",
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStat("9", AppStrings.get(AppStrings.forumKeyPosts)),
                        _buildStat("2.5K", AppStrings.get(AppStrings.forumKeyFollowers)),
                        _buildStat("342", AppStrings.get(AppStrings.forumKeyFollowing)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ===== Bio =====
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Andi Pratama",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.camera_alt_outlined, size: 16),
                      SizedBox(width: 4),
                      Text("Photography enthusiast"),
                    ],
                  ),
                  SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 16),
                      SizedBox(width: 4),
                      Text("Jakarta, Indonesia"),
                    ],
                  ),
                  SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.star_border_rounded, size: 16),
                      SizedBox(width: 4),
                      Text("Capturing moments"),
                    ],
                  ),
                ],
              ),
            ),

            // ===== Tombol Edit =====
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 36,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.grey.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    AppStrings.get(AppStrings.profileKeyEditProfile),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            Divider(),
            // ===== Grid Post =====
            GridView.builder(
              padding: const EdgeInsets.all(1),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: posts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 1,
                crossAxisSpacing: 1,
              ),
              itemBuilder: (context, index) {
                return CachedNetworkImage(
                  imageUrl: posts[index],
                  fit: BoxFit.cover,
                  placeholder: (_, __) =>
                      Container(color: Colors.grey[200]),
                  errorWidget: (_, __, ___) =>
                      const Icon(Icons.broken_image_outlined),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
      ],
    );
  }
}

class TabIcon extends StatelessWidget {
  final bool isActive;
  final IconData icon;

  const TabIcon({super.key, required this.isActive, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Icon(icon, size: 28, color: isActive ? Colors.black : Colors.grey);
  }
}
