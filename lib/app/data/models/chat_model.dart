
import 'package:hive/hive.dart';
part 'chat_model.g.dart';
@HiveType(typeId: 2)
class ChatModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String message;

  @HiveField(2)
  DateTime timestamp;

  @HiveField(3)
  bool isSender;

  @HiveField(4)
  String username;

  @HiveField(5)
  ChatModel? chatReply;


  ChatModel({
    required this.id,
    required this.message,
    required this.timestamp,
    required this.isSender,
    required this.username,
    this.chatReply,
  });
}