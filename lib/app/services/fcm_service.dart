import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:sehati/app/services/awesome_notifications_service.dart';
import 'package:sehati/app/services/notification_api_service.dart';
import 'package:get/get.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/chatting/controllers/chatting_controller.dart'
    as sehati_chat;

class FCMService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static RemoteMessage? pendingInitialMessage;

  static Future<void> init() async {
    NotificationSettings? settings;
    try {
      settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    } catch (e) {
      debugPrint('Error requesting FCM permission: $e');
    }

    if (settings?.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission for FCM');
    }

    String? token = await _firebaseMessaging.getToken();
    debugPrint('FCM Token: $token');

    if (token != null) {
      _registerTokenToBackend(token);
    }

    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      debugPrint('FCM Token Refreshed: $newToken');
      _registerTokenToBackend(newToken);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');

      if (message.notification != null) {
        debugPrint(
          'Message also contained a notification: ${message.notification}',
        );

        final receiverId = message.data['receiver_id'] ?? '';
        final roomKey = message.data['room_key'] ?? '';
        final receiverName =
            message.data['receiver_name'] ??
            message.data['sender_name'] ??
            message.notification?.title ??
            'Pesan Baru';
        final receiverPicture = message.data['receiver_picture'] ?? '';
        final roomId = message.data['room_id'] ?? '';

        // Mencegah notifikasi muncul jika sedang berada di room yang sama
        bool isCurrentlyInRoom = false;
        if (Get.currentRoute == '/chat_private') {
          try {
            final chattingController =
                Get.find<sehati_chat.ChattingController>();
            if (chattingController.currentRoomKey.value == roomKey) {
              isCurrentlyInRoom = true;
            }
          } catch (_) {}
        }

        if (!isCurrentlyInRoom) {
          final String? validImageUrl = receiverPicture.isNotEmpty
              ? receiverPicture
              : null;

          AwesomeNotificationService.showWsNotification(
            title: message.notification!.title ?? 'Pesan Baru',
            body: message.notification!.body ?? '',
            imageUrl: validImageUrl,
            receiverId: receiverId,
            roomKey: roomKey,
            receiverName: receiverName,
            receiverPicture: receiverPicture,
            roomId: roomId,
          );
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleNotificationClick(message);
    });

    pendingInitialMessage = await _firebaseMessaging.getInitialMessage();
  }

  static void handleNotificationClick(RemoteMessage message) {
    debugPrint('FCM Notification clicked: ${message.messageId}');
    if (message.data.isNotEmpty) {
      try {
        String receiverId = message.data['receiver_id'] ?? '';
        if (receiverId.isEmpty) {
          receiverId = message.data['sender_id'] ?? message.data['from'] ?? '';
        }

        final roomKey = message.data['room_key'] ?? '';

        String receiverName = message.data['receiver_name'] ?? '';
        if (receiverName.isEmpty) {
          receiverName =
              message.data['sender_name'] ?? message.notification?.title ?? '';
        }

        String receiverPicture = message.data['receiver_picture'] ?? '';
        if (receiverPicture.isEmpty) {
          receiverPicture = message.data['sender_picture'] ?? '';
        }

        final roomId = message.data['room_id'] ?? '';

        if (roomKey.isNotEmpty && receiverId.isNotEmpty) {
          Get.toNamed(
            '/chat_private',
            arguments: {
              "room_key": roomKey,
              "receiver_id": receiverId,
              "receiver_name": receiverName,
              "receiver_picture": receiverPicture,
              "room_id": roomId,
            },
          )?.then((_) {
            Get.toNamed("/dashboard");
            Get.toNamed("/chatting");
          });
        }
      } catch (e) {
        debugPrint("Error handling FCM notification click: $e");
      }
    }
  }

  static Future<void> refreshAndRegisterToken() async {
    String? token = await _firebaseMessaging.getToken();
    if (token != null) {
      await _registerTokenToBackend(token);
    }
  }

  static Future<void> _registerTokenToBackend(String token) async {
    try {
      await NotificationApiService.registerToken(token: token);
    } catch (e) {
      debugPrint('Error registering token to backend: $e');
    }
  }
}
