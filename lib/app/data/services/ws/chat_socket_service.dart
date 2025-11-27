import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatSocketService {
  WebSocketChannel? _channel;

  void connect() {
    _channel = WebSocketChannel.connect(
      Uri.parse("wss://sehatiapps.web.id/ws/chat"),
    );

    print("WebSocket connected");

    // LISTEN pesan masuk
    _channel!.stream.listen(
      (event) {
        print("Pesan masuk: $event");
      },
      onError: (error) {
        print("WebSocket error: $error");
      },
      onDone: () {
        print("WebSocket disconnected");
      },
    );
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
