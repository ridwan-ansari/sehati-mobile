// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:sehati/app/data/models/chat_message_model.dart';
import 'package:sehati/app/data/models/response/chat_message_model.dart';
import 'package:sehati/app/data/models/response/chat_room_model.dart';
import 'package:sehati/app/data/models/response/profile_response_model.dart';
import 'package:sehati/app/data/models/response/user_chat_model.dart';
import 'package:sehati/app/data/repositories/chat_repository.dart';
import 'package:sehati/app/data/services/chat_service.dart';
import 'package:sehati/app/data/services/user_service.dart';
import 'package:sehati/app/data/services/ws/chat_socket_service.dart';
import 'package:sehati/app/services/awesome_notifications_service.dart';

class ChattingController extends GetxController {
  final ChatService _chatService = ChatService();
  final UserService _userService = UserService();
  final ChatSocketService socketService = ChatSocketService();

  late ChatRepository repo;
  RxBool isLoading = false.obs;
  RxList<ChatRoomModel> chatRooms = <ChatRoomModel>[].obs;
  RxList<ChatMessageModel> chats = <ChatMessageModel>[].obs;
  Rxn<ChatMessageModel> replyChat = Rxn<ChatMessageModel>();
  RxList<UserChatModel> userList = <UserChatModel>[].obs;
  final TextEditingController textController = TextEditingController();
  final ScrollController userScrollController = ScrollController();
  final ScrollController chatScrollController = ScrollController();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Timer? _debounce;

  int _page = 0;
  final int _limit = 20;
  String _lastQuery = "";
  int chatPage = 0;
  final int chatLimit = 10;
  bool chatHasMore = true;
  RxBool chatIsLoading = false.obs;
  RxString currentRoomKey = "".obs;

  bool _hasMore = true;
  bool _isFetching = false;

  @override
  void onInit() {
    super.onInit();

    socketService.connect();
    initSocket();
    getRooms();

    repo = ChatRepository(socketService);

    userScrollController.addListener(_onScroll);
    chatScrollController.addListener(() {
      if (chatScrollController.position.pixels <= 100 &&
          chatHasMore &&
          !chatIsLoading.value) {
        chatPage++;
        loadMessages(roomKey: currentRoomKey.value, refresh: false);
      }
    });
  }

  @override
  void onClose() {
    userScrollController.removeListener(_onScroll);
    userScrollController.dispose();
    currentRoomKey.value = "";
    super.onClose();
  }

  void scrollToBottom() {
    if (chatScrollController.hasClients) {
      chatScrollController.animateTo(
        chatScrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> refreshOldMessages() async {
    print("Refreshing old messages...");
    if (!chatHasMore || chatIsLoading.value) return;
    print("Loading more messages...");
    chatIsLoading.value = true;
    chatPage++;

    final messages = await _chatService.getMessages(
      roomKey: currentRoomKey.value,
      offset: chatPage * chatLimit,
      limit: chatLimit,
    );
    print("Loaded ${messages.length} more messages.");
    print("Loaded ${chats.length} more messages.");

    final converted = messages.map((e) {
      return ChatMessageModel(
        id: e.id,
        message: e.message,
        senderId: e.senderId,
        receiverId: e.receiverId,
        createdAt: e.createdAt,
        type: e.type,
      );
    }).toList();

    chats.addAll(converted); // ⬅ TAMBAH DI BAWAH (karena reverse: true)
    chatHasMore = converted.length == chatLimit;

    chatIsLoading.value = false;
  }

  // ============================================================
  //  SOCKET
  // ============================================================
  void initSocket() async {
    final connected = await socketService.connect();
    if (!connected) {
      print("❌ Socket gagal connect");
      return;
    }

    print("✔ WebSocket Ready");

    socketService.stream.listen((raw) async {
      print("WS EVENT [CONTROLLER]: $raw");

      Map<String, dynamic> data = jsonDecode(raw);
      final incomingRoomKey = data['room_key'];

      if (currentRoomKey.isEmpty) {
        currentRoomKey.value = incomingRoomKey;
        print("📌 Room key initialized from socket: ${currentRoomKey.value}");
      }

      if (incomingRoomKey == currentRoomKey.value) {
        print("📩 New message for active room: ${currentRoomKey.value}");
        await loadMessages(roomKey: currentRoomKey.value, refresh: true);
        await getRooms();
      }
    });
  }

  // ============================================================
  //  GET ROOMS
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
  //  LOAD MESSAGES
  // ============================================================
  Future<void> loadMessages({
    required String roomKey,
    bool refresh = true,
  }) async {
    print("Loading messages for roomKey: $roomKey");
    if (chatIsLoading.value) return;
    chatIsLoading.value = true;

    try {
      if (refresh) {
        chatPage = 0;
        chatHasMore = true;
        chats.clear();
      }

      final messages = await _chatService.getMessages(
        roomKey: roomKey,
        offset: chatPage * chatLimit,
        limit: chatLimit,
      );

      final converted = messages.map((e) {
        return ChatMessageModel(
          id: e.id,
          message: e.message,
          senderId: e.senderId,
          receiverId: e.receiverId,
          createdAt: e.createdAt,
          type: e.type,
        );
      }).toList();

      chats.addAll(converted);

      chatHasMore = converted.length == chatLimit;

      if (refresh) {
        scrollToBottom();
      }
    } finally {
      chatIsLoading.value = false;
    }
  }

  // ============================================================
  //  SEND MESSAGE
  // ============================================================
  Future<void> addChat(String receiverId) async {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    final newMessage = ChatMessage(to: receiverId, message: text);
    repo.sendChat(newMessage);

    scrollToBottom();
  }

  // ============================================================
  //  SEARCH USERS (Realtime + Debounce)
  // ============================================================
  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      searchUsers(query);
    });
  }

  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      return getAllUsers();
    }

    _lastQuery = query;
    _page = 0;
    _hasMore = true;

    await _fetchUsers(query, append: false);
  }

  Future<void> getAllUsers() async {
    _page = 0;
    _hasMore = true;
    _lastQuery = "";
    await _fetchUsers("", append: false);
  }

  // ============================================================
  //  PAGINATION FETCH
  // ============================================================
  Future<void> _fetchUsers(String query, {bool append = false}) async {
    if (_isFetching || !_hasMore) return;

    _isFetching = true;

    try {
      final users = await _chatService.searchUsers(
        query: query,
        offset: _page * _limit,
        limit: _limit,
      );

      if (append) {
        userList.addAll(users);
      } else {
        userList.assignAll(users);
      }

      _hasMore = users.length == _limit;
    } finally {
      _isFetching = false;
    }
  }

  // ============================================================
  //  SCROLL LISTENER FOR PAGINATION
  // ============================================================
  void _onScroll() {
    if (!_hasMore || _isFetching) return;

    if (userScrollController.position.pixels >=
        userScrollController.position.maxScrollExtent - 200) {
      _page++;
      _fetchUsers(_lastQuery, append: true);
    }
  }

  // ============================================================
  //  UTILITIES
  // ============================================================
  void clearChats() {
    chats.clear();
  }

  void clearReply() {
    replyChat.value = null;
  }

  Future<void> showWsNotification({
    required String title,
    required String body,
    required String imageUrl,
    required String receiverId,
    required String roomKey,
    required String receiverName,
    required String receiverPicture,
    required String roomId,
  }) async {
    AwesomeNotificationService.showWsNotification(
      title: title,
      body: body,
      imageUrl: imageUrl,
      receiverId: receiverId,
      roomKey: roomKey,
      receiverName: receiverName,
      receiverPicture: receiverPicture,
      roomId: roomId,
    );
  }

  Future<ProfileData?> getUserById(String userId) async {
    try {
      final profile = await _userService.getUserId(userId: userId);
      return profile;
    } catch (e) {
      print("Error fetching user profile: $e");
      return null;
    }
  }
}
