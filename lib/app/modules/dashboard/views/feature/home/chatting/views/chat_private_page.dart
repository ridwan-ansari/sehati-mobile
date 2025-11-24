// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:sehati/app/common/widgets/custom_chat_appbar.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/chatting/controllers/chatting_controller.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/chatting/widgets/chat_widget.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/chatting/widgets/input_text_field.dart';

class ChatPrivatePage extends GetView<ChattingController> {
  const ChatPrivatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;

    final String roomKey = args["room_key"];
    final String receiverId = args["receiver_id"];
    final String receiverName = args["receiver_name"];
    final String? receiverPicture = args["receiver_picture"];
    final String roomId = args["room_id"];
    return Scaffold(
      appBar: CustomChatAppbar(),
      body: Stack(
        children: [
          backgroundChat(),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),
          Column(
            children: [
              Expanded(
                child: Obx(
                  () => SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                    child: ListView.builder(
                      itemCount: controller.chats.length,
                      itemBuilder: (context, index) {
                        final chat = controller.chats[index];

                        if (chat.chatReply?.id == null ||
                            chat.chatReply!.id.isEmpty) {
                          return ChatWidget.customChatBubble(
                            text: chat.message,
                            time: chat.timestamp,
                            isSender: chat.isSender,
                            onTap: () {},
                            onLongPress: () {},
                            onSwipe: (_) {
                              controller.replyChatData(chat);
                            },
                          );
                        } else {
                          // contoh placeholder reply bubble
                          return ChatWidget.replyChatBubble(
                            repliedText: chat.message,
                            replyPreview: chat.chatReply?.message ?? '',
                            time: chat.timestamp,
                            isSender: chat.isSender,
                            onTap: () {},
                            onSwipe: (_) {
                              controller.replyChatData(chat);
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
              InputTextFieldWithReply(
                controller: controller.textController,
                onSendTap: () {
                  controller.addChat();
                  controller.textController.clear();
                },
              ),
              const SizedBox(height: 8.0),
            ],
          ),
        ],
      ),
    );
  }

  //widget background chat
  Widget backgroundChat() {
    return AppAssetUtils.image(
      AppAssets.backgroundChat,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
    );
  }
}
