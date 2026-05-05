// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/utils/dialog_utils.dart';
import 'package:sehati/app/common/utils/snackbar_utils.dart';
import 'package:sehati/app/data/models/response/merchandise_model.dart';
import 'package:sehati/app/data/services/merchandise_service.dart';
import 'package:sehati/app/common/utils/app_logger.dart';

class MerchandiseController extends GetxController {
  final MerchandiseService _service = MerchandiseService();

  RxBool isLoading = false.obs;
  RxBool isLoadMore = false.obs;
  var loadingId = "".obs;

  RxList<MerchandiseModel> items = <MerchandiseModel>[].obs;

  // PAGINATION
  int limit = 6;
  int offset = 0;
  bool hasMore = true;

  // SEARCH
  RxString searchQuery = "".obs;
  Timer? _debounce;

  final scrollController = ScrollController();

  @override
  void onInit() {
    AppLogger.debug("💎 MerchandiseController: onInit starting");
    super.onInit();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200 &&
          !isLoadMore.value &&
          hasMore) {
        loadMore();
      }
    });

    ever(searchQuery, (_) => _onSearchChanged());
    
    // Add a small delay to ensure the UI is ready
    Future.delayed(const Duration(milliseconds: 500), () {
      AppLogger.debug("💎 MerchandiseController: triggering initial load");
      loadMerchandise();
    });
    
    AppLogger.debug("💎 MerchandiseController: onInit finished");
  }

  void _onSearchChanged() {
    AppLogger.debug("💎 MerchandiseController: search changed to '$searchQuery'");
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      resetAndSearch();
    });
  }

  Future<void> resetAndSearch() async {
    AppLogger.debug("💎 MerchandiseController: resetAndSearch");
    offset = 0;
    hasMore = true;
    items.clear();
    await loadMerchandise();
  }

  Future<void> loadMerchandise() async {
    AppLogger.debug("💎 MerchandiseController: loadMerchandise called, isLoading=${isLoading.value}");
    if (isLoading.value) return;

    isLoading.value = true;
    try {
      AppLogger.debug("💎 MerchandiseController: fetching from service...");
      final result = await _service.getMerchandise(
        limit: limit,
        offset: offset,
        name: searchQuery.value,
      );

      AppLogger.debug("💎 MerchandiseController: fetch result received: ${result?.length ?? 'null'} items");
      if (result != null) {
        if (result.length < limit) {
          hasMore = false;
        }
        items.addAll(result);
      }
    } catch (e) {
      AppLogger.debug("💎 MerchandiseController: ERROR in loadMerchandise: $e");
    } finally {
      isLoading.value = false;
      AppLogger.debug("💎 MerchandiseController: loadMerchandise finished, isLoading=${isLoading.value}");
    }
  }

  Future<void> loadMore() async {
    if (!hasMore || isLoadMore.value) return;

    isLoadMore.value = true;
    try {
      offset += limit;

      final result = await _service.getMerchandise(
        limit: limit,
        offset: offset,
        name: searchQuery.value,
      );

      if (result != null) {
        if (result.length < limit) {
          hasMore = false;
        }
        items.addAll(result);
      }
    } finally {
      isLoadMore.value = false;
    }
  }

  Future<void> claimMerchandise({
    required BuildContext context,
    required String merchId,
  }) async {
    loadingId.value = merchId;
    try {
      final result = await _service.claimMerchandise(merchId);

      Get.back();
      if (result == null) return;

      final status = result["status_code"];
      final message = result["message"];

      if (status == 201) {
        DialogUtils.showCustomDialog(
          context: context,
          content: SizedBox(
            height: 210,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset(
                  AppAssets.surpriseGiftLottie,
                  width: 210,
                  height: 100,
                  fit: BoxFit.fitWidth,
                ),
                const SizedBox(height: 12.0),
                Text(
                  message,
                  style: TextStyle(color: AppColors.black, fontSize: 14.0),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      } else {
        await Future.delayed(const Duration(milliseconds: 500));
        SnackbarUtils.show(isError: true, message);
      }
    } finally {
      loadingId.value = "";
    }
  }

  bool canClaimMerchandise(MerchandiseModel item) {
    if (item.isClaimed == null || item.isClaimed == false) {
      return true;
    }

    if (item.isClaimed == true) {
      if (item.claimStatus == 'rejected') {
        return true;
      }
      return false;
    }

    return false;
  }
}
