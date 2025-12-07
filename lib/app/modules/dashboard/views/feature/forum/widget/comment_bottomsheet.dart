import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/utils/time_utils.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/data/models/forum_comment_model.dart';

class CommentBottomSheet extends StatefulWidget {
  final RxList<ForumComment> comments;
  final Function(String) onAddComment;
  final Future<void> Function() onRefresh;

  const CommentBottomSheet({
    super.key,
    required this.comments,
    required this.onAddComment,
    required this.onRefresh,
  });

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  late TextEditingController inputController;
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    inputController = TextEditingController();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    inputController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: DraggableScrollableSheet(
        maxChildSize: 0.95,
        minChildSize: 0.5,
        initialChildSize: 0.8,
        builder: (_, controller) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 20),

                // List komentar
                Expanded(
                  child: Obx(() {
                    return RefreshIndicator(
                      onRefresh: widget.onRefresh,
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: widget.comments.length,
                        itemBuilder: (_, i) {
                          final c = widget.comments[i];
                          final date = TimeUtils.timeAgo(DateTime.parse(c.createdAt));
                          return AnimatedIn(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage("$BASE_URL${c.picture}"),
                              ),
                              title: Text(c.nickname),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(c.comment),
                                  Text(date,
                                      style: const TextStyle(fontSize: 12)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 8),

                // Input komentar
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: TextField(
                          controller: inputController,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (value) {
                            if (value.trim().isNotEmpty) {
                              widget.onAddComment(value.trim());
                              inputController.clear();
                              scrollToBottom();
                            }
                          },
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Tulis komentar...",
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.send,
                        size: 32,
                        color: AppColors.orangeLight,
                      ),
                      onPressed: () {
                        if (inputController.text.trim().isNotEmpty) {
                          widget.onAddComment(inputController.text.trim());
                          inputController.clear();
                          scrollToBottom();
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}
