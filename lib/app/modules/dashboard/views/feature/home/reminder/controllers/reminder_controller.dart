import 'package:sehati/app/data/models/response/reminder_model.dart';
import 'package:sehati/app/data/services/reminders_service.dart';
import 'package:sehati/app/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class ReminderController extends GetxController {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final RemindersService _service = RemindersService();

  final titleController = TextEditingController();
  final timeController = TextEditingController();
  final selectedDays = <String>[].obs;
  final reminders = <Reminder>[].obs;

  @override
  void onInit() {
    super.onInit();
    _requestNotificationPermission();
    getReminderServer();
  }

  Future<void> _requestNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied || status.isRestricted) {
      await Permission.notification.request();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  @override
  void onClose() {
    titleController.dispose();
    timeController.dispose();
    super.onClose();
  }

  int _uuidToNotificationId(String uuid) {
    final clean = uuid.replaceAll('-', '');
    final last8 = clean.substring(clean.length - 8);
    final value = int.parse(last8, radix: 16);
    return value & 0x7FFFFFFF;
  }

  Future<void> addReminder(Reminder reminder) async {
    final baseId = _uuidToNotificationId(reminder.id.toString());
    final parts = reminder.time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    await Future.wait(
      reminder.days.asMap().entries.map((entry) {
        final weekday = _dayToWeekday(entry.value);
        final scheduledDate = _nextDateForWeekday(weekday, hour, minute);
        return NotificationService.scheduleAlarm(
          id: baseId + entry.key,
          title: reminder.title,
          body: '${entry.value} at ${reminder.time}',
          dateTime: scheduledDate,
        );
      }),
    );
  }

  Future<void> updateReminder(Reminder reminder) async {
    final baseId = _uuidToNotificationId(reminder.id.toString());

    await NotificationService.cancelReminder(
      baseId: baseId,
      totalDays: reminder.days.length,
    );

    final parts = reminder.time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    await Future.wait(
      reminder.days.asMap().entries.map((entry) {
        final weekday = _dayToWeekday(entry.value);
        final scheduledDate = _nextDateForWeekday(weekday, hour, minute);
        return NotificationService.scheduleAlarm(
          id: baseId + entry.key,
          title: reminder.title,
          body: '${entry.value} at ${reminder.time}',
          dateTime: scheduledDate,
        );
      }),
    );
  }

  Future<void> deleteReminder(Reminder reminder) async {
    final baseId = _uuidToNotificationId(reminder.id.toString());
    await NotificationService.cancelReminder(
      baseId: baseId,
      totalDays: reminder.days.length,
    );
  }

  int _dayToWeekday(String day) {
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
        throw ArgumentError('Invalid day: $day');
    }
  }

  DateTime _nextDateForWeekday(int weekday, int hour, int minute) {
    final now = DateTime.now();
    DateTime scheduled = DateTime(now.year, now.month, now.day, hour, minute);
    int diff = (weekday - scheduled.weekday) % 7;
    if (diff == 0 && scheduled.isBefore(now)) diff = 7;
    return scheduled.add(Duration(days: diff));
  }

  Future<void> postReminderServer(Reminder reminder) async {
    final response = await _service.createReminder(reminder);
    if (response?.statusCode == 201) {
      final saved = reminder.copyWith(id: response!.dataItem?.id);
      await addReminder(saved);
      await getReminderServer();
    }
  }

  Future<void> getReminderServer() async {
    reminders.clear();
    final response = await _service.getReminders();
    if (response != null && response.isNotEmpty) {
      reminders.addAll(response);
      await _syncReminders();
    }
  }

  Future<void> updateReminderServer(Reminder reminder) async {
    final response = await _service.updateReminder(reminder);
    if (response?.statusCode == 200) {
      await updateReminder(reminder);
      await getReminderServer();
    }
  }

  Future<void> deleteReminderServer(Reminder reminder) async {
    final deleted = await _service.deleteReminder(reminder.id.toString());
    if (deleted == true) {
      await deleteReminder(reminder);
      await getReminderServer();
    }
  }

  Future<void> _syncReminders() async {
    if (reminders.isEmpty) return;
    await NotificationService.cancelAll();
    await Future.wait(
      reminders
          .where((r) => r.active == true)
          .map((r) => addReminder(r)),
    );
  }
}
