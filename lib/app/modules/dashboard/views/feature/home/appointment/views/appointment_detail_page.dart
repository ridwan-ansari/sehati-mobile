// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/data/models/response/professional_res_model.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/appointment_controller.dart';

class AppointmentDetailPage extends GetView<AppointmentController> {
  const AppointmentDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfessionalData doctor = Get.arguments;
    final hasPhone = doctor.phoneNumber != null && doctor.phoneNumber!.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.brownLight,
      appBar: AppBar(
        title: Text(
          doctor.fullname ?? 'Appointment',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: AppColors.richBrown,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DoctorProfileCard(doctor: doctor),
            const SizedBox(height: 16),
            _ConfirmButton(controller: controller, doctorId: doctor.id ?? ''),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Schedule',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _DatePickerRow(controller: controller, doctor: doctor),
                    const SizedBox(height: 12),
                    _TimePickerRow(controller: controller),
                    const SizedBox(height: 16),
                    _MeetingOptions(controller: controller),
                  ],
                ),
              ),
            ),
            if (hasPhone) ...[
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await launchUrl(
                      Uri.parse('https://wa.me/62${doctor.phoneNumber}'),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                  icon: AppAssetUtils.svg(
                    AppAssets.whatsAppIcon,
                    width: 20,
                    height: 20,
                    color: AppColors.whatsapp,
                  ),
                  label: const Text('Chat via WhatsApp'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.whatsapp,
                    side: const BorderSide(color: AppColors.whatsapp, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DoctorProfileCard extends StatelessWidget {
  const _DoctorProfileCard({required this.doctor});

  final ProfessionalData doctor;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: '$BASE_URL/${doctor.picture}',
                width: 90,
                height: 100,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  width: 90,
                  height: 100,
                  color: Colors.grey[200],
                ),
                errorWidget: (_, __, ___) => Container(
                  width: 90,
                  height: 100,
                  color: Colors.grey.shade300,
                  alignment: Alignment.center,
                  child: const Icon(Icons.person, size: 40),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.fullname ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    doctor.specialization ?? '',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (doctor.bio != null && doctor.bio!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      doctor.bio!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DatePickerRow extends StatelessWidget {
  const _DatePickerRow({required this.controller, required this.doctor});

  final AppointmentController controller;
  final ProfessionalData doctor;

  @override
  Widget build(BuildContext context) {
    return Obx(() => _PickerRow(
          icon: Icons.calendar_today,
          label: 'Date',
          value: controller.selectedDate.value.isEmpty
              ? 'Pick a date'
              : controller.selectedDate.value,
          onTap: () async {
            if (doctor.availableDays == null) return;

            DateTime getNearestAvailable(DateTime start, AvailableDays days) {
              DateTime d = start;
              for (int i = 0; i < 365; i++) {
                final w = d.weekday;
                final ok = (w == DateTime.monday && days.monday == true) ||
                    (w == DateTime.tuesday && days.tuesday == true) ||
                    (w == DateTime.wednesday && days.wednesday == true) ||
                    (w == DateTime.thursday && days.thursday == true) ||
                    (w == DateTime.friday && days.friday == true) ||
                    (w == DateTime.saturday && days.saturday == true) ||
                    (w == DateTime.sunday && days.sunday == true);
                if (ok) return d;
                d = d.add(const Duration(days: 1));
              }
              return start;
            }

            final avail = doctor.availableDays!;
            final initial = getNearestAvailable(DateTime.now(), avail);
            final picked = await showDatePicker(
              context: context,
              initialDate: initial,
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
              builder: (ctx, child) => Theme(
                data: Theme.of(ctx).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: AppColors.orangeLight,
                    onSurface: AppColors.textDark,
                  ),
                ),
                child: child!,
              ),
              selectableDayPredicate: (day) {
                return (day.weekday == DateTime.monday && avail.monday == true) ||
                    (day.weekday == DateTime.tuesday && avail.tuesday == true) ||
                    (day.weekday == DateTime.wednesday && avail.wednesday == true) ||
                    (day.weekday == DateTime.thursday && avail.thursday == true) ||
                    (day.weekday == DateTime.friday && avail.friday == true) ||
                    (day.weekday == DateTime.saturday && avail.saturday == true) ||
                    (day.weekday == DateTime.sunday && avail.sunday == true);
              },
            );
            if (picked != null) {
              controller.selectedDate.value = DateFormat('dd/MM/yy').format(picked);
            }
          },
        ));
  }
}

class _TimePickerRow extends StatelessWidget {
  const _TimePickerRow({required this.controller});

  final AppointmentController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() => _PickerRow(
          icon: Icons.access_time,
          label: 'Time',
          value: controller.selectedTime.value.isEmpty
              ? 'Pick a time'
              : controller.selectedTime.value,
          onTap: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
              builder: (ctx, child) => Theme(
                data: Theme.of(ctx).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: AppColors.orangeLight,
                    onSurface: AppColors.textDark,
                  ),
                ),
                child: child!,
              ),
            );
            if (picked != null) {
              controller.selectedTime.value = picked.format(context);
            }
          },
        ));
  }
}

class _PickerRow extends StatelessWidget {
  const _PickerRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.orangeLight, size: 22),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textMedium,
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.orangeLight, width: 1.5),
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MeetingOptions extends StatelessWidget {
  const _MeetingOptions({required this.controller});

  final AppointmentController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _MeetToggle(
              label: 'In-office',
              value: controller.meetInOffice.value,
              activeColor: Colors.green,
              onChanged: controller.toggleMeetInOffice,
            ),
            _MeetToggle(
              label: 'Via Zoom',
              value: controller.meetByZoom.value,
              activeColor: Colors.deepPurple,
              onChanged: controller.toggleMeetByZoom,
            ),
          ],
        ));
  }
}

class _MeetToggle extends StatelessWidget {
  const _MeetToggle({
    required this.label,
    required this.value,
    required this.activeColor,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final Color activeColor;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textMedium,
          ),
        ),
        Switch(value: value, onChanged: onChanged, activeColor: activeColor),
      ],
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  const _ConfirmButton({required this.controller, required this.doctorId});

  final AppointmentController controller;
  final String doctorId;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ElevatedButton(
        onPressed: controller.isValid
            ? () async => controller.submitAppointment(professionalId: doctorId)
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: controller.isValid ? AppColors.orangeLight : Colors.grey.shade400,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Make Appointment',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
