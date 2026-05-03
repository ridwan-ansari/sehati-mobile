// ignore_for_file: unnecessary_overrides

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sehati/app/data/models/recipe_model.dart';
import 'package:sehati/app/data/services/healthy_service.dart';

class HealthyMenuController extends GetxController {
  final HealthyService _service = HealthyService();
  final searchController = TextEditingController();
  final scrollController = ScrollController();

  var recipes = <RecipeModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  int limit = 10;
  int offset = 0;

  bool hasMore = true;
  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 50) {
        fetchRecipes();
      }
    });
    fetchRecipes(reset: true);
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Future<void> fetchRecipes({bool reset = false}) async {
    try {
      if (reset) {
        offset = 0;
        hasMore = true;
        recipes.clear();
        errorMessage.value = '';
      }
      if (!hasMore) return;
      isLoading.value = true;
      final data = await _service.getRecipes(
        limit: limit,
        offset: offset,
        name: searchController.text,
      );
      if (data != null && data.isNotEmpty) {
        recipes.addAll(data);
        offset += limit;
        hasMore = data.length >= limit;
      }
    } catch (_) {
      errorMessage.value = 'Failed to load recipes. Check your connection.';
    } finally {
      isLoading.value = false;
    }
  }

  void onSearchChanged(String query) {
    fetchRecipes(reset: true);
  }

  void claimPoint(String recipeId) async {
    _service.claimPoint(recipeId: recipeId);
  }
}
