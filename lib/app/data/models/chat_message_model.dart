class ChatMessage {
  final String to;
  final String message;

  ChatMessage({
    required this.to,
    required this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      "to": to,
      "message": message,
    };
  }
}
