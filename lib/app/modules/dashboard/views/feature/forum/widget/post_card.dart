import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/data/models/forum_content_model.dart';
import 'package:sehati/app/modules/dashboard/views/feature/forum/controller/forum_controller.dart';
import 'package:sehati/app/modules/dashboard/views/feature/forum/widget/comment_bottomsheet.dart';

class PostCard extends GetView<ForumController> {
  const PostCard({super.key, required this.post});

  final ForumContentModel post;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserInfo(),
          if (post.imageUrl.isNotEmpty) _buildPostImage(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(post.user.nickname, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 4),
                Text(post.caption, style: const TextStyle(fontSize: 13, height: 1.4)),
              ],
            ),
          ),
          _buildActions(context),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: post.user.picture.isNotEmpty
                ? CachedNetworkImageProvider('$BASE_URL${post.user.picture}')
                : null,
            child: post.user.picture.isEmpty ? const Icon(Icons.person, size: 18) : null,
          ),
          const SizedBox(width: 10),
          Text(post.user.nickname, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildPostImage() {
    return CachedNetworkImage(
      imageUrl: '$BASE_URL${post.imageUrl}',
      width: double.infinity,
      height: 350,
      fit: BoxFit.cover,
    );
  }

  Widget _buildActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: Icon(post.isLiked ? Icons.favorite_rounded : Icons.favorite_outline_rounded, 
                  color: post.isLiked ? Colors.red : Colors.black, size: 26),
            onPressed: () => controller.toggleLike(post.id),
          ),
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline_rounded, size: 24),
            onPressed: () => Get.bottomSheet(CommentBottomSheet(postId: post.id), isScrollControlled: true, backgroundColor: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.icon, required this.label, required this.color, required this.onTap});
  final String icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            AppAssetUtils.svg(icon, width: 20, height: 20, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
