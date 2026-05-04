import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/localization/app_strings.dart';
import 'package:sehati/app/data/models/response/reminder_model.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/reminder/controllers/reminder_controller.dart';

class AddReminderPage extends StatefulWidget {
  final Reminder? reminder;
  const AddReminderPage({super.key, this.reminder});

  @override
  State<AddReminderPage> createState() => _AddReminderPageState();
}

class _AddReminderPageState extends State<AddReminderPage> {
  final controller = Get.find<ReminderController>();
  final _formKey = GlobalKey<FormState>();
  bool isEditing = false;

  TimeOfDay? selectedTime;
  final days = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"];

  final selectedDays = <String>[].obs;
  Reminder? editingReminder;

  @override
  void initState() {
    super.initState();
    final reminder = Get.arguments as Reminder?;
    if (reminder != null) {
      isEditing = true;
      editingReminder = reminder;
      controller.titleController.text = reminder.title;
      selectedTime = TimeOfDay(
        hour: int.parse(reminder.time.split(":")[0]),
        minute: int.parse(reminder.time.split(":")[1]),
      );
      selectedDays.assignAll(reminder.days);
    }
    selectedTime ??= TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.richBrown,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          isEditing ? AppStrings.get(AppStrings.commonKeyEdit) : AppStrings.get(AppStrings.reminderKeyAdd),
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(Icons.edit_note_rounded, AppStrings.get(AppStrings.reminderKeyName)),
              const SizedBox(height: 12),
              AnimatedIn(
                child: TextFormField(
                  controller: controller.titleController,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  decoration: InputDecoration(
                    hintText: AppStrings.get(AppStrings.commonKeyEnterTitle),
                    hintStyle: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.normal),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.title_rounded, color: AppColors.orangeLight),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.grey.shade100),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.grey.shade100),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppColors.orangeLight, width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  ),
                  validator: (v) => v!.isEmpty ? AppStrings.get(AppStrings.validationKeyFieldRequired) : null,
                ),
              ),
              const SizedBox(height: 32),
              _buildSectionTitle(Icons.access_time_rounded, AppStrings.get(AppStrings.reminderKeyTime)),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _pickTime,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade100),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      AnimatedIn(
                        child: Text(
                          selectedTime!.format(context),
                          style: const TextStyle(
                            fontSize: 56,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textDark,
                            letterSpacing: -1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppStrings.get(AppStrings.reminderKeyTapToChange),
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              _buildSectionTitle(Icons.calendar_today_rounded, AppStrings.get(AppStrings.reminderKeyFrequency)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: days.map((d) => Obx(() {
                  final isSelected = selectedDays.contains(d);
                  final localizedDay = AppStrings.getDayName(d);
                  return FilterChip(
                    label: Text(
                      localizedDay.length > 3 ? localizedDay.substring(0, 3).toUpperCase() : localizedDay.toUpperCase(),
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (v) => v ? selectedDays.add(d) : selectedDays.remove(d),
                    selectedColor: AppColors.orangeLight,
                    checkmarkColor: Colors.white,
                    backgroundColor: Colors.white,
                    showCheckmark: false,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isSelected ? AppColors.orangeLight : Colors.grey.shade200,
                      ),
                    ),
                  );
                })).toList(),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            )
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orangeLight,
              foregroundColor: Colors.white,
              elevation: 8,
              shadowColor: AppColors.orangeLight.withValues(alpha: 0.4),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            ),
            child: Text(
              AppStrings.get(AppStrings.commonKeySave),
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, letterSpacing: 0.5),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title) => Row(
    children: [
      Icon(icon, size: 18, color: AppColors.orangeLight),
      const SizedBox(width: 8),
      Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textDark),
      ),
    ],
  );

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime!,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(colorScheme: const ColorScheme.light(primary: AppColors.orangeLight)),
        child: child!,
      ),
    );
    if (picked != null) setState(() => selectedTime = picked);
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final time = "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}";
      final reminder = Reminder(
        id: editingReminder?.id ?? "",
        title: controller.titleController.text,
        time: time,
        days: selectedDays.toList(),
        message: controller.titleController.text,
        active: true,
      );
      if (isEditing) {
        controller.updateReminderServer(reminder);
      } else {
        controller.postReminderServer(reminder);
      }
      Get.back();
    }
  }
}
