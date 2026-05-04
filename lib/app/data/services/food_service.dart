import 'package:dio/dio.dart';
import 'package:sehati/app/data/config/dio_factory.dart';
import 'package:sehati/app/common/utils/snackbar_utils.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/data/models/response/food_diary_analysis_model.dart';
import 'package:sehati/app/data/models/response/food_model.dart';
import 'package:sehati/app/data/models/response/nutrition_calculator.dart';
import 'package:sehati/app/data/models/response/nutrition_res_model.dart';
import 'package:sehati/app/data/services/local_storage_service.dart';

class FoodService {
  final Dio _dio = DioFactory.create();

  // ---------------------------------------------------------------------------
  // GET ALL FOOD
  // ---------------------------------------------------------------------------
  Future<List<FoodModel>?> getFood() async {
    try {
      final token = LocalStorageService.getAccessToken();
      if (token == null || token.isEmpty) {
        SnackbarUtils.show("Token not found. Please log in again.");
        return null;
      }

      final response = await _dio.get(
        ApiEndpoints.FOOD,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((e) => FoodModel.fromJson(e)).toList();
      }
      SnackbarUtils.show(response.data['message'] ?? 'An error occurred');
      return null;
    } on DioException catch (e) {
      final msg =
          e.response?.data?['message'] ?? e.message ?? "An error occurred";
      SnackbarUtils.show(isError: true, msg);
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // GET FOOD WITH SEARCH + LIMIT + OFFSET
  // ---------------------------------------------------------------------------
  Future<List<FoodModel>?> getFoodSearch({
    required String name,
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final token = LocalStorageService.getAccessToken();
      if (token == null || token.isEmpty) {
        SnackbarUtils.show("Token not found. Please log in again.");
        return null;
      }

      final response = await _dio.get(
        "${ApiEndpoints.FOOD}?name=$name&limit=$limit&offset=$offset",
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((e) => FoodModel.fromJson(e)).toList();
      }
      SnackbarUtils.show(response.data['message'] ?? "An error occurred");
      return null;
    } on DioException catch (e) {
      final msg =
          e.response?.data?['message'] ?? e.message ?? "An error occurred";
      SnackbarUtils.show(isError: true, msg);
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // SUBMIT FOOD ANSWERS
  // ---------------------------------------------------------------------------
  Future<bool> submitFood({
    required String activity,
    required int desiredEnergyRequirement,
    required List<Map<String, dynamic>> data,
  }) async {
    try {
      final token = LocalStorageService.getAccessToken();
      if (token == null || token.isEmpty) {
        SnackbarUtils.show("Token not found. Please log in again.");
        return false;
      }

      final body = {
        "activity": activity,
        "desired_energy_requirement": desiredEnergyRequirement,
        "data": data,
      };
      final response = await _dio.post(
        ApiEndpoints.FOOD_ANSWER,
        data: body,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        SnackbarUtils.show(
            isError: false, response.data['message'] ?? "Success");
        return true;
      }
      SnackbarUtils.show(response.data['message'] ?? "An error occurred");
      return false;
    } on DioException catch (e) {
      final msg =
          e.response?.data?['message'] ?? e.message ?? "An error occurred";
      SnackbarUtils.show(msg);
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // GET LATEST NUTRITION
  // ---------------------------------------------------------------------------
  Future<NutritionData?> getLatestNutrition() async {
    try {
      final token = LocalStorageService.getAccessToken();
      if (token == null || token.isEmpty) {
        SnackbarUtils.show("Token not found. Please log in again.");
        return null;
      }

      final response = await _dio.get(
        ApiEndpoints.NUTRITION_LATEST,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        return NutritionData.fromJson(response.data['data']);
      }
      SnackbarUtils.show(
        response.data['message'] ?? "An error occurred",
        isError: true,
      );
      return null;
    } on DioException catch (e) {
      final msg =
          e.response?.data?['message'] ?? e.message ?? "An error occurred";
      SnackbarUtils.show(isError: true, msg);
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // NUTRITION CALCULATOR
  // ---------------------------------------------------------------------------
  Future<NutritionCalculator?> calculateNutrition({
    required String dob,
    required String gender,
    required double weight,
    required double height,
    required String activity,
  }) async {
    try {
      final token = LocalStorageService.getAccessToken();
      if (token == null || token.isEmpty) {
        SnackbarUtils.show("Token not found. Please log in again.");
        return null;
      }

      final headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final data = FormData.fromMap({
        'dob': dob,
        'gender': gender,
        'weight': weight.toString(),
        'height': height.toString(),
        'activity': activity,
      });

      final response = await _dio.post(
        ApiEndpoints.NUTRITION_CALCULATOR,
        data: data,
        options: Options(headers: headers),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return NutritionCalculator.fromJson(response.data["data"]);
      }
      SnackbarUtils.show(response.data['message'] ?? "An error occurred",
          isError: true);
      return null;
    } on DioException catch (e) {
      final msg =
          e.response?.data?['message'] ?? e.message ?? "An error occurred";
      SnackbarUtils.show(isError: true, msg);
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // GET FOOD DIARY ANALYSIS
  // ---------------------------------------------------------------------------
  Future<List<FoodDiaryAnalysis>?> getDiaryAnalysis({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final token = LocalStorageService.getAccessToken();
      if (token == null || token.isEmpty) {
        SnackbarUtils.show("Token not found. Please log in again.");
        return null;
      }

      final response = await _dio.get(
        "${ApiEndpoints.FOOD_DIARY_ANALYSIS}?limit=$limit&offset=$offset",
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((e) => FoodDiaryAnalysis.fromJson(e)).toList();
      }
      SnackbarUtils.show(response.data['message'] ?? "An error occurred");
      return null;
    } on DioException catch (e) {
      final msg =
          e.response?.data?['message'] ?? e.message ?? "An error occurred";
      SnackbarUtils.show(isError: true, msg);
      return null;
    }
  }

}
