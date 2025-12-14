// ignore_for_file: unnecessary_overrides

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sehati/app/data/models/recipe_model.dart';
import 'package:sehati/app/data/services/healthy_service.dart';
import 'package:sehati/app/common/utils/snackbar_utils.dart';

class HealthyMenuController extends GetxController {
  final HealthyService _service = HealthyService();
  final searchController = TextEditingController();
  final scrollController = ScrollController();

  var recipes = <RecipeModel>[].obs;
  var isLoading = false.obs;

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
        if (data.length < limit) {
          hasMore = false;
        } else {
          hasMore = true;
        }
      } else {
        SnackbarUtils.show("No recipes to show here");
      }
    } catch (_) {
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
