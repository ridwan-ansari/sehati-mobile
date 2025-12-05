// ignore_for_file: avoid_print

import 'package:sehati/app/common/utils/snackbar_utils.dart';
import 'package:sehati/app/data/models/reminder_model.dart';
import 'package:sehati/app/data/services/notification_service.dart';
import 'package:sehati/app/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:uuid/uuid.dart';
import 'package:permission_handler/permission_handler.dart';

class ReminderController extends GetxController {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final titleController = TextEditingController();
  final timeController = TextEditingController();
  final selectedDays = <String>[].obs;
  var reminders = <ReminderModel>[].obs;
  var totalPoints = 0.obs;
  final _uuid = Uuid();

  @override
  void onInit() {
    super.onInit();
    // Ambil reminder yang tersimpan
    requestNotificationPermission();
    final savedReminders = LocalStorageService.getAllReminders();
    reminders.value = savedReminders
        .map(
          (r) => ReminderModel(
            id: r.id,
            days: r.days,
            time: r.time,
            title: r.title,
            isActive: r.isActive,
            notificationId: r.notificationId,
          ),
        )
        .toList();
    print("📦 Loaded ${reminders.length} reminders from local storage");
  }

  Future<void> requestNotificationPermission() async {
    final status = await Permission.notification.status;

    if (status.isDenied || status.isRestricted) {
      final result = await Permission.notification.request();
      if (result.isGranted) {
        print("🔔 Notification permission granted");
      } else {
        print("❌ Notification permission denied");
      }
    } else if (status.isPermanentlyDenied) {
      print("⚠️ Notification permission permanently denied");
      openAppSettings();
    } else {
      print("🔔 Notification permission already granted");
    }
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  @override
  void onClose() {
    titleController.dispose();
    timeController.dispose();
    super.onClose();
  }

  int generateNotificationId() {
    return DateTime.now().microsecondsSinceEpoch % 2147483647;
  }

  Future<void> addReminder(
    String title,
    TimeOfDay time,
    List<String> days,
  ) async {
    try {
      final id = _uuid.v4();
      final formattedTime =
          "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
      final notifId = generateNotificationId();

      final reminder = ReminderModel(
        id: id,
        title: title,
        time: formattedTime,
        days: days,
        isActive: true,
        notificationId: notifId,
      );
      await LocalStorageService.addReminder(reminder);
      reminders.add(reminder);

      final now = DateTime.now();
      DateTime scheduledDate = DateTime(
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      );

      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      await NotificationService.scheduleAlarm(
        id: reminder.notificationId,
        title: reminder.title,
        body: 'Reminder aktif untuk ${reminder.time}',
        dateTime: scheduledDate,
        repeatDaily: true,
      );

      totalPoints.value += 20;
      SnackbarUtils.show(isError: false, "Reminder Added");

      print("✅ Reminder berhasil ditambahkan: $title");
    } catch (e) {
      print("❌ Gagal menambahkan reminder: $e");

      SnackbarUtils.show("Reminder Failed");
    }
  }

  /// --- TOGGLE ACTIVE STATE ---
  void toggleActive(int index, bool value) async {
    reminders[index].isActive = value;
    reminders.refresh();

    if (value) {
      totalPoints.value += 20;
    }
  }

  /// --- TEST INSTANT NOTIFICATION ---
  Future<void> testAlarm() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'alarm_channel_v21',
          'Alarm Notifications',
          channelDescription: 'Play loud alarm sound',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('alarm_sound'),
          fullScreenIntent: true,
          enableVibration: true,
          category: AndroidNotificationCategory.alarm,
          visibility: NotificationVisibility.public,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      '⏰ Alarm Test',
      'Sekarang harusnya bunyi!',
      platformChannelSpecifics,
    );
    print("✅ Test alarm berhasil dikirim");
  }

  Future<void> updateReminder(ReminderModel data) async {
    try {
      final index = reminders.indexWhere((r) => r.id == data.id);
      if (index == -1) return;

      final updatedReminder = data;
      final now = DateTime.now();

      final time = TimeOfDay(
        hour: int.parse(updatedReminder.time.split(":")[0]),
        minute: int.parse(updatedReminder.time.split(":")[1]),
      );

      DateTime scheduledDate = DateTime(
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      );

      // Kalau sudah lewat → geser ke besok
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      await LocalStorageService.addReminder(updatedReminder);
      await NotificationService.scheduleAlarm(
        id: updatedReminder.hashCode,
        title: updatedReminder.title,
        body: 'Reminder aktif untuk ${updatedReminder.time}',
        dateTime: scheduledDate,
        repeatDaily: true,
      );

      reminders[index] = updatedReminder;
      reminders.refresh();
      SnackbarUtils.show(isError: false, "Reminder Updated");
    } catch (e) {
      print("❌ Gagal update reminder: $e");
      SnackbarUtils.show(isError: false, "Reminder Failed");
    }
  }
}
