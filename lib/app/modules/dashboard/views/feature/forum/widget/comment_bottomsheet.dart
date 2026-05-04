import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/localization/app_strings.dart';
import 'package:sehati/app/common/utils/time_utils.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/modules/dashboard/views/feature/forum/controller/forum_controller.dart';

class CommentBottomSheet extends GetView<ForumController> {
  const CommentBottomSheet({super.key, required this.postId});
  final String postId;

  @override
  Widget build(BuildContext context) {
    controller.fetchForumDetail(postId);

    return Container(
      height: Get.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          _buildDragHandle(),
          _buildHeader(),
          const Divider(height: 1),
          Expanded(child: _buildCommentList()),
          _buildCommentInput(context),
        ],
      ),
    );
  }

  Widget _buildDragHandle() {
    return Container(
      width: 40,
      height: 4,
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
      child: Text(
        AppStrings.get(AppStrings.forumKeyComment),
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.textDark),
      ),
    );
  }

  Widget _buildCommentList() {
    return Obx(() {
      if (controller.isLoadingDetail.value) {
        return const Center(child: CircularProgressIndicator(color: AppColors.orangeLight));
      }
      if (controller.comments.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.chat_bubble_outline_rounded, size: 48, color: Colors.grey.shade300),
              const SizedBox(height: 12),
              Text(
                AppStrings.getOr('No comments yet.', 'Belum ada komentar.'),
                style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        );
      }
      return ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: controller.comments.length,
        itemBuilder: (context, index) {
          final comment = controller.comments[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: AnimatedIn(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: comment.picture.isNotEmpty
                        ? CachedNetworkImageProvider('$BASE_URL${comment.picture}')
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              comment.nickname.isNotEmpty ? comment.nickname : 'User',
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.textDark),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              TimeUtils.timeAgo(DateTime.tryParse(comment.createdAt) ?? DateTime.now()),
                              style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          comment.comment,
                          style: const TextStyle(fontSize: 13, color: AppColors.textMedium, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildCommentInput(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + MediaQuery.of(context).viewInsets.bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.commentController,
              decoration: InputDecoration(
                hintText: AppStrings.get(AppStrings.forumKeyWriteComment),
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
              ),
              maxLines: null,
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            backgroundColor: AppColors.richBrown,
            child: IconButton(
              onPressed: () => controller.postComment(postId),
              icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
