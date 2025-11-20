// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sehati/app/common/utils/time_utils.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/data/models/forum_content_model.dart';
import 'package:sehati/app/modules/dashboard/views/feature/forum/controller/forum_controller.dart';
import 'package:sehati/app/modules/dashboard/views/feature/forum/widget/comment_bottomsheet.dart';

class PostCard extends StatelessWidget {
  final ForumContentModel post;

  const PostCard({super.key, required this.post});

  String formatDate(String date) {
    try {
      final parsed = DateTime.parse(date);
      return DateFormat("d MMM").format(parsed);
    } catch (_) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ForumController>();

    return Card(
      color: Colors.transparent,
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    "$BASE_URL${post.user.picture}",
                  ),
                  radius: 21,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () {},
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.user.nickname,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          TimeUtils.timeAgo(DateTime.parse(post.createdAt)),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (post.imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                "$BASE_URL${post.imageUrl}",
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Obx(() {
                  final current = controller.content.firstWhere(
                    (e) => e.id == post.id,
                    orElse: () => post,
                  );

                  return IconButton(
                    icon: Icon(
                      current.isLiked ? Icons.favorite : Icons.favorite_border,
                      color: current.isLiked ? Colors.red : Colors.black,
                    ),
                    onPressed: () {
                      controller.likePost(post.id);
                    },
                  );
                }),

                IconButton(
                  icon: const Icon(Icons.mode_comment_outlined),
                  onPressed: () async {
                    final controller = Get.find<ForumController>();

                    await controller.fetchComments(post.id);

                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => CommentBottomSheet(
                        comments: controller.comments,
                        onAddComment: (c) => controller.addComment(post.id, c),
                        onRefresh: () => controller.fetchComments(post.id),
                      ),
                    );
                  },
                ),

                IconButton(
                  icon: const Icon(Icons.share_outlined),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          Obx(() {
            final current = controller.content.firstWhere(
              (e) => e.id == post.id,
              orElse: () => post,
            );

            return Row(
              children: [
                Text(
                  "${current.likeCount} like",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 8.0),
                Text(
                  "${current.commentCount} Comment",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            );
          }),

          // ===== Caption =====
          RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black, fontSize: 14),
              children: [
                TextSpan(
                  text: "${post.user.nickname} ",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: post.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
