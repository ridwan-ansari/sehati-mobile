import 'package:hive/hive.dart';

part 'reminder_model.g.dart';

@HiveType(typeId: 1)
class ReminderModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String time; // Format "HH:mm"

  @HiveField(3)
  List<String> days;

  @HiveField(4)
  bool isActive;

  ReminderModel({
    required this.id,
    required this.title,
    required this.time,
    required this.days,
    this.isActive = true,
  });
}
