// ignore_for_file: prefer_conditional_assignment

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/data/models/reminder_model.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/reminder/controllers/reminder_controller.dart';

class AddReminderPage extends StatefulWidget {
  final ReminderModel? reminder;
  const AddReminderPage({super.key, this.reminder});

  @override
  State<AddReminderPage> createState() => _AddReminderPageState();
}

class _AddReminderPageState extends State<AddReminderPage> {
  final controller = Get.find<ReminderController>();
  final _formKey = GlobalKey<FormState>();
  bool isEditing = false;

  TimeOfDay? selectedTime;
  final days = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  final selectedDays = <String>[].obs;
  ReminderModel? editingReminder;

  @override
  void initState() {
    super.initState();

    final reminder = Get.arguments as ReminderModel?;
    if (reminder != null) {
      isEditing = true;
      editingReminder = reminder;
      controller.titleController.text = reminder.title;
      selectedTime = TimeOfDay(
        hour: int.parse(reminder.time.split(":")[0]),
        minute: int.parse(reminder.time.split(":")[1]),
      );
      selectedDays.addAll(reminder.days);
    }
    if (selectedTime == null) {
      selectedTime = TimeOfDay.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Reminder"),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        controller: ScrollController(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                AnimatedIn(
                  child: TextFormField(
                    controller: controller.titleController,
                    decoration: const InputDecoration(
                      labelText: "Reminder Title",
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        v!.isEmpty ? "Please enter reminder title" : null,
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: AppColors.orangeLight,
                              onSurface: Colors.black,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      setState(() => selectedTime = picked);
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 238, 187),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.gold),
                    ),
                    child: Center(
                      child: AnimatedIn(
                        child: Text(
                          selectedTime == null
                              ? "Select Time"
                              : selectedTime!.format(context),
                          style: TextStyle(
                            fontFamily: 'Digital7',
                            fontSize: 67,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: AlignmentGeometry.bottomLeft,
                  child: Text("Choose a Day", style: TextStyle(fontSize: 14)),
                ),
                const SizedBox(height: 8.0),

                // DAYS SELECTION
                Wrap(
                  spacing: 8,
                  children: days
                      .map(
                        (d) => Obx(
                          () => AnimatedIn(
                            child: ChoiceChip(
                              label: Text(d),
                              selected: selectedDays.contains(d),
                              selectedColor: Colors.orange,
                              onSelected: (v) {
                                v ? selectedDays.add(d) : selectedDays.remove(d);
                              },
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 50.0),
              ],
            ),
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      floatingActionButton: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ElevatedButton.icon(
          onPressed: () {
            if (_formKey.currentState!.validate() && selectedTime != null) {
              if (isEditing && editingReminder != null) {
                final time =
                    "${selectedTime?.hour.toString().padLeft(2, '0')}:${selectedTime?.minute.toString().padLeft(2, '0')}";
                controller.updateReminder(
                  ReminderModel(
                    id: editingReminder!.id,
                    title: controller.titleController.text,
                    time: time,
                    days: selectedDays.toList(),
                    notificationId: editingReminder!.notificationId
                  ),
                );
              } else {
                controller.addReminder(
                  controller.titleController.text,
                  selectedTime!,
                  selectedDays.toList(),
                );
              }
        
              Get.toNamed('/reminder');
            }
          },
          icon: const Icon(Icons.save),
          label: AnimatedIn(child: const Text("Save Reminder")),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            minimumSize: const Size(double.infinity, 48),
          ),
        ),
      ),
    );
  }
}
