// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sehati/app/data/config/dio_factory.dart';
import 'package:sehati/app/common/utils/snackbar_utils.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/data/models/response/merchandise_model.dart';
import 'package:sehati/app/data/services/local_storage_service.dart';

class MerchandiseService {
  final Dio _dio = DioFactory.create();

  Future<List<MerchandiseModel>?> getMerchandise({
    int limit = 20,
    int offset = 0,
    String name = "",
  }) async {
    debugPrint("💎 MerchandiseService: getMerchandise started (name='$name')");
    try {
      final token = LocalStorageService.getAccessToken();
      debugPrint("💎 MerchandiseService: token retrieved (empty? ${token?.isEmpty ?? 'true'})");
      
      if (token == null || token.isEmpty) {
        SnackbarUtils.show("Token not found, please login again.");
        return null;
      }

      final url = "${ApiEndpoints.MERCHANDISE}/?name=$name&limit=$limit&offset=$offset";
      debugPrint("💎 MerchandiseService: GET $url");
      
      final response = await _dio.get(
        url,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      
      debugPrint("💎 MerchandiseService: response status code: ${response.statusCode}");
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        debugPrint("💎 MerchandiseService: mapping ${data.length} items");
        return data.map((e) => MerchandiseModel.fromJson(e)).toList();
      }
      debugPrint("💎 MerchandiseService: ERROR status code: ${response.statusCode}, body: ${response.data}");
      SnackbarUtils.show(response.data['message'] ?? "An error occurred");
      return null;
    } on DioException catch (e) {
      debugPrint("💎 MerchandiseService: DioException - ${e.type}, message: ${e.message}, response: ${e.response?.statusCode}");
      debugPrint("ERROR statusCode getMerchandise : ${e.response?.statusCode}");
      debugPrint("ERROR error getMerchandise: ${e.message}");
      final msg =
          e.response?.data?['message'] ?? e.message ?? "An error occurred";
      SnackbarUtils.show(isError: true, msg);
      return null;
    } catch (e) {
      debugPrint("GENERIC ERROR getMerchandise: $e");
      SnackbarUtils.show(isError: true, "Failed to load merchandise data");
      return null;
    }
  }

  Future<Map?> claimMerchandise(String merchId) async {
    final token = LocalStorageService.getAccessToken();
    if (token == null || token.isEmpty) {
      SnackbarUtils.show("Token not found. Please log in again.");
      return {};
    }

    try {
      EasyLoading.show(status: "Processing claim...");
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
      EasyLoading.dismiss();
      if (response.statusCode == 200 || response.statusCode == 201) {
        SnackbarUtils.show(
            isError: false, response.data['message'] ?? "Success");
        return response.data;
      }
      SnackbarUtils.show(response.data['message'] ?? "An error occurred");
      return null;
    } on DioException catch (e) {
      EasyLoading.dismiss();
      print("ERROR : ${e.response?.statusCode}");
      print("ERROR : ${e.response?.data}");
      final msg =
          e.response?.data?['message'] ?? e.message ?? "An error occurred";
      SnackbarUtils.show(msg);
      return null;
    } catch (e) {
      EasyLoading.dismiss();
      SnackbarUtils.show("An error occurred");
      return null;
    }
  }
}
