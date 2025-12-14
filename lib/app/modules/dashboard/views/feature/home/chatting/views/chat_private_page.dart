// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
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

    controller.currentRoomKey.value = roomKey;
    // Load initial messages & socket
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadMessages(roomKey: roomKey);
      controller.initSocket();
    });

    return WillPopScope(
      onWillPop: () async {
        controller.currentRoomKey.value = "";
        return true;
      },

      child: Scaffold(
        appBar: CustomChatAppbar(
          profileUrl: receiverPicture ?? "",
          name: receiverName,
          status: "online",
        ),
        body: Stack(
          children: [
            backgroundChat(),
            Positioned.fill(
              child: Container(color: Colors.black.withOpacity(0.3)),
            ),
            Column(
              children: [
                Expanded(
                  child: Obx(() {
                    return RefreshIndicator(
                      color: AppColors.orangeLight,
                      onRefresh: () async {
                        await controller.refreshOldMessages();
                      },
                      child: ListView.builder(
                        controller: controller.chatScrollController,
                        reverse: true,
                        padding: EdgeInsets.zero,
                        itemCount: controller.chats.length,
                        itemBuilder: (context, index) {
                          final chat = controller.chats[index];
                          return ChatWidget.customChatBubble(
                            text: chat.message,
                            time: DateTime.parse(chat.createdAt),
                            isSender: chat.type == "sender",
                            onTap: () {},
                            onLongPress: () {},
                          );
                        },
                      ),
                    );
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: InputTextFieldWithReply(
                    controller: controller.textController,
                    onSendTap: () {
                      controller.addChat(receiverId);
                      controller.textController.clear();
                    },
                  ),
                ),
                const SizedBox(height: 12.0),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget backgroundChat() {
    return AppAssetUtils.image(
      AppAssets.backgroundChat,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
    );
  }
}
