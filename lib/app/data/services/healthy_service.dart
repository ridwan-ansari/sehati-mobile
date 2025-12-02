import 'package:dio/dio.dart';
import 'package:sehati/app/common/utils/snackbar_utils.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/data/models/recipe_model.dart';
import 'package:sehati/app/data/services/local_storage_service.dart';

class HealthyService {
  final Dio _dio = Dio(
    BaseOptions(
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<List<RecipeModel>?> getRecipes() async {
    try {
      final token = LocalStorageService.getAccessToken();
      if (token == null || token.isEmpty) {
        SnackbarUtils.show("Token not found. Please log in again.");
        return null;
      }

      final response = await _dio.get(
        ApiEndpoints.RECIPE,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      print("recipe : ${response.statusCode}");
      print("recipe : ${response.data}");

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((e) => RecipeModel.fromJson(e)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'Gagal memuat resep');
      }
    } on DioException catch (e) {
      final msg = e.response?.data['message'] ?? 'Gagal memuat resep';
      SnackbarUtils.show(isError: true, msg);
      rethrow;
    }
  }
}
