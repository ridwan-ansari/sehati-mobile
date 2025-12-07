// ignore_for_file: deprecated_member_use, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:sehati/app/common/utils/time_utils.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/data/models/response/chat_room_model.dart';

class RoomChatCardWidget extends StatelessWidget {
  final ChatRoomModel room;
  final VoidCallback onTap;

  const RoomChatCardWidget({
    super.key,
    required this.onTap,
    required this.room,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = room.receiverPicture != null
        ? "$BASE_URL${room.receiverPicture}"
        : null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar
            AnimatedIn(
              child: CircleAvatar(
                radius: 28,
                backgroundColor: Colors.grey.shade200,
                backgroundImage:
                    imageUrl != null ? NetworkImage(imageUrl) : null,
                child: imageUrl == null
                    ? const Icon(Icons.person, color: Colors.grey, size: 30)
                    : null,
              ),
            ),

            const SizedBox(width: 16),

            // Name + ID
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedIn(
                    child: Text(
                      room.receiverName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  const SizedBox(height: 4),

                  AnimatedIn(
                    child: Text(
                      "${room.lastMessage}",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Time + Read Status
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AnimatedIn(
                  child: Text(
                    TimeUtils.formatTime(DateTime.parse(room.lastMessageTime??"")),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 4),
                AnimatedIn(child: AppAssetUtils.svg(AppAssets.read2Chat, width: 12, height: 14)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
