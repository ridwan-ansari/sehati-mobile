
import 'package:dio/dio.dart';
import 'package:sehati/app/data/config/dio_factory.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/data/models/response/chat_message_model.dart';
import 'package:sehati/app/data/models/response/chat_room_model.dart';
import 'package:sehati/app/data/models/response/user_chat_model.dart';
import 'package:sehati/app/data/services/local_storage_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:sehati/app/common/utils/app_logger.dart';

class ChatService {
  late WebSocketChannel channel;
  final Dio _dio = DioFactory.create(includeContentType: false);
  ChatService() {
    channel = WebSocketChannel.connect(
      Uri.parse('wss://sehatiapps.web.id/ws/chat'),
    );
  }

  /// GET CHAT ROOMS
  Future<List<ChatRoomModel>> getChatRooms({
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final token = await LocalStorageService.getAccessToken();

      final response = await _dio.get(
        ApiEndpoints.CHAT_ROOMS,
        queryParameters: {"limit": limit, "offset": offset},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        AppLogger.log("➡️ Rooms Response: ${response.data}");

        final listData = response.data['data'] as List;
        return ChatRoomModel.fromJsonList(listData);
      }

      return [];
    } on DioException catch (e) {
      AppLogger.log("❌ ERROR GET ROOMS: ${e.response?.data ?? e.message}");
      return [];
    }
  }

  Future<List<ChatMessageModel>> getMessages({
    required String roomKey,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final token = await LocalStorageService.getAccessToken();

      final response = await _dio.get(
        "${ApiEndpoints.CHAT_PRIVATE}/$roomKey",
        queryParameters: {"limit": limit, "offset": offset},
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      AppLogger.log("➡️ Messages Response: ${response.data}");

      if (response.statusCode == 200) {
        final listData = response.data['data'] as List;
        return ChatMessageModel.fromJsonList(listData);
      }

      return [];
    } on DioException catch (e) {
      AppLogger.log("❌ ERROR GET MESSAGES: ${e.response?.data ?? e.message}");
      AppLogger.log("❌ ERROR GET MESSAGES: ${e.response?.statusCode}");
      return [];
    }
  }

  Future<bool> sendPrivateMessage({
    required String receiverId,
    required String message,
  }) async {
    try {
      final token = await LocalStorageService.getAccessToken();

      final response = await _dio.post(
        ApiEndpoints.CHAT_PRIVATE,
        data: {"receiver_id": receiverId, "message": message},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      AppLogger.log("➡️ SendChat Response: ${response.data}");

      return response.statusCode == 200;
    } on DioException catch (e) {
      AppLogger.log("❌ ERROR SEND MESSAGE: ${e.response?.data ?? e.message}");
      return false;
    }
  }
  Future<List<UserChatModel>> searchUsers({
    required String query,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final token = LocalStorageService.getAccessToken();

      final response = await _dio.get(
        ApiEndpoints.SEARCH_USERS,
        queryParameters: {
          "keyword": query,
          "limit": limit,
          "offset": offset,
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      AppLogger.log("➡️ Search Users Response: ${response.data}");

      if (response.statusCode == 200) {
        final listData = response.data['data'] as List;
        return UserChatModel.fromJsonList(listData);
      }

      return [];
    } on DioException catch (e) {
      AppLogger.log("❌ ERROR SEARCH USERS: ${e.response?.data ?? e.message}");
      return [];
    }
  }
  
  Stream get stream => channel.stream;

  void dispose() {
    channel.sink.close();
  }
}
