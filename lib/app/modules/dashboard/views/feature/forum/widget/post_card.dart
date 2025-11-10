import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sehati/app/data/models/post_model.dart';
import 'package:sehati/app/modules/dashboard/views/feature/forum/widget/comment_bottomsheet.dart';

class PostCard extends StatefulWidget {
  final PostModel post;

  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  List<String> comments = ["Keren banget!", "Pemandangannya luar biasa 🌄"];
  void toggleLike() {
    setState(() {
      widget.post.isLiked = !widget.post.isLiked;
      widget.post.likesCount += widget.post.isLiked ? 1 : -1;
    });
  }

  String formatDate(DateTime date) {
    return DateFormat("d MMM").format(date);
  }

  void _showCommentSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return CommentBottomSheet(
          comments: comments,
          onAddComment: (newComment) {
            setState(() {
              comments.add(newComment);
            });
          },
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Card(
      color: Colors.transparent,
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== Header User =====
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(post.userProfileImage),
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
                          post.userName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          formatDate(post.createdAt),
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

          // ===== Gambar Utama =====
          if (post.contentImage != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                post.contentImage ?? '',
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

          // ===== Tombol Aksi =====
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    post.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: post.isLiked ? Colors.red : Colors.black,
                  ),
                  onPressed: toggleLike,
                ),
                IconButton(
                  icon: const Icon(Icons.mode_comment_outlined),
                  onPressed: () {
                   _showCommentSheet();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.share_outlined),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          // ===== Jumlah Like =====
          Text(
            "${post.likesCount} like",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),

          // ===== Caption =====
          RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black, fontSize: 14),
              children: [
                TextSpan(
                  text: "${post.userName} ",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: post.contentText),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  
}
