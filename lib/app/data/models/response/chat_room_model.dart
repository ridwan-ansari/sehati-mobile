// ignore_for_file: public_member_api_docs, sort_constructors_first

class ChatRoomModel {
  final String roomId;
  final String roomKey;
  final String receiverId;
  final String receiverName;
  final String? receiverPicture;
  final String? lastMessage;
  final String? lastMessageTime;
  final String? tokenFcm;

  ChatRoomModel({
    required this.roomId,
    required this.roomKey,
    required this.receiverId,
    required this.receiverName,
    this.receiverPicture,
    this.lastMessage,
    this.lastMessageTime,
    this.tokenFcm,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
      roomId: json['room_id'],
      roomKey: json['room_key'],
      receiverId: json['receiver_id'],
      receiverName: json['receiver_name'],
      receiverPicture: json['receiver_picture'],
      lastMessage: json['latest_message'],
      lastMessageTime: json['latest_message_created_at'],
      tokenFcm: json['token_fcm'],
    );
  }

  static List<ChatRoomModel> fromJsonList(List data) {
    return data.map((e) => ChatRoomModel.fromJson(e)).toList();
  }
}
