import 'package:get/get.dart';
import 'package:sehati/app/data/models/recipe_model.dart';
import 'package:sehati/app/data/services/healthy_service.dart';
import 'package:sehati/app/common/utils/snackbar_utils.dart';

class HealthyMenuController extends GetxController {
  final HealthyService _service = HealthyService();

  var recipes = <RecipeModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRecipes();
  }

  Future<void> fetchRecipes() async {
    try {
      isLoading.value = true;
      final data = await _service.getRecipes();
      if (data != null) {
        recipes.assignAll(data);
      } else {
        SnackbarUtils.show("No recipes to show here");
      }
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }
}
