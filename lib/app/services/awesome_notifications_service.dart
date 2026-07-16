import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:get/get.dart';
import 'package:sehati/app/data/services/profile_service.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/chatting/controllers/chatting_controller.dart';
import 'package:sehati/app/common/utils/app_logger.dart';

class AwesomeNotificationService {
  static Future<void> showWsNotification({
    required String title,
    required String body,
    String? imageUrl,
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

  static ReceivedAction? pendingInitialAction;

  static Future<void> onActionReceived(ReceivedAction action) async {
    // If we are on the splash screen (or app hasn't fully rendered), save the action for later
    if (Get.currentRoute == '/splash' || Get.currentRoute == '') {
      pendingInitialAction = action;
      return;
    }
    
    await executeAction(action);
  }

  static Future<void> executeAction(ReceivedAction action) async {
    if (action.buttonKeyPressed == 'Reply') {
      try {
        ChattingController controller = Get.find<ChattingController>();
        final replyText = action.buttonKeyInput;

        String? receiverId = action.payload?['receiver_id'];
        if (receiverId == null || receiverId.isEmpty) {
          receiverId = action.payload?['sender_id'] ?? action.payload?['from'];
        }

        // If still null, try to infer from current room if app is open
        if (receiverId == null || receiverId.isEmpty) {
          final currentRoom = controller.currentRoomKey.value;
          if (currentRoom.isNotEmpty) {
            final room = controller.chatRooms.firstWhereOrNull(
              (r) => r.roomKey == currentRoom,
            );
            if (room != null) {
              receiverId = room.receiverId;
            }
          }
        }

        // If STILL null, try to parse it from the room_key in the payload
        if (receiverId == null || receiverId.isEmpty) {
          final roomKey = action.payload?['room_key'];
          if (roomKey != null && roomKey.startsWith('room::')) {
            final parts = roomKey.split('::');
            if (parts.length == 3) {
              final myProfile = await ProfileService().getProfile();
              if (myProfile != null) {
                final myId = myProfile.id;
                if (parts[1] == myId) {
                  receiverId = parts[2];
                } else if (parts[2] == myId) {
                  receiverId = parts[1];
                }
              }
            }
          }
        }

        controller.textController.text = replyText;

        if (replyText.trim().isNotEmpty &&
            receiverId != null &&
            receiverId.isNotEmpty) {
          controller.addChat(receiverId);
          controller.scrollToBottom();
          controller.textController.clear();
          await AwesomeNotifications().dismiss(action.id!);
        } else {
          AppLogger.log(
            "⚠️ Reply text is empty or receiver_id missing, not sending. receiverId=$receiverId",
          );
          // Don't clear text so user can send manually if they open the app
          await AwesomeNotifications().dismiss(action.id!);
        }
      } catch (e) {
        AppLogger.log("❌ Error handling notification reply: $e");
      }
    } else if (action.buttonKeyPressed == 'Open' ||
        action.buttonKeyPressed == '') {
      try {
        Get.toNamed(
          '/chat_private',
          arguments: {
            "room_key": action.payload?['room_key'] ?? "",
            "receiver_id": action.payload?['receiver_id'] ?? "",
            "receiver_name": action.payload?['receiver_name'] ?? "",
            "receiver_picture": action.payload?['receiver_picture'] ?? "",
            "room_id": action.payload?['room_id'] ?? "",
          },
        )?.then((_) {
          Get.toNamed("/dashboard");
          Get.toNamed("/chatting");
        });
      } catch (e) {
        AppLogger.log("❌ Error handling notification reply: $e");
      }
    }
  }
}
