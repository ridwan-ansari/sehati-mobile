// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:sehati/app/common/widgets/custom_appbar.dart';
import '../controllers/appointment_controller.dart';

class AppointmentDetailPage extends GetView<AppointmentController> {
  const AppointmentDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        logoSvg: AppAssets.doctorIcon,
        onSearchChanged: (_) {},
        onProfileTap: () {},
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _headerText(),
            const SizedBox(height: 20),
            _profileCard(context),
            const SizedBox(height: 20),

            // === BUTTON CONFIRM ===
            Obx(() {
              return ElevatedButton(
                onPressed: controller.isValid
                    ? () async {
                        await controller.signIn();
                        Get.snackbar(
                          "Appointment Confirmed",
                          "Date: ${controller.selectedDate.value}\n"
                          "Time: ${controller.selectedTime.value}\n"
                          "Type: ${controller.meetInOffice.value ? "Office" : "Zoom"}",
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      controller.isValid ? Colors.deepOrange : Colors.grey,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Confirm Appointment",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              );
            }),

            const SizedBox(height: 20),
            _googleCalendarInfo(),
          ],
        ),
      ),
    );
  }

  Widget _headerText() => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF3B2B27),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Text(
          "Set the Appointment with Your Dietisien",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      );

  Widget _profileCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _doctorProfile(),
          const SizedBox(height: 24),
          _datePicker(context),
          const SizedBox(height: 16),
          _timePicker(context),
          const SizedBox(height: 20),
          _meetingOptions(),
        ],
      ),
    );
  }

  Widget _doctorProfile() => Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              "https://akcdn.detik.net.id/visual/2020/05/10/c0b52b51-183c-44bc-8cf3-f39ee0b0d5bb_43.jpeg?w=720&q=90",
              width: 90,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              "Dewi Ariani, S.Gz, Dietisien\nDeskripsi Profile...",
              style: TextStyle(fontSize: 15),
            ),
          ),
        ],
      );

  Widget _datePicker(BuildContext context) => _buildPicker(
        icon: Icons.calendar_today,
        label: "Set the date!",
        value: controller.selectedDate.value.isEmpty
            ? "Pick a date"
            : controller.selectedDate.value,
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime(2100),
          );
          if (picked != null) {
            controller.selectedDate.value =
                DateFormat('dd/MM/yy').format(picked);
          }
        },
      );

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
  }) =>
      Row(
        children: [
          Icon(icon, color: Colors.deepOrange, size: 45),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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

  Widget _meetingOptions() => Obx(() {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                const Text("In Office"),
                Switch(
                  value: controller.meetInOffice.value,
                  onChanged: controller.toggleMeetInOffice,
                  activeColor: Colors.green,
                ),
              ],
            ),
            Column(
              children: [
                const Text("Via Zoom"),
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

  Widget _googleCalendarInfo() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Mark on "),
          AppAssetUtils.svg(AppAssets.googleCalIcon, width: 28, height: 28),
        ],
      );
}
