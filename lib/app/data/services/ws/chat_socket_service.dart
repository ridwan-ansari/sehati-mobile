import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';

import 'package:sehati/app/data/services/local_storage_service.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/chatting/controllers/chatting_controller.dart';
import 'package:web_socket_channel/io.dart';
import 'package:sehati/app/common/utils/app_logger.dart';

class ChatSocketService {
  IOWebSocketChannel? _channel;
  late Stream _broadcastStream;

  bool _isConnecting = false;
  bool _isConnected = false;

  int _retryAttempts = 0;
  Timer? _reconnectTimer;

  final Uri _uri = Uri.parse("wss://sehatiapps.web.id/ws/chat");

  /// ============================
  /// CONNECT
  /// ============================
  Future<bool> connect() async {
    if (_isConnected || _isConnecting) {
      AppLogger.log("WS: already connected/connecting...");
      return _isConnected;
    }

    _isConnecting = true;

    final token = LocalStorageService.getAccessToken();
    AppLogger.log("WS CONNECTING... attempt=$_retryAttempts");

    try {
      final socket = await WebSocket.connect(
        _uri.toString(),
        headers: {'Authorization': 'Bearer $token'},
      );

      _channel = IOWebSocketChannel(socket);
      _broadcastStream = _channel!.stream.asBroadcastStream();

      _isConnecting = false;
      _isConnected = true;
      _retryAttempts = 0;

      AppLogger.log("WS CONNECTED");

      _listenSocket();

      return true;
    } catch (e) {
      AppLogger.log("WS CONNECT ERROR: $e");
      _isConnecting = false;
      _isConnected = false;

      _scheduleReconnect();
      return false;
    }
  }

  /// ============================
  /// LISTEN SOCKET
  /// ============================
  void _listenSocket() {
    _broadcastStream.listen(
      (event) {
        ChattingController controller = Get.find<ChattingController>();
        controller.getRooms();
        final data = jsonDecode(event);
        AppLogger.log("WS SERVICE: $data");

        final status = data['status']; // <-- STRING
        final fromId = data['from'];

        final routeRoom = controller.currentRoomKey.value.toLowerCase();
        final responRoom = data['room_key'].toString().toLowerCase();
        AppLogger.log("-------------------------------------------------");
        AppLogger.log("route :: $routeRoom");
        AppLogger.log("res ::$responRoom");
        AppLogger.log("-------------------------------------------------");

        if (status == null && (routeRoom != responRoom)) {
          controller.getUserById(fromId).then((profile) {

          });
        }
      },
      onDone: () {
        AppLogger.log("WS CLOSED by server");
        _isConnected = false;
        _scheduleReconnect();
      },
      onError: (e) {
        AppLogger.log("WS ERROR: $e");
        _isConnected = false;
        _scheduleReconnect();
      },
    );
  }

  /// ============================
  /// AUTO RECONNECT MEKANISME
  /// ============================
  void _scheduleReconnect() {
    if (_isConnecting || _isConnected) return;

    _retryAttempts++;

    int delay = 2;
    if (_retryAttempts >= 3) delay = 5;
    if (_retryAttempts >= 6) delay = 10;

    AppLogger.log("WS Reconnect in $delay seconds...");

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(Duration(seconds: delay), () {
      connect();
    });
  }

  /// ============================
  /// GET STREAM
  /// ============================
  Stream get stream {
    if (!_isConnected) throw Exception("WebSocket not connected");
    return _broadcastStream;
  }

  /// ============================
  /// SEND MESSAGE
  /// ============================
  void sendMessage(Map<String, dynamic> data) {
    if (!_isConnected) {
      AppLogger.log("WS: Not connected. Auto-reconnect...");
      connect();
      Future.delayed(const Duration(milliseconds: 500), () {
        if (_isConnected) _channel?.sink.add(jsonEncode(data));
      });
      return;
    }

    final jsonData = jsonEncode(data);
    AppLogger.log("WS SEND: $jsonData");
    _channel!.sink.add(jsonData);
  }

  /// ============================
  /// DISCONNECT MANUAL
  /// ============================
  void disconnect() {
    AppLogger.log("WS DISCONNECT MANUAL");
    _reconnectTimer?.cancel();
    _channel?.sink.close();
    _isConnected = false;
  }
}
