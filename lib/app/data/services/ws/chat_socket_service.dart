import 'dart:convert';
import 'dart:io';
import 'package:sehati/app/data/services/local_storage_service.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatSocketService {
  WebSocketChannel? _channel;
  void connect() async {
    final token = LocalStorageService.getAccessToken();
    final uri = Uri.parse("wss://sehatiapps.web.id/ws/chat");

    try {
      // Create WebSocket with custom headers
      final socket = await WebSocket.connect(
        uri.toString(),
        headers: {'Authorization': 'Bearer $token'},
      );

      _channel = IOWebSocketChannel(socket);

      print("Connected to URI: $uri");
      print(
        "Scheme: ${uri.scheme}, Host: ${uri.host}, Port: ${uri.hasPort ? uri.port : (uri.scheme == 'wss' ? 443 : 80)}",
      );

      _channel!.stream.listen(
        (event) => print("Message received: $event"),
        onError: (error) => print("WebSocket Error: $error"),
        onDone: () => print("WebSocket closed"),
      );
    } catch (e) {
      print("Connection error: $e");
    }
  }

  void sendMessage(Map<String, dynamic> data) {
    if (_channel == null) {
      print("WebSocket belum terhubung!");
      return;
    }

    final jsonData = jsonEncode(data);
    print("Kirim: $jsonData");
    _channel!.sink.add(jsonData);
  }

  void disconnect() {
    _channel?.sink.close();
  }
}
