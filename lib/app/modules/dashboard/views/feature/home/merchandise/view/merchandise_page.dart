import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/utils/dialog_utils.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/merchandise/controller/merchandise_controller.dart';

class MerchandisePage extends GetView<MerchandiseController> {
  const MerchandisePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.richBrown,
        foregroundColor: Colors.white,
        title: const Text("Merchandise"),
      ),
      body: Column(
        children: [
          // 🔍 SEARCH BAR
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              onChanged: (value) {
                controller.searchQuery.value = value;
              },
              decoration: InputDecoration(
                hintText: "Search merchandise...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.items.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.orangeLight,
                  ),
                );
              }

              if (controller.items.isEmpty) {
                return const Center(child: Text("No merchandise found"));
              }

              return GridView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount:
                    controller.items.length +
                    (controller.isLoadMore.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == controller.items.length) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.orangeLight,
                      ),
                    );
                  }

                  final item = controller.items[index];
                  final fullImage = "$BASE_URL${item.imageUrl}";
                  final canClaim = controller.canClaimMerchandise(item);
                  String getClaimStatusText() {
                    if (item.isClaimed != true) return 'Belum diklaim';

                    switch (item.claimStatus) {
                      case 'approved':
                        return 'Approved';
                      case 'pending':
                        return 'Pending';
                      case 'rejected':
                        return 'Rejected';
                      default:
                        return '';
                    }
                  }

                  Color getClaimStatusColor() {
                    switch (item.claimStatus) {
                      case 'approved':
                        return Colors.green;
                      case 'pending':
                        return Colors.orange;
                      case 'rejected':
                        return Colors.white;
                      default:
                        return Colors.white;
                    }
                  }

                  return GestureDetector(
                    onTap: () {
                      controller.loadingId.value = "";
                      DialogUtils.showCustomDialog(
                        context: context,
                        content: SizedBox(
                          height: 172,
                          child: Column(
                            children: [
                              Lottie.asset(
                                AppAssets.merchandiseLottie,
                                width: 100,
                                height: 100,
                                fit: BoxFit.contain,
                              ),
                              AnimatedIn(
                                child: Text(
                                  item.name,
                                  style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 14.0,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Obx(
                                () => ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: canClaim
                                        ? AppColors.orangeLight
                                        : Colors.grey.shade400,
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: canClaim
                                      ? () => controller.claimMerchandise(
                                          context: context,
                                          merchId: item.id,
                                        )
                                      : null,
                                  child: controller.loadingId.value == item.id
                                      ? const SizedBox(
                                          height: 18,
                                          width: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : AnimatedIn(
                                          child: Text(
                                            canClaim
                                                ? "Claim"
                                                : getClaimStatusText(),
                                            style: TextStyle(
                                              color: getClaimStatusColor(),
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: AnimatedIn(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: fullImage,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  placeholder: (_, __) => Container(
                                    color: Colors.grey[200],
                                  ),
                                  errorWidget: (_, __, ___) =>
                                      const Icon(Icons.broken_image_outlined),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AnimatedIn(
                                  child: Text(
                                    item.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                AnimatedIn(
                                  child: Text(
                                    "Points: ${item.pricePoints}",
                                    style: TextStyle(
                                      color: Colors.orange.shade700,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                AnimatedIn(
                                  child: Text(
                                    "Stock: ${item.stock}",
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
