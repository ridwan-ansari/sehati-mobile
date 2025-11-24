import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sehati/app/data/models/chat_model.dart';
import 'package:sehati/app/data/models/response/chat_room_model.dart';
import 'package:sehati/app/data/services/chat_service.dart';

class ChattingController extends GetxController {
  final ChatService _chatService = ChatService();

  // ====== LIST ROOM ======
  RxBool isLoading = false.obs;
  RxList<ChatRoomModel> chatRooms = <ChatRoomModel>[].obs;

  // ====== PRIVATE CHAT ======
  RxList<ChatModel> chats = <ChatModel>[].obs;
  Rxn<ChatModel> replyChat = Rxn<ChatModel>();

  // Room arguments
  String? roomKey;
  String? receiverId;
  String? receiverName;
  String? receiverPicture;
  String? roomId;

  final TextEditingController textController = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    // CHECK MODE: Home / Private Chat
    final args = Get.arguments;

    if (args == null) {
      // === MODE ROOMS ===
      getRooms();
    } else {
      // === MODE PRIVATE CHAT ===
      roomKey = args["room_key"];
      receiverId = args["receiver_id"];
      receiverName = args["receiver_name"];
      receiverPicture = args["receiver_picture"];
      roomId = args["room_id"];

      loadMessages();
    }
  }

  // ============================================================
  //  GET ROOM LIST
  // ============================================================
  Future<void> getRooms() async {
    try {
      isLoading(true);
      final rooms = await _chatService.getChatRooms();
      chatRooms.assignAll(rooms);
    } finally {
      isLoading(false);
    }
  }

  // ============================================================
  //  LOAD MESSAGES IN PRIVATE CHAT
  // ============================================================
  Future<void> loadMessages() async {
    if (roomKey == null) return;

    try {
      isLoading(true);

      final messages =
          await _chatService.getMessages(userId: roomKey!);

      // Convert API model → UI ChatModel
      // chats.assignAll(messages.map((e) {
      //   return ChatModel(
      //     id: e.senderId,
      //     message: e.message,
      //     timestamp: e.createdAt,
      //     isSender: e.isSender,
      //     username: e.username,
      //   );
      // }).toList());
    } finally {
      isLoading(false);
    }
  }

  // ============================================================
  //  SEND MESSAGE
  // ============================================================
  Future<void> addChat() async {
    if (textController.text.trim().isEmpty) return;

    final newMessage = ChatModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message: textController.text,
      timestamp: DateTime.now(),
      isSender: true,
      username: "Fanes Setiawan",
      chatReply: replyChat.value,
    );

    chats.add(newMessage);

    textController.clear();
    clearReply();

    // TODO: Kalo mau kirim ke API tinggal panggil:
    // await _chatService.sendMessage(roomKey!, textController.text);
  }

  // ============================================================
  //  UTILITIES
  // ============================================================
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
