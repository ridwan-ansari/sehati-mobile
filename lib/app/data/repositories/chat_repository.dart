import 'package:sehati/app/data/models/chat_message_model.dart';
import 'package:sehati/app/data/services/ws/chat_socket_service.dart';

class ChatRepository {
  final ChatSocketService socketService;

  ChatRepository(this.socketService);


  void sendChat(ChatMessage msg) {
    socketService.sendMessage(msg.toJson());
  }
}