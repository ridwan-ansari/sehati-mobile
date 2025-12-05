class ChatMessageModel {
  final String id;
  final String message;
  final String senderId;
  final String receiverId;
  final String createdAt;
  final String type;

  ChatMessageModel({
    required this.id,
    required this.message,
    required this.senderId,
    required this.receiverId,
    required this.createdAt,
    required this.type,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] ?? "",
      message: json['message'] ?? "",
      senderId: json['sender_id'] ?? "",
      receiverId: json['receiver_id'] ?? "",
      createdAt: json['created_at'] ?? "",
      type: json['type'] ?? "",
    );
  }

  static List<ChatMessageModel> fromJsonList(List data) {
    return data.map((e) => ChatMessageModel.fromJson(e)).toList();
  }
}
