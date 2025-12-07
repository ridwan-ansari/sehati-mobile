import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:sehati/app/common/widgets/custom_appbar.dart';
import 'package:sehati/app/data/config/api_config.dart';
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
      body: Obx(() {
        if (controller.profeeesionalList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final grouped = controller.groupedBySpecialization;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: grouped.entries.map((entry) {
            final specialization = entry.key;
            final professionals = entry.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(specialization),
                const SizedBox(height: 12),
                SizedBox(
                  height: 210,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: professionals.length,
                    itemBuilder: (context, index) {
                      final doctor = professionals[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: GestureDetector(
                          onTap: () {
                            print(doctor.id);
                            Get.toNamed(
                              '/appointment_detail',
                              arguments: doctor,
                            );
                          },
                          child: _buildDoctorCard(
                            "$BASE_URL/${doctor.picture}",
                            doctor.fullname ?? "",
                            doctor.specialization ?? "",
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 25),
              ],
            );
          }).toList(),
        );
      }),
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
                AnimatedIn(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
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

  /// --- CARD DOKTER ---
  Widget _buildDoctorCard(String image, String name, String role) {
    return Container(
      width: 190,
      decoration: BoxDecoration(
        color: AppColors.yellowLight,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          AnimatedIn(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                image,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 6),
          AnimatedIn(
            child: Text(
              name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
          ),
          AnimatedIn(
            child: Text(
              role,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
