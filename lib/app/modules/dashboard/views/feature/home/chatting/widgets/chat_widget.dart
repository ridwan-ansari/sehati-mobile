import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:sehati/app/data/models/response/chat_message_model.dart';
import 'package:swipe_to/swipe_to.dart';

class ChatWidget {
  static Widget selectTextReply({ChatMessageModel? data}) {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.blue),
    );
  }

  //single chat bubble
  static Widget customChatBubble({
    required String text,
    required DateTime time,
    required bool isSender,
    required void Function() onTap,
    required void Function() onLongPress,
    Function(DragUpdateDetails)? onSwipe,
  }) {
    final formattedTime = DateFormat('HH:mm').format(time);
    return SwipeTo(
      key: UniqueKey(),
      onRightSwipe: isSender ? null : onSwipe,
      onLeftSwipe: isSender ? onSwipe : null,
      offsetDx: 0.2,
      iconOnLeftSwipe: Icons.reply,
      iconOnRightSwipe: Icons.reply,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: isSender
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: onTap,
              onLongPress: onLongPress,
              child: Container(
                margin: EdgeInsets.only(
                  left: isSender ? 50 : 10,
                  right: isSender ? 10 : 50,
                  top: 5,
                  bottom: 5,
                ),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSender ? Colors.grey[300] : Colors.brown[300],
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(12),
                    topRight: const Radius.circular(12),
                    bottomLeft: isSender
                        ? const Radius.circular(12)
                        : const Radius.circular(0),
                    bottomRight: isSender
                        ? const Radius.circular(0)
                        : const Radius.circular(12),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: isSender
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    AnimatedIn(
                      child: Text(
                        text,
                        style: TextStyle(
                          color: isSender ? Colors.black : Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedIn(
                          child: Text(
                            formattedTime,
                            style: TextStyle(
                              color: isSender ? Colors.black54 : Colors.white70,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        if (isSender) ...[
                          const SizedBox(width: 5),
                          AnimatedIn(
                            child: AppAssetUtils.svg(
                              AppAssets.read2Chat,
                              width: 12,
                              height: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // reply chat bubble
  static Widget replyChatBubble({
    required String repliedText,
    required String replyPreview,
    required DateTime time,
    required bool isSender,
    required void Function() onTap,
    Function(DragUpdateDetails)? onSwipe,
  }) {
    final formattedTime = DateFormat('HH:mm').format(time);
    return SwipeTo(
      key: UniqueKey(),
      onRightSwipe: isSender ? null : onSwipe,
      onLeftSwipe: isSender ? onSwipe : null,
      offsetDx: 0.2,
      iconOnLeftSwipe: Icons.reply,
      iconOnRightSwipe: Icons.reply,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: isSender
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: onTap,
              child: Container(
                margin: EdgeInsets.only(
                  left: isSender ? 50 : 10,
                  right: isSender ? 10 : 50,
                  top: 5,
                  bottom: 5,
                ),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSender ? Colors.grey[300] : Colors.brown[300],
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(12),
                    topRight: const Radius.circular(12),
                    bottomLeft: isSender
                        ? const Radius.circular(12)
                        : const Radius.circular(0),
                    bottomRight: isSender
                        ? const Radius.circular(0)
                        : const Radius.circular(12),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: isSender
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 8,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isSender
                                ? Colors.brown[400]
                                : Colors.grey[400],
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            ),
                          ),
                        ),
                        Container(
                          height: 40,
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: isSender
                                ? Colors.grey[400]
                                : Colors.brown[400],
                            borderRadius: BorderRadius.only(topRight: Radius.circular(12) , bottomRight: Radius.circular(12)),
                          ),
                          child: Text(
                            replyPreview,
                            style: TextStyle(
                              color: isSender ? Colors.black87 : Colors.white70,
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      repliedText,
                      style: TextStyle(
                        color: isSender ? Colors.black : Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          formattedTime,
                          style: TextStyle(
                            color: isSender ? Colors.black54 : Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                        if (isSender) ...[
                          const SizedBox(width: 5),
                          AppAssetUtils.svg(
                            AppAssets.read2Chat,
                            width: 24,
                            height: 24,
                            color: Colors.grey,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
