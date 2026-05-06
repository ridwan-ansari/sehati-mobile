import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/localization/app_strings.dart';
import 'package:sehati/app/common/widgets/custom_appbar.dart';
import 'package:sehati/app/data/config/api_config.dart';
import '../controllers/appointment_controller.dart';

class AppointmentPage extends GetView<AppointmentController> {
  const AppointmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: CustomAppBar(
        logoSvg: AppAssets.doctorIcon,
        title: AppStrings.get(AppStrings.menuKeyAppointment),
        showBackButton: true,
      ),
      body: RefreshIndicator(
        color: AppColors.orangeLight,
        onRefresh: () async => controller.loadProfessionals(),
        child: Obx(() {
          if (controller.isLoading.value && controller.profeeesionalList.isEmpty) {
            return const Center(child: CircularProgressIndicator(color: AppColors.orangeLight));
          }

          return controller.profeeesionalList.isEmpty
              ? Center(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Center(
                        child: Text(
                          AppStrings.getOr('No counselors available', 'Belum ada konselor tersedia'),
                          style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  itemCount: controller.groupedBySpecialization.length,
                  itemBuilder: (context, index) {
                    final entry = controller.groupedBySpecialization.entries.elementAt(index);
                    final specialization = entry.key;
                    final counselors = entry.value;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader(specialization),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 250,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: counselors.length,
                            itemBuilder: (context, idx) {
                              final doctor = counselors[idx];
                              return _buildCounselorCard(doctor);
                            },
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    );
                  },
                );
        }),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: AppColors.orangeLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
              letterSpacing: -0.5,
            ),
          ),
          const Spacer(),
          const Icon(Icons.chevron_right_rounded, color: Colors.grey, size: 20),
        ],
      ),
    );
  }

  Widget _buildCounselorCard(dynamic doctor) {
    
    return Container(
      width: 170,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            controller.resetSelection();
            Get.toNamed('/appointment_detail', arguments: doctor);
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CachedNetworkImage(
                        imageUrl: "$BASE_URL/${doctor.picture}",
                        width: double.infinity,
                        height: 120,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          height: 120,
                          color: Colors.grey[100],
                        ),
                        errorWidget: (_, __, ___) => Container(
                          height: 120,
                          color: Colors.grey[100],
                          alignment: Alignment.center,
                          child: const Icon(Icons.person, size: 40, color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  doctor.fullname ?? "",
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  doctor.specialization ?? "",
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.black45,
                  ),
                ),
                const Spacer(),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.orangeLight.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    AppStrings.get(AppStrings.menuKeyBookNow),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.orangeLight,
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
