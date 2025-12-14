// ignore_for_file: avoid_print
import 'package:sehati/app/data/models/response/reminder_model.dart';
import 'package:sehati/app/data/services/reminders_service.dart';
import 'package:sehati/app/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class ReminderController extends GetxController {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final RemindersService _service = RemindersService();

  final titleController = TextEditingController();
  final timeController = TextEditingController();
  final selectedDays = <String>[].obs;
  var reminders = <Reminder>[].obs;
  var totalPoints = 0.obs;

  @override
  void onInit() {
    super.onInit();
    requestNotificationPermission();
    getReminderServer();
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

  Future<void> addReminder(Reminder reminder) async {
    try {
      final baseId = uuidToInt(reminder.id.toString());

      final parts = reminder.time.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      for (int i = 0; i < reminder.days.length; i++) {
        final weekday = dayStringToWeekday(reminder.days[i]);
        final scheduledDate = nextDateForWeekday(weekday, hour, minute);

        await NotificationService.scheduleAlarm(
          id: baseId + i,
          title: reminder.title,
          body: 'Reminder aktif ${reminder.days[i]} ${reminder.time}',
          dateTime: scheduledDate,
        );
      }

      totalPoints.value += 20;
      print("✅ Reminder berhasil ditambahkan (${reminder.days.join(', ')})");
    } catch (e) {
      print("❌ Gagal menambahkan reminder: $e");
      // SnackbarUtils.show("Reminder Failed");
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

  Future<void> updateReminder(Reminder reminder) async {
    try {
      final baseId = uuidToInt(reminder.id.toString());

      // 1️⃣ Cancel semua alarm lama
      await NotificationService.cancelReminder(
        baseId: baseId,
        totalDays: reminder.days.length,
      );

      // 2️⃣ Parse waktu
      final parts = reminder.time.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      // 3️⃣ Schedule ulang per hari
      for (int i = 0; i < reminder.days.length; i++) {
        final weekday = dayStringToWeekday(reminder.days[i]);

        final scheduledDate = nextDateForWeekday(weekday, hour, minute);

        await NotificationService.scheduleAlarm(
          id: baseId + i,
          title: reminder.title,
          body: 'Reminder aktif ${reminder.days[i]} ${reminder.time}',
          dateTime: scheduledDate,
        );
      }

      // SnackbarUtils.show(isError: false, "Reminder Updated");
      print("✅ Reminder updated (${reminder.days.join(', ')})");
    } catch (e) {
      print("❌ Gagal update reminder: $e");
      // SnackbarUtils.show(isError: true, "Reminder Failed");
    }
  }

  //...............

  Future<void> deleteReminder(Reminder reminder) async {
    try {
      final baseId = uuidToInt(reminder.id.toString());

      await NotificationService.cancelReminder(
        baseId: baseId,
        totalDays: reminder.days.length,
      );

      // SnackbarUtils.show(isError: false, "Reminder Canceled");
      print("🛑 Reminder berhasil dibatalkan");
    } catch (e) {
      print("❌ Gagal membatalkan reminder: $e");
      // SnackbarUtils.show("Cancel Failed");
    }
  }

  int uuidToInt(String uuid) {
    final clean = uuid.replaceAll('-', '');
    final last8 = clean.substring(clean.length - 8);
    final value = int.parse(last8, radix: 16);

    final safe = value & 0x7FFFFFFF; // <= 2147483647
    print("🔢 Notification baseId: $safe (raw=$value)");

    return safe;
  }

  int dayStringToWeekday(String day) {
    switch (day.toLowerCase()) {
      case 'monday':
        return DateTime.monday;
      case 'tuesday':
        return DateTime.tuesday;
      case 'wednesday':
        return DateTime.wednesday;
      case 'thursday':
        return DateTime.thursday;
      case 'friday':
        return DateTime.friday;
      case 'saturday':
        return DateTime.saturday;
      case 'sunday':
        return DateTime.sunday;
      default:
        throw Exception('Invalid day: $day');
    }
  }

  DateTime nextDateForWeekday(int weekday, int hour, int minute) {
    final now = DateTime.now();

    DateTime scheduled = DateTime(now.year, now.month, now.day, hour, minute);

    int diff = (weekday - scheduled.weekday) % 7;
    if (diff == 0 && scheduled.isBefore(now)) {
      diff = 7;
    }

    return scheduled.add(Duration(days: diff));
  }

  //------------------------------------SERVER-------------------------------------

  Future<void> postReminderServer(Reminder reminder) async {
    final response = await _service.createReminder(reminder);
    if (response?.statusCode == 201) {
      print('[PUSH]->[Reminder][Succes]');
      print("id : ${response!.dataItem?.id}");
      final rmdr = reminder.copyWith(id: response.dataItem?.id);
      await addReminder(rmdr);
      await getReminderServer();
    } else {
      print('[PUSH]->[Reminder][Gagal]');
    }
  }

  Future<void> getReminderServer() async {
    reminders.clear();
    final response = await _service.getReminders();
    if (response!.isNotEmpty) {
      print("[GET][REMINDER][LIST]");
      reminders.addAll(response);
      dataAsynch();
    }
  }

  Future<void> updateReminderServer(Reminder reminder) async {
    final response = await _service.updateReminder(reminder);
    if (response?.statusCode == 200) {
      print("[UPDATE][REMINDER][SUCCES]");
      await updateReminder(reminder);
      await getReminderServer();
    }
  }

  Future<void> deleteReminderServer(Reminder reminder) async {
    final response = await _service.deleteReminder(reminder.id.toString());
    if (response == true) {
      print("[DELETE][REMINDER][SUCESS]");
      await deleteReminder(reminder);
      await getReminderServer();
    }
  }

  //synch
  Future<void> dataAsynch() async {
    if (reminders.isNotEmpty) {
      await NotificationService.cancelAll();
      for (final reminder in reminders) {
        if (reminder.active == true) {
          await addReminder(reminder);
        }
      }
    }
  }
}
