// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:sehati/app/common/utils/snackbar_utils.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/data/models/response/merchandise_model.dart';
import 'package:sehati/app/data/services/local_storage_service.dart';

class MerchandiseService {
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

  Future<List<MerchandiseModel>?> getMerchandise({
    int limit = 20,
    int offset = 0,
    String name = "",
  }) async {
    print("🚀 Fetching merchandise: name='$name', limit=$limit, offset=$offset");
    try {
      final token = LocalStorageService.getAccessToken();
      if (token == null || token.isEmpty) {
        SnackbarUtils.show("Token not found, please login again.");
        return null;
      }

      final response = await _dio.get(
        "${ApiEndpoints.MERCHANDISE}/?name=$name&limit=$limit&offset=$offset",
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      print("RESPONSE : ${response.statusCode}");
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((e) => MerchandiseModel.fromJson(e)).toList();
      } else {
        print("ERROR : ${response.data}");
        throw Exception(response.data['message']);
      }
    } on DioException catch (e) {
      print("ERROR statusCode getMerchandise : ${e.response?.statusCode}");
      print("ERROR error getMerchandise: ${e.message}");
      final msg = e.response?.data['message'] ?? "Failed to load merchandise";
      SnackbarUtils.show(isError: true, msg);
      rethrow;
    }
  }

  Future<Map?> claimMerchandise(String merchId) async {
    final token = LocalStorageService.getAccessToken();
    if (token == null || token.isEmpty) {
      SnackbarUtils.show("Token not found. Please log in again.");
      return {};
    }

    try {
      var response = await _dio.post(
        '${ApiEndpoints.MERCHANDISE}/claim',
        data: FormData.fromMap({'merchandise_id': merchId}),
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );
      print("ERROR : ${response.statusCode}");
      return response.data;
    } catch (e) {
      if (e is DioException) {
      print("ERROR : ${e.response?.statusCode}");
      print("ERROR : ${e.response?.data}");
        SnackbarUtils.show(e.response?.data["message"] ?? "Claim failed");
      } else {
        SnackbarUtils.show("Unexpected error");
      }
    }
    return null;
  }
}
