import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/data/models/video_model.dart';
import 'package:sehati/app/data/services/edutainment_service.dart';

class EdutainmentController extends GetxController {
  final EdutainmentService _service = EdutainmentService();
  final searchController = TextEditingController();

  var isLoading = false.obs;
  var isLoadMore = false.obs;
  var errorMessage = ''.obs;
  var videos = <VideoModel>[].obs;
  var hasMore = true.obs;

  int limit = 10;
  int offset = 0;

  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    loadVideos(reset: true);

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        loadMore();
      }
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  // ------------------------------------------
  // LOAD AWAL / SEARCH (reset offset)
  // ------------------------------------------
  Future<void> loadVideos({bool reset = false}) async {
    if (reset) {
      offset = 0;
      hasMore.value = true;
      videos.clear();
      errorMessage.value = '';
    }

    if (reset) {
      isLoading.value = true;
    }

    try {
      final response = await _service.getVideos(
        limit: limit,
        offset: 0,
        search: searchController.text,
      );

      if (response != null) {
        videos.assignAll(response);
        hasMore.value = response.length == limit;
      }
    } catch (_) {
      errorMessage.value = 'Failed to load videos. Check your connection.';
    } finally {
      isLoading.value = false;
    }
  }

  // ------------------------------------------
  // LOAD MORE (increment offset)
  // ------------------------------------------
  Future<void> loadMore() async {
    if (isLoadMore.value || !hasMore.value) return;

    isLoadMore.value = true;

    offset += limit;

    try {
      final result = await _service.getVideos(
        offset: offset,
        limit: limit,
        search: searchController.text,
      );

      if (result != null && result.isNotEmpty) {
        videos.addAll(result);
        hasMore.value = result.length == limit;
      } else {
        hasMore.value = false; // Tidak ada lagi data
      }
    } catch (_) {
      // Keep existing data
    } finally {
      isLoadMore.value = false;
    }
  }

  // ------------------------------------------
  // SEARCH INPUT
  // ------------------------------------------
  void onSearchChanged(String query) {
    loadVideos(reset: true);
  }
}
