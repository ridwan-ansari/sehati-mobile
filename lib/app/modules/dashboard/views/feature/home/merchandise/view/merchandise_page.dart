import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/localization/app_strings.dart';
import 'package:sehati/app/common/utils/dialog_utils.dart';
import 'package:sehati/app/common/widgets/custom_appbar.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/merchandise/controller/merchandise_controller.dart';

class MerchandisePage extends GetView<MerchandiseController> {
  const MerchandisePage({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint("💎 MerchandisePage: building...");
    return Obx(() {
      debugPrint("💎 MerchandisePage: Obx rebuild, isLoading=${controller.isLoading.value}");
      return Scaffold(
        backgroundColor: AppColors.surface,
        appBar: CustomAppBar(
          title: AppStrings.get(AppStrings.menuKeyMerchandise),
          onSearchChanged: (value) => controller.searchQuery.value = value,
          showBackButton: true,
        ),
        body: Builder(builder: (context) {
          if (controller.isLoading.value && controller.items.isEmpty) {
            return const Center(child: CircularProgressIndicator(color: AppColors.orangeLight));
          }

          if (controller.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.get(AppStrings.merchKeyNoMerch),
                    style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            controller: controller.scrollController,
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 16,
              childAspectRatio: 0.7,
            ),
            itemCount: controller.items.length + (controller.isLoadMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == controller.items.length) {
                return const Center(child: CircularProgressIndicator(color: AppColors.orangeLight));
              }

              final item = controller.items[index];
              return _buildMerchandiseCard(context, item);
            },
          );
        }),
      );
    });
  }

  Widget _buildMerchandiseCard(BuildContext context, item) {
    final fullImage = "$BASE_URL${item.imageUrl}";
    final canClaim = controller.canClaimMerchandise(item);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _showClaimDialog(context, item, canClaim),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: CachedNetworkImage(
                    imageUrl: fullImage,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(color: Colors.grey[100]),
                    errorWidget: (_, __, ___) => const Icon(Icons.broken_image_outlined, color: Colors.grey),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.textDark),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.stars_rounded, size: 14, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          "${item.pricePoints} ${AppStrings.get(AppStrings.menuKeyPoints)}",
                          style: const TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Stock: ${item.stock}",
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showClaimDialog(BuildContext context, item, bool canClaim) {
    controller.loadingId.value = "";
    String getClaimStatusText() {
      if (item.isClaimed != true) return AppStrings.get(AppStrings.merchKeyClaim);
      switch (item.claimStatus) {
        case 'approved': return 'Approved';
        case 'pending': return 'Pending';
        case 'rejected': return 'Rejected';
        default: return '';
      }
    }

    DialogUtils.showCustomDialog(
      context: context,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(AppAssets.merchandiseLottie, width: 120, height: 120),
          const SizedBox(height: 8),
          Text(
            item.name,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Obx(() => SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: canClaim ? AppColors.orangeLight : Colors.grey.shade300,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: canClaim ? () => controller.claimMerchandise(context: context, merchId: item.id) : null,
              child: controller.loadingId.value == item.id
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text(getClaimStatusText(), style: const TextStyle(fontWeight: FontWeight.w800)),
            ),
          )),
        ],
      ),
    );
  }
}
