// ignore_for_file: avoid_print, constant_identifier_names

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const settings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print("🔔 Notification tapped: ${response.payload}");
        if (response.actionId == 'stop_alarm') {
          // Jika Anda menggunakan cancelNotification: true di atas,
          // notifikasi sudah dibatalkan, tetapi Anda bisa menambahkan
          // logika tambahan di sini (misalnya menghentikan suara/vibrasi jika masih berjalan)
          print("Tombol STOP ditekan di foreground!");
        } else if(response.actionId == 'open_alarm'){
          print('open di klik');
        }
        else {
          // Tombol notifikasi utama (bukan tombol aksi) yang ditekan
          // Lakukan navigasi ke layar alarm, misalnya:
          // Navigator.of(context).pushNamed('/alarm-detail');
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  static Future<void> scheduleAlarm({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
    bool repeatDaily = false,
  }) async {
    const String STOP_ALARM_KEY = 'stop_alarm';
    const String OPEN_ALARM_KEY = 'open_alarm';
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(dateTime, tz.local),
       NotificationDetails(
        android: AndroidNotificationDetails(
          'alarm_channel',
          'Alarm Notifications',
          channelDescription: 'Channel for reminders and alarms',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('alarm_sound',),
          enableVibration: true,
          fullScreenIntent: true,
          channelBypassDnd: true,
          visibility: NotificationVisibility.public,
          category: AndroidNotificationCategory.alarm,
          vibrationPattern: Int64List.fromList([0, 1000, 500, 2000]),
          audioAttributesUsage: AudioAttributesUsage.alarm,
          actions: <AndroidNotificationAction>[
            AndroidNotificationAction(
              STOP_ALARM_KEY,
              'Stop',
              cancelNotification: true,
            ),
             AndroidNotificationAction(
              OPEN_ALARM_KEY,
              'Open',
              cancelNotification: false,
            ),
          ],
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: repeatDaily ? DateTimeComponents.time : null,
    );
  }
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  debugPrint('🔙 Notification tapped in background: ${response.payload}');
}
