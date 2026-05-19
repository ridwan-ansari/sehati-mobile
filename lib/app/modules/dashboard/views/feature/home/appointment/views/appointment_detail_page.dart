// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/localization/app_strings.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:sehati/app/common/utils/snackbar_utils.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/data/models/response/professional_res_model.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/appointment_controller.dart';
import '../utils/appointment_schedule_formatter.dart';

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
                  _TimePickerRow(controller: controller, doctor: doctor),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            doctor.fullname ?? '',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        if (hasPhone)
                          GestureDetector(
                            onTap: () async {
                              final uri = Uri.parse('https://wa.me/62${doctor.phoneNumber}');
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri, mode: LaunchMode.externalApplication);
                              }
                            },
                            child: AppAssetUtils.svg(
                              AppAssets.whatsAppIcon,
                              width: 28,
                              height: 28,
                            ),
                          ),
                      ],
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
                      _ExpandableBio(text: doctor.bio!),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ExpandableBio extends StatefulWidget {
  const _ExpandableBio({required this.text});

  final String text;

  @override
  State<_ExpandableBio> createState() => _ExpandableBioState();
}

class _ExpandableBioState extends State<_ExpandableBio> {
  static const int _collapsedLines = 3;
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final bodyStyle = TextStyle(
      fontSize: 12,
      color: Colors.white.withValues(alpha: 0.7),
      height: 1.5,
    );
    final actionStyle = const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w800,
      color: Colors.white,
      height: 1.5,
      decoration: TextDecoration.underline,
      decorationColor: Colors.white70,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final painter = TextPainter(
          text: TextSpan(text: widget.text, style: bodyStyle),
          maxLines: _collapsedLines,
          textDirection: Directionality.of(context),
        )..layout(maxWidth: constraints.maxWidth);

        final overflows = painter.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.text,
              style: bodyStyle,
              maxLines: _expanded ? null : _collapsedLines,
              overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
            if (overflows) ...[
              const SizedBox(height: 6),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => setState(() => _expanded = !_expanded),
                child: Text(
                  _expanded
                      ? AppStrings.getOr('Show less', 'Sembunyikan')
                      : AppStrings.getOr('Read more', 'Selengkapnya'),
                  style: actionStyle,
                ),
              ),
            ],
          ],
        );
      },
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
          onTap: () => _pickDate(context),
        ));
  }

  Future<void> _pickDate(BuildContext context) async {
    final hours = doctor.availableHours;
    if (hours == null || hours.isEmpty) {
      SnackbarUtils.show(AppStrings.getOr(
        'The professional has not set their availability schedule yet.',
        'Profesional belum mengatur jadwal ketersediaan.',
      ));
      return;
    }

    DateTime nearestAvailable(DateTime start) {
      var d = start;
      for (var i = 0; i < 365; i++) {
        if (hours.isOpenOnWeekday(d.weekday)) return d;
        d = d.add(const Duration(days: 1));
      }
      return start;
    }

    final initial = nearestAvailable(DateTime.now());
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
      selectableDayPredicate: (day) => hours.isOpenOnWeekday(day.weekday),
    );

    if (picked != null) {
      controller.selectedDate.value = DateFormat('dd/MM/yy').format(picked);
      // Reset time: the new day may have a different availability window.
      controller.selectedTime.value = '';
    }
  }
}

class _TimePickerRow extends StatelessWidget {
  const _TimePickerRow({required this.controller, required this.doctor});

  final AppointmentController controller;
  final ProfessionalData doctor;

  @override
  Widget build(BuildContext context) {
    return Obx(() => _PickerRow(
          icon: Icons.access_time_rounded,
          label: AppStrings.getOr('Time', 'Waktu'),
          value: controller.selectedTime.value.isEmpty
              ? AppStrings.getOr('Pick a time', 'Pilih waktu')
              : controller.selectedTime.value,
          onTap: () => _pickTime(context),
        ));
  }

  Future<void> _pickTime(BuildContext context) async {
    if (controller.selectedDate.value.isEmpty) {
      SnackbarUtils.show(AppStrings.getOr(
        'Please pick a date first.',
        'Silakan pilih tanggal terlebih dahulu.',
      ));
      return;
    }

    final date = DateFormat('dd/MM/yy').parse(controller.selectedDate.value);
    final window = doctor.availableHours?.forWeekday(date.weekday);
    if (window == null) {
      SnackbarUtils.show(AppStrings.getOr(
        'The professional is not available on the selected day.',
        'Profesional tidak tersedia pada hari yang dipilih.',
      ));
      return;
    }

    final slots = AppointmentScheduleFormatter.generateSlots(window);
    final picked = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _SlotPickerSheet(
        weekdayLabel: AppointmentScheduleFormatter.localizedDay(date.weekday),
        window: window,
        slots: slots,
        initiallySelected: controller.selectedTime.value,
      ),
    );

    if (picked != null) {
      controller.selectedTime.value = picked;
    }
  }
}

class _SlotPickerSheet extends StatelessWidget {
  const _SlotPickerSheet({
    required this.weekdayLabel,
    required this.window,
    required this.slots,
    required this.initiallySelected,
  });

  final String weekdayLabel;
  final DayHours window;
  final List<String> slots;
  final String initiallySelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              '${AppStrings.getOr('Available', 'Tersedia')} $weekdayLabel: ${window.start} – ${window.end}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 16),
            if (slots.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    AppStrings.getOr('No slots available', 'Tidak ada slot tersedia'),
                    style: const TextStyle(color: Colors.black54),
                  ),
                ),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: slots.map((slot) {
                  final selected = slot == initiallySelected;
                  return ChoiceChip(
                    label: Text(slot),
                    selected: selected,
                    selectedColor: AppColors.orangeLight,
                    backgroundColor: AppColors.orangeLight.withValues(alpha: 0.08),
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : AppColors.textDark,
                      fontWeight: FontWeight.w700,
                    ),
                    side: BorderSide(
                      color: selected
                          ? AppColors.orangeLight
                          : AppColors.orangeLight.withValues(alpha: 0.3),
                    ),
                    onSelected: (_) => Navigator.of(context).pop(slot),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
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
    return Column(
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
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.deepPurple, width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.videocam_rounded,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                AppStrings.getOr('Online (Zoom)', 'Online (Zoom)'),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
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
