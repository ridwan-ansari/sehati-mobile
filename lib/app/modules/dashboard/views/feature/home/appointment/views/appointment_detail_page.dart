// ignore_for_file: use_build_context_synchronously, deprecated_member_use

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
    controller.profeeesionalDetail.value = doctor;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            _headerText(doctor),
            Expanded(child: _profileCard(context, doctor)),
          ],
        ),
      ),
    );
  }

  // ============================
  // HEADER
  // ============================
  Widget _headerText(ProfessionalData doctor) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(
      "Set Appointment with ${doctor.fullname}",
      textAlign: TextAlign.center,
      style: const TextStyle(color: Colors.white, fontSize: 14),
    ),
  );

  // ============================
  // PROFILE CARD
  // ============================
  Widget _profileCard(BuildContext context, ProfessionalData doctor) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.amber),
      child: Column(
        children: [
          _doctorProfile(doctor),
          const SizedBox(height: 24),
          if (doctor.phoneNumber!.isNotEmpty)
            InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () async {
                await launchUrl(
                  Uri.parse("https://wa.me/62${doctor.phoneNumber}"),
                  mode: LaunchMode.externalApplication,
                );
              },
              child: Container(
                height: 56,
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppAssetUtils.svg(
                      AppAssets.whatsAppIcon,
                      width: 28,
                      height: 28,
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      "WhatsApp",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 16),
          Obx(() => _datePicker(context)),
          const SizedBox(height: 16),
          Obx(() => _timePicker(context)),
          const SizedBox(height: 20),
          _meetingOptions(),
          const SizedBox(height: 20),
          _confirmButton(),
          // Spacer(),
          // _googleCalendarInfo(),
        ],
      ),
    );
  }

  // ============================
  // DOKTER PROFILE
  // ============================
  Widget _doctorProfile(ProfessionalData doctor) => Row(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 90,
          height: 100,
          child: Image.network(
            "$BASE_URL/${doctor.picture}",
            width: 90,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              doctor.fullname ?? "",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              doctor.specialization ?? "",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black26,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            if (doctor.bio != null && doctor.bio!.isNotEmpty)
              Text(
                doctor.bio!,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black45,
                  height: 1.3,
                ),
              ),
          ],
        ),
      ),
    ],
  );

  // ============================
  // DATE PICKER
  // ============================
  Widget _datePicker(BuildContext context) => _buildPicker(
    icon: Icons.calendar_today,
    label: "Set the date!",
    value: controller.selectedDate.value.isEmpty
        ? "Pick a date"
        : controller.selectedDate.value,

    onTap: () async {
      final professional = controller.profeeesionalDetail.value;

      if (professional.availableDays == null) return;
      DateTime getNearestAvailableDate(DateTime start, AvailableDays days) {
        DateTime date = start;

        while (true) {
          final weekday = date.weekday;

          final allowed =
              (weekday == DateTime.monday && days.monday == true) ||
              (weekday == DateTime.tuesday && days.tuesday == true) ||
              (weekday == DateTime.wednesday && days.wednesday == true) ||
              (weekday == DateTime.thursday && days.thursday == true) ||
              (weekday == DateTime.friday && days.friday == true) ||
              (weekday == DateTime.saturday && days.saturday == true) ||
              (weekday == DateTime.sunday && days.sunday == true);

          if (allowed) return date;

          date = date.add(const Duration(days: 1));
        }
      }

      final initial = getNearestAvailableDate(
        DateTime.now(),
        professional.availableDays!,
      );

      final picked = await showDatePicker(
        context: context,
        initialDate: initial,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
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
        selectableDayPredicate: (day) {
          final d = professional.availableDays!;

          return (day.weekday == DateTime.monday && d.monday == true) ||
              (day.weekday == DateTime.tuesday && d.tuesday == true) ||
              (day.weekday == DateTime.wednesday && d.wednesday == true) ||
              (day.weekday == DateTime.thursday && d.thursday == true) ||
              (day.weekday == DateTime.friday && d.friday == true) ||
              (day.weekday == DateTime.saturday && d.saturday == true) ||
              (day.weekday == DateTime.sunday && d.sunday == true);
        },
      );

      if (picked != null) {
        controller.selectedDate.value = DateFormat('dd/MM/yy').format(picked);
      }
    },
  );

  // ============================
  // TIME PICKER
  // ============================
  Widget _timePicker(BuildContext context) => _buildPicker(
    icon: Icons.access_time,
    label: "Set the time!",
    value: controller.selectedTime.value.isEmpty
        ? "Pick a time"
        : controller.selectedTime.value,
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
        controller.selectedTime.value = picked.format(context);
      }
    },
  );

  Widget _buildPicker({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) => Row(
    children: [
      Icon(icon, color: Colors.deepOrange, size: 45),
      const SizedBox(width: 12),
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.deepOrangeAccent, width: 1.5),
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
          ),
          child: Text(value),
        ),
      ),
    ],
  );

  // ============================
  // MEETING OPTIONS
  // ============================
  Widget _meetingOptions() => Obx(() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: [
            Column(
              children: [
                const Text("Meet her directly\nin the office?"),
                Switch(
                  value: controller.meetInOffice.value,
                  onChanged: controller.toggleMeetInOffice,
                  activeColor: Colors.green,
                ),
              ],
            ),
          ],
        ),
        Column(
          children: [
            const Text("Meet her directly\nby zoom?"),
            Switch(
              value: controller.meetByZoom.value,
              onChanged: controller.toggleMeetByZoom,
              activeColor: Colors.deepPurple,
            ),
          ],
        ),
      ],
    );
  });

  // ============================
  // CONFIRM BUTTON
  // ============================
  Widget _confirmButton() => Obx(() {
    return ElevatedButton(
      onPressed: controller.isValid
          ? () async {
              await controller.submitAppointment();
            }
          : null,

      style: ElevatedButton.styleFrom(
        backgroundColor: controller.isValid ? Colors.deepOrange : Colors.grey,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: const Text(
        "Confirm Appointment",
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  });

  Widget _googleCalendarInfo() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text("Mark on "),
      AppAssetUtils.svg(AppAssets.googleCalIcon, width: 28, height: 28),
    ],
  );
}
