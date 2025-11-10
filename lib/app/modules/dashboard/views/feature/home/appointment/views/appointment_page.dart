import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:sehati/app/common/widgets/custom_appbar.dart';
import '../controllers/appointment_controller.dart';

class AppointmentPage extends GetView<AppointmentController> {
  const AppointmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        logoSvg: AppAssets.doctorIcon,
        onSearchChanged: (value) {},
        onProfileTap: () {},
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader("Choose The Dietisien"),
            const SizedBox(height: 10),
            _buildDoctorGrid([
              {
                "image":
                    "https://akcdn.detik.net.id/visual/2020/05/10/c0b52b51-183c-44bc-8cf3-f39ee0b0d5bb_43.jpeg?w=720&q=90",
                "name": "Dewi Ariani, S.Gz",
                "role": "Dietisien",
              },
              {
                "image":
                    "https://i.pinimg.com/236x/d7/40/8a/d7408aba4d15c64473e4b1474faa22ef.jpg",
                "name": "Ridwan Anrari, S.Gz",
                "role": "Dietisien",
              },
            ]),
            const SizedBox(height: 30),
            _buildSectionHeader("Choose The Psychologist"),
            const SizedBox(height: 10),
            _buildDoctorGrid([
              {
                "image":
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQoULTREr8U2LeFynYw8OjOUf0Ew6WIrhPvcQ&s",
                "name": "Ridwan Ansari",
                "role": "Psikolog",
              },
              {
                "image":
                    "https://akcdn.detik.net.id/community/media/visual/2020/03/23/2e288e7d-c953-4e60-b4c5-c25f2a54fa6d.jpeg?q=90&w=480",
                "name": "Diah Pratami",
                "role": "Psikolog",
              },
            ]),
          ],
        ),
      ),
    );
  }

  /// --- HEADER SECTION ---
  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        AppAssetUtils.svg(AppAssets.hendIcon, width: 45, height: 45),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF3B2B27),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                Row(
                  children: const [
                    Icon(Icons.circle, size: 8, color: Colors.white),
                    SizedBox(width: 6),
                    Icon(Icons.circle, size: 8, color: Colors.white),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// --- GRID OF DOCTORS ---
  Widget _buildDoctorGrid(List<Map<String, String>> doctors) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFE082),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: doctors.map((doctor) {
          return GestureDetector(
            onTap: () {
              Get.toNamed('/appointment_detail');
            },
            child: _buildDoctorCard(
              doctor["image"]!,
              doctor["name"]!,
              doctor["role"]!,
            ),
          );
        }).toList(),
      ),
    );
  }

  /// --- INDIVIDUAL DOCTOR CARD ---
  Widget _buildDoctorCard(String image, String name, String role) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            image,
            width: 130,
            height: 130,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          role,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
            color: Colors.black54,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
