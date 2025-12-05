import 'dart:convert';
import 'dart:io';
import 'package:sehati/app/data/services/local_storage_service.dart';
import 'package:web_socket_channel/io.dart';

class ChatSocketService {
  IOWebSocketChannel? _channel;
  late Stream _broadcastStream;

  bool _isConnecting = false;
  bool _isConnected = false;

  /// ============================
  /// CONNECT
  /// ============================
  Future<bool> connect() async {
  if (_isConnected || _isConnecting) return _isConnected;

  _isConnecting = true;
  final token = LocalStorageService.getAccessToken();
  final uri = Uri.parse("wss://sehatiapps.web.id/ws/chat");

  try {
    final socket = await WebSocket.connect(
      uri.toString(),
      headers: {'Authorization': 'Bearer $token'},
    );

    _channel = IOWebSocketChannel(socket);
    _broadcastStream = _channel!.stream.asBroadcastStream();

    _isConnecting = false;
    _isConnected = true;

    print("WS CONNECTED");

    // listen log
    _broadcastStream.listen(
      (event) => print("WS EVENT [SERVICE]: $event"),
      onDone: () {
        print("WS CLOSED");
        _isConnected = false;
      },
      onError: (e) {
        print("WS ERROR: $e");
        _isConnected = false;
      },
    );

    return true; // ⬅️ sukses
  } catch (e) {
    print("WS CONNECT ERROR: $e");
    _isConnecting = false;
    _isConnected = false;
    return false; // ⬅️ gagal
  }
}


  /// ============================
  /// STREAM GETTER
  /// ============================
  Stream get stream {
    if (!_isConnected) throw Exception("Not connected");
    return _broadcastStream;
  }

  /// ============================
  /// SEND MESSAGE
  /// ============================
  void sendMessage(Map<String, dynamic> data) {
    if (!_isConnected) {
      print("❗ WS belum terhubung! mencoba connect…");
      connect();
      return;
    }

    final jsonData = jsonEncode(data);
    print("WS SEND: $jsonData");
    _channel!.sink.add(jsonData);
  }

  /// ============================
  /// DISCONNECT
  /// ============================
  void disconnect() {
    _channel?.sink.close();
    _isConnected = false;
  }
}
