// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/localization/app_strings.dart';
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

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(
          AppStrings.get(AppStrings.menuKeyChatCounselor),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: AppColors.richBrown,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CounselorProfileCard(doctor: doctor),
            const SizedBox(height: 24),
            Text(
              AppStrings.getOr('Schedule Appointment', 'Atur Jadwal Konsultasi'),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _DatePickerRow(controller: controller, doctor: doctor),
                  const Divider(height: 32, thickness: 1),
                  _TimePickerRow(controller: controller),
                  const Divider(height: 32, thickness: 1),
                  _MeetingOptions(controller: controller),
                ],
              ),
            ),
            const SizedBox(height: 40),
            _ConfirmButton(controller: controller, doctorId: doctor.id ?? ''),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _CounselorProfileCard extends StatelessWidget {
  const _CounselorProfileCard({required this.doctor});

  final ProfessionalData doctor;

  @override
  Widget build(BuildContext context) {
    final hasPhone = doctor.phoneNumber != null && doctor.phoneNumber!.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.richBrown,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.richBrown.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: '$BASE_URL/${doctor.picture}',
                    width: 90,
                    height: 110,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      width: 90,
                      height: 110,
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      width: 90,
                      height: 110,
                      color: Colors.white.withValues(alpha: 0.1),
                      alignment: Alignment.center,
                      child: const Icon(Icons.person, size: 40, color: Colors.white38),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.fullname ?? '',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        doctor.specialization ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (doctor.bio != null && doctor.bio!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        doctor.bio!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.7),
                          height: 1.5,
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
          if (hasPhone) ...[
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await launchUrl(
                    Uri.parse('https://wa.me/62${doctor.phoneNumber}'),
                    mode: LaunchMode.externalApplication,
                  );
                },
                icon: AppAssetUtils.svg(
                  AppAssets.whatsAppIcon,
                  width: 22,
                  height: 22,
                  color: Colors.white,
                ),
                label: Text(AppStrings.get(AppStrings.menuKeyChatWA)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.whatsapp,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ],
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
          icon: Icons.calendar_today_rounded,
          label: AppStrings.getOr('Date', 'Tanggal'),
          value: controller.selectedDate.value.isEmpty
              ? AppStrings.getOr('Pick a date', 'Pilih tanggal')
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
                  colorScheme: const ColorScheme.light(
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
          icon: Icons.access_time_rounded,
          label: AppStrings.getOr('Time', 'Waktu'),
          value: controller.selectedTime.value.isEmpty
              ? AppStrings.getOr('Pick a time', 'Pilih waktu')
              : controller.selectedTime.value,
          onTap: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
              builder: (ctx, child) => Theme(
                data: Theme.of(ctx).copyWith(
                  colorScheme: const ColorScheme.light(
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.orangeLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.orangeLight, size: 20),
            ),
            const SizedBox(width: 14),
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textMedium,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.orangeLight.withValues(alpha: 0.5), width: 1.5),
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.arrow_drop_down_rounded, color: AppColors.orangeLight),
              ],
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
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.getOr('Meeting Method', 'Metode Pertemuan'),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textMedium,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _MeetToggle(
                    label: AppStrings.getOr('Office', 'Kantor'),
                    value: controller.meetInOffice.value,
                    activeColor: Colors.green,
                    onChanged: controller.toggleMeetInOffice,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MeetToggle(
                    label: 'Zoom',
                    value: controller.meetByZoom.value,
                    activeColor: Colors.deepPurple,
                    onChanged: controller.toggleMeetByZoom,
                  ),
                ),
              ],
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
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: value ? activeColor : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: value ? activeColor : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              value ? Icons.check_circle_rounded : Icons.circle_outlined,
              color: value ? Colors.white : Colors.grey.shade400,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: value ? Colors.white : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
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
      () => SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: controller.isValid
              ? () async => controller.submitAppointment(professionalId: doctorId)
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: controller.isValid ? AppColors.orangeLight : Colors.grey.shade300,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Text(
            AppStrings.get(AppStrings.menuKeyScheduleAppointment),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}
