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
  final RxBool isLoading = false.obs;
  final RxList<ChatRoomModel> chatRooms = <ChatRoomModel>[].obs;
  final RxList<ChatMessageModel> chats = <ChatMessageModel>[].obs;
  final Rxn<ChatMessageModel> replyChat = Rxn<ChatMessageModel>();
  final RxList<UserChatModel> userList = <UserChatModel>[].obs;
  final TextEditingController textController = TextEditingController();
  final ScrollController userScrollController = ScrollController();
  final ScrollController chatScrollController = ScrollController();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Timer? _debounce;

  int _page = 0;
  final int _limit = 20;
  String _lastQuery = '';
  int _chatPage = 0;
  final int _chatLimit = 10;
  bool _chatHasMore = true;
  final RxBool chatIsLoading = false.obs;
  final RxString currentRoomKey = ''.obs;

  bool _hasMore = true;
  bool _isFetching = false;

  int get chatPage => _chatPage;
  int get chatLimit => _chatLimit;
  bool get chatHasMore => _chatHasMore;

  @override
  void onInit() {
    super.onInit();
    socketService.connect();
    initSocket();
    getRooms();
    repo = ChatRepository(socketService);
    userScrollController.addListener(_onUserScroll);
    chatScrollController.addListener(_onChatScroll);
  }

  @override
  void onClose() {
    _debounce?.cancel();
    userScrollController.removeListener(_onUserScroll);
    userScrollController.dispose();
    currentRoomKey.value = '';
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
    if (!_chatHasMore || chatIsLoading.value) return;
    chatIsLoading.value = true;
    _chatPage++;

    final messages = await _chatService.getMessages(
      roomKey: currentRoomKey.value,
      offset: _chatPage * _chatLimit,
      limit: _chatLimit,
    );

    final converted = messages.map((e) => ChatMessageModel(
          id: e.id,
          message: e.message,
          senderId: e.senderId,
          receiverId: e.receiverId,
          createdAt: e.createdAt,
          type: e.type,
        )).toList();

    chats.addAll(converted);
    _chatHasMore = converted.length == _chatLimit;
    chatIsLoading.value = false;
  }

  void initSocket() async {
    final connected = await socketService.connect();
    if (!connected) return;

    socketService.stream.listen((raw) async {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      final incomingRoomKey = data['room_key'] as String?;

      if (currentRoomKey.isEmpty && incomingRoomKey != null) {
        currentRoomKey.value = incomingRoomKey;
      }

      if (incomingRoomKey == currentRoomKey.value) {
        await loadMessages(roomKey: currentRoomKey.value, refresh: true);
        await getRooms();
      }
    });
  }

  Future<void> getRooms() async {
    try {
      isLoading(true);
      final rooms = await _chatService.getChatRooms();
      chatRooms.assignAll(rooms);
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadChatRooms() async {
    await getRooms();
  }

  Future<void> loadMessages({
    required String roomKey,
    bool refresh = true,
  }) async {
    if (chatIsLoading.value) return;
    chatIsLoading.value = true;

    try {
      if (refresh) {
        _chatPage = 0;
        _chatHasMore = true;
        chats.clear();
      }

      final messages = await _chatService.getMessages(
        roomKey: roomKey,
        offset: _chatPage * _chatLimit,
        limit: _chatLimit,
      );

      final converted = messages.map((e) => ChatMessageModel(
            id: e.id,
            message: e.message,
            senderId: e.senderId,
            receiverId: e.receiverId,
            createdAt: e.createdAt,
            type: e.type,
          )).toList();

      chats.addAll(converted);
      _chatHasMore = converted.length == _chatLimit;

      if (refresh) scrollToBottom();
    } finally {
      chatIsLoading.value = false;
    }
  }

  Future<void> addChat(String receiverId) async {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    repo.sendChat(ChatMessage(to: receiverId, message: text));
    scrollToBottom();
  }

  void onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      searchUsers(query);
    });
  }

  Future<void> searchUsers(String query) async {
    if (query.isEmpty) return getAllUsers();
    _lastQuery = query;
    _page = 0;
    _hasMore = true;
    await _fetchUsers(query, append: false);
  }

  Future<void> getAllUsers() async {
    _page = 0;
    _hasMore = true;
    _lastQuery = '';
    await _fetchUsers('', append: false);
  }

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

  void _onUserScroll() {
    if (!_hasMore || _isFetching) return;
    if (userScrollController.position.pixels >=
        userScrollController.position.maxScrollExtent - 200) {
      _page++;
      _fetchUsers(_lastQuery, append: true);
    }
  }

  void _onChatScroll() {
    if (chatScrollController.position.pixels <= 100 &&
        _chatHasMore &&
        !chatIsLoading.value) {
      _chatPage++;
      loadMessages(roomKey: currentRoomKey.value, refresh: false);
    }
  }

  void clearChats() => chats.clear();

  void clearReply() => replyChat.value = null;

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
      return await _userService.getUserId(userId: userId);
    } catch (_) {
      return null;
    }
  }
}
