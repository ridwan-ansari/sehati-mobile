import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sehati/app/data/models/chat_message_model.dart';
import 'package:sehati/app/data/models/chat_model.dart';
import 'package:sehati/app/data/models/response/chat_room_model.dart';
import 'package:sehati/app/data/repositories/chat_repository.dart';
import 'package:sehati/app/data/services/chat_service.dart';
import 'package:sehati/app/data/services/ws/chat_socket_service.dart';

class ChattingController extends GetxController {
  final ChatService _chatService = ChatService();
  final socketService = ChatSocketService();
  late ChatRepository repo;

  // ====== LIST ROOM ======
  RxBool isLoading = false.obs;
  RxList<ChatRoomModel> chatRooms = <ChatRoomModel>[].obs;

  // ====== PRIVATE CHAT ======
  RxList<ChatModel> chats = <ChatModel>[].obs;
  Rxn<ChatModel> replyChat = Rxn<ChatModel>();

  final TextEditingController textController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    socketService.connect();
    repo = ChatRepository(socketService);
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
    try {
      isLoading(true);

      // final messages = await _chatService.getMessages(userId: roomKey!);

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
  Future<void> addChat(String receiverId) async {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    if (receiverId == null || receiverId!.isEmpty) {
      print("❌ receiverId kosong, pesan tidak dikirim");
      return;
    }
    final newMessage = ChatMessage(to: receiverId, message: text);
    repo.sendChat(newMessage);
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
