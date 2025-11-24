class ChatMessageModel {
  final String message;
  final String senderId;
  final String receiverId;
  final String createdAt;

  ChatMessageModel({
    required this.message,
    required this.senderId,
    required this.receiverId,
    required this.createdAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      message: json['message'] ?? "",
      senderId: json['sender_id'] ?? "",
      receiverId: json['receiver_id'] ?? "",
      createdAt: json['created_at'] ?? "",
    );
  }

  static List<ChatMessageModel> fromJsonList(List data) {
    return data.map((e) => ChatMessageModel.fromJson(e)).toList();
  }
}
