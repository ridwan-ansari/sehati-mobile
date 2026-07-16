import 'package:dio/dio.dart';
import 'package:sehati/app/common/utils/app_logger.dart';
import 'package:sehati/app/data/config/dio_factory.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/data/services/local_storage_service.dart';

class NotificationApiService {
  static final _dio = DioFactory.create(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  );

  /// Register the FCM Token to the separate Notification Backend
  static Future<void> registerToken({required String token}) async {
    try {
      final accessToken = LocalStorageService.getAccessToken();
      final response = await _dio.post(
        ApiEndpoints.SAVE_TOKEN_FCM,
        data: {"token_fcm": token},
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      AppLogger.log("NotificationApiService.registerToken: ${response.data}");
    } catch (e) {
      if (e is DioException) {
        AppLogger.log(
          "NotificationApiService.registerToken ERROR: ${e.response?.data ?? e.message}",
        );
      } else {
        AppLogger.log("NotificationApiService.registerToken ERROR: $e");
      }
    }
  }

  /// Send a push notification to the receiver via the separate Notification Backend
  static Future<void> sendChatNotification({
    required String receiverId,
    required String senderId,
    required String senderName,
    required String message,
    required String roomKey,
    required String roomId,
    String senderPicture = "",
    String? receiverTokenFcm,
  }) async {
    try {
      AppLogger.log("NotificationApiService.sendChatNotification: $receiverId");
      AppLogger.log("NotificationApiService.sendChatNotification: $senderId");
      AppLogger.log("NotificationApiService.sendChatNotification: $senderName");
      AppLogger.log("NotificationApiService.sendChatNotification: $message");
      AppLogger.log("NotificationApiService.sendChatNotification: $roomKey");
      AppLogger.log("NotificationApiService.sendChatNotification: $roomId");
      AppLogger.log(
        "NotificationApiService.sendChatNotification: $senderPicture",
      );
      AppLogger.log(
        "NotificationApiService.sendChatNotification: $receiverTokenFcm",
      );

      final accessToken = LocalStorageService.getAccessToken();
      final response = await _dio.post(
        "${ApiEndpoints.ROOT}api/chat/send-chat-notif",
        data: {
          "receiver_id": receiverId,
          "message": message,
          "room_key": roomKey,
          "room_id": roomId,
          if (receiverTokenFcm != null) "token_fcm": receiverTokenFcm,
        },
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      AppLogger.log(
        "NotificationApiService.sendChatNotification: ${response.data}",
      );
    } catch (e) {
      if (e is DioException) {
        AppLogger.log(
          "NotificationApiService.sendChatNotification ERROR: ${e.response?.data ?? e.message}",
        );
      } else {
        AppLogger.log("NotificationApiService.sendChatNotification ERROR: $e");
      }
    }
  }
}
