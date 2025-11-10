import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sehati/app/data/models/chat_model.dart';

class ChattingController extends GetxController {
  final RxList<ChatModel> chats = <ChatModel>[].obs;
  final Rxn<ChatModel> replyChat = Rxn<ChatModel>(null);

  final TextEditingController textController = TextEditingController();

  void addChat() {
    if (replyChat.value == null) {
      chats.add(
        ChatModel(
          id: '123',
          message: textController.text,
          timestamp: DateTime.now(),
          isSender: true,
          username: "Fanes Setiawan",
        ),
      );
    } else {
      chats.add(
        ChatModel(
          id: '123',
          message: textController.text,
          timestamp: DateTime.now(),
          isSender: true,
          username: "Fanes Setiawan",
          chatReply: ChatModel(
            id: "456",
            message: replyChat.value?.message ?? '',
            timestamp: replyChat.value?.timestamp ?? DateTime.now(),
            isSender: replyChat.value?.isSender ?? false,
            username: replyChat.value?.username ?? '',
          ),
        ),
      );
      clearReply();
    }
  }

  void clearChats() {
    chats.clear();
  }

  void deleteChat(String id) {
    chats.removeWhere((chat) => chat.id == id);
  }

  void replyChatData(ChatModel? data) {
    replyChat.value = data;
  }

  void clearReply() {
    replyChat.value = null;
  }
}
