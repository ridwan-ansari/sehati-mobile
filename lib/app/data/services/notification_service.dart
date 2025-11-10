import 'package:hive_flutter/hive_flutter.dart';
import 'package:sehati/app/data/models/reminder_model.dart';

class LocalStorageService {
  static const _reminderBox = 'reminderBox';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ReminderModelAdapter());
    await Hive.openBox<ReminderModel>(_reminderBox);
  }

  static Box<ReminderModel> get box => Hive.box<ReminderModel>(_reminderBox);

  static Future<void> addReminder(ReminderModel reminder) async {
    await box.put(reminder.id, reminder);
  }

  static List<ReminderModel> getAllReminders() {
    return box.values.toList();
  }

  static Future<void> deleteReminder(int id) async {
    await box.delete(id);
  }

  static Future<void> clearAll() async {
    await box.clear();
  }
}
