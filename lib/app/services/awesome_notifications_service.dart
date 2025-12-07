// ignore_for_file: avoid_print

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:get/get.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/chatting/controllers/chatting_controller.dart';

class AwesomeNotificationService {
  static Future<void> showWsNotification({
    required String title,
    required String body,
    required String imageUrl,
    required String receiverId,
    required String roomKey,
    required String receiverName,
    required String receiverPicture,
    required String roomId,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        channelKey: 'ws_channel',
        title: title,
        body: body,
        largeIcon: imageUrl,
        notificationLayout: NotificationLayout.Messaging,
        payload: {
          'receiver_id': receiverId,
          'room_key': roomKey,
          'receiver_name': receiverName,
          'receiver_picture': receiverPicture,
          'room_id': roomId,
        },
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'Reply',
          label: 'Reply',
          requireInputText: true,
        ),
        NotificationActionButton(key: 'Open', label: 'Open'),
      ],
    );
  }

  static Future<void> onActionReceived(ReceivedAction action) async {
    if (action.buttonKeyPressed == 'Reply') {
      try {
        ChattingController controller = Get.find<ChattingController>();
        final replyText = action.buttonKeyInput;
        final receiverId = action.payload?['receiver_id'];

        controller.textController.text = replyText;

        if (replyText.trim().isNotEmpty &&
            receiverId != null &&
            receiverId.isNotEmpty) {
          controller.addChat(receiverId);
          controller.scrollToBottom();
          controller.textController.clear();
          await AwesomeNotifications().dismiss(action.id!);
        } else {
          print("⚠️ Reply text is empty or receiver_id missing, not sending.");
          await AwesomeNotifications().dismiss(action.id!);
        }
      } catch (e) {
        print("❌ Error handling notification reply: $e");
      }
    } else if (action.buttonKeyPressed == 'Open') {
      try {
        Get.toNamed(
          '/chat_private',
          arguments: {
            "room_key": action.payload?['room_key'] ?? "",
            "receiver_id": action.payload?['receiver_id'] ?? "",
            "receiver_name": action.payload?['receiver_name'] ?? "No Name",
            "receiver_picture": action.payload?['receiver_picture'] ?? "",
            "room_id": action.payload?['room_id'] ?? "",
          },
        )?.then((_) {
          Get.toNamed("/dashboard");
        });
      } catch (e) {
        print("❌ Error handling notification reply: $e");
      }
    }
  }
}
