// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
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
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.profeeesionalList.isEmpty) {
          return const Center(
            child: Text(
              'No professionals available',
              style: TextStyle(color: Colors.black54),
            ),
          );
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
                  height: 262,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: professionals.length,
                    itemBuilder: (context, index) {
                      final doctor = professionals[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: _buildDoctorCard(
                          context,
                          "$BASE_URL/${doctor.picture}",
                          doctor.fullname ?? "",
                          doctor.specialization ?? "",
                          doctor.phoneNumber,
                          doctor,
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

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        AppAssetUtils.svg(AppAssets.handIcon, width: 45, height: 45),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.richBrown,
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

  Widget _buildDoctorCard(
    BuildContext context,
    String image,
    String name,
    String role,
    String? phone,
    dynamic doctor,
  ) {
    return SizedBox(
      width: 180,
      child: Material(
        borderRadius: BorderRadius.circular(14),
        elevation: 3,
        shadowColor: Colors.black.withOpacity(0.15),
        color: AppColors.yellowLight,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            controller.resetSelection();
            Get.toNamed('/appointment_detail', arguments: doctor);
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: image,
                    width: 110,
                    height: 110,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      width: 110,
                      height: 110,
                      color: Colors.grey[200],
                    ),
                    errorWidget: (_, __, ___) => Container(
                      width: 110,
                      height: 110,
                      color: Colors.grey.shade300,
                      alignment: Alignment.center,
                      child: const Icon(Icons.person, size: 40),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  role,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColors.richBrown,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Book Now',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
