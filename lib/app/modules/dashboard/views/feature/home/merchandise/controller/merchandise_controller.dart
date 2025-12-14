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
    super.onInit();

    loadMerchandise();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200 &&
          !isLoadMore.value &&
          hasMore) {
        loadMore();
      }
    });

    ever(searchQuery, (_) => _onSearchChanged());
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      resetAndSearch();
    });
  }

  Future<void> resetAndSearch() async {
    offset = 0;
    hasMore = true;
    items.clear();
    await loadMerchandise();
  }

  Future<void> loadMerchandise() async {
    if (isLoading.value) return;

    isLoading.value = true;

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

    isLoading.value = false;
  }

  Future<void> loadMore() async {
    if (!hasMore) return;

    isLoadMore.value = true;

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

    isLoadMore.value = false;
  }

  Future<void> claimMerchandise({
    required BuildContext context,
    required String merchId,
  }) async {
    loadingId.value = merchId;
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
    loadingId.value = "";
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
