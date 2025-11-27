// ignore_for_file: avoid_print
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/data/models/response/chat_message_model.dart';
import 'package:sehati/app/data/models/response/chat_room_model.dart';
import 'package:sehati/app/data/services/local_storage_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatService {
  late WebSocketChannel channel;
  final Dio _dio = Dio(
    BaseOptions(
      headers: {'Accept': 'application/json'},
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
    ),
  );
  ChatService() {
    channel = WebSocketChannel.connect(
      Uri.parse('wss://sehatiapps.web.id/ws/chat'),
    );
  }

  /// GET CHAT ROOMS
  Future<List<ChatRoomModel>> getChatRooms({
    int limit = 20,
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
        print("➡️ Rooms Response: ${response.data}");

        final listData = response.data['data'] as List;
        return ChatRoomModel.fromJsonList(listData);
      }

      return [];
    } on DioException catch (e) {
      print("❌ ERROR GET ROOMS: ${e.response?.data ?? e.message}");
      return [];
    }
  }

  Future<List<ChatMessageModel>> getMessages({
    required String userId,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final token = await LocalStorageService.getAccessToken();

      final response = await _dio.get(
        ApiEndpoints.CHAT_PRIVARE,
        queryParameters: {"user_id": userId, "limit": limit, "offset": offset},
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print("➡️ Messages Response: ${response.data}");

      if (response.statusCode == 200) {
        final listData = response.data['data'] as List;
        return ChatMessageModel.fromJsonList(listData);
      }

      return [];
    } on DioException catch (e) {
      print("❌ ERROR GET MESSAGES: ${e.response?.data ?? e.message}");
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
        ApiEndpoints.CHAT_PRIVARE,
        data: {"receiver_id": receiverId, "message": message},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      print("➡️ SendChat Response: ${response.data}");

      return response.statusCode == 200;
    } on DioException catch (e) {
      print("❌ ERROR SEND MESSAGE: ${e.response?.data ?? e.message}");
      return false;
    }
  }

  Stream get stream => channel.stream;

  void dispose() {
    channel.sink.close();
  }
}
