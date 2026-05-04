import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/localization/app_strings.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:sehati/app/common/utils/time_utils.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/data/models/forum_content_model.dart';
import 'package:sehati/app/modules/dashboard/views/feature/forum/controller/forum_controller.dart';
import 'package:sehati/app/modules/dashboard/views/feature/forum/widget/comment_bottomsheet.dart';
import 'package:share_plus/share_plus.dart';

class PostCard extends GetView<ForumController> {
  const PostCard({super.key, required this.post});

  final ForumContentModel post;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserInfo(),
          if (post.imageUrl.isNotEmpty) _buildPostImage(),
          _buildContent(),
          _buildActions(context),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: post.user.picture.isNotEmpty
                ? CachedNetworkImageProvider('$BASE_URL${post.user.picture}')
                : null,
            child: post.user.picture.isEmpty
                ? const Icon(Icons.person, size: 20, color: Colors.grey)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.user.nickname.isNotEmpty ? post.user.nickname : 'User',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.textDark),
                ),
                Text(
                  TimeUtils.timeAgo(DateTime.tryParse(post.createdAt) ?? DateTime.now()),
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz_rounded, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildPostImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: CachedNetworkImage(
          imageUrl: '$BASE_URL${post.imageUrl}',
          width: double.infinity,
          fit: BoxFit.cover,
          placeholder: (_, __) => Container(height: 300, color: Colors.grey[100]),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        post.caption,
        style: const TextStyle(fontSize: 14, color: AppColors.textMedium, height: 1.5),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          _ActionButton(
            icon: post.isLiked ? AppAssets.socialLikeTrue : AppAssets.socialLikeFalse,
            label: post.likeCount.toString(),
            color: post.isLiked ? Colors.red : Colors.grey.shade600,
            onTap: () => controller.toggleLike(post.id),
          ),
          _ActionButton(
            icon: AppAssets.socialComment,
            label: post.commentCount.toString(),
            color: Colors.grey.shade600,
            onTap: () => Get.bottomSheet(
              CommentBottomSheet(postId: post.id),
              isScrollControlled: true,
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
            ),
          ),
          // const Spacer(),
          // _ActionButton(
          //   icon: AppAssets.socialMore,
          //   label: AppStrings.get(AppStrings.forumKeyShare),
          //   color: Colors.grey.shade600,
          //   onTap: () => Share.share(post.caption),
          // ),
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
