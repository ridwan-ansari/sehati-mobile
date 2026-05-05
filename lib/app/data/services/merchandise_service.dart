
import 'package:dio/dio.dart';
import 'package:sehati/app/common/utils/loading_utils.dart';
import 'package:sehati/app/common/localization/app_strings.dart';
import 'package:sehati/app/data/config/dio_factory.dart';
import 'package:sehati/app/common/utils/snackbar_utils.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/data/models/response/merchandise_model.dart';
import 'package:sehati/app/data/services/local_storage_service.dart';
import 'package:sehati/app/common/utils/app_logger.dart';

class MerchandiseService {
  final Dio _dio = DioFactory.create();

  Future<List<MerchandiseModel>?> getMerchandise({
    int limit = 20,
    int offset = 0,
    String name = "",
  }) async {
    AppLogger.debug("💎 MerchandiseService: getMerchandise started (name='$name')");
    try {
      final token = LocalStorageService.getAccessToken();
      AppLogger.debug("💎 MerchandiseService: token retrieved (empty? ${token?.isEmpty ?? 'true'})");
      
      if (token == null || token.isEmpty) {
        SnackbarUtils.show(AppStrings.get(AppStrings.commonKeyTokenNotFound));
        return null;
      }

      final url = "${ApiEndpoints.MERCHANDISE}/?name=$name&limit=$limit&offset=$offset";
      AppLogger.debug("💎 MerchandiseService: GET $url");
      
      final response = await _dio.get(
        url,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      
      AppLogger.debug("💎 MerchandiseService: response status code: ${response.statusCode}");
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        AppLogger.debug("💎 MerchandiseService: mapping ${data.length} items");
        return data.map((e) => MerchandiseModel.fromJson(e)).toList();
      }
      AppLogger.debug("💎 MerchandiseService: ERROR status code: ${response.statusCode}, body: ${response.data}");
      SnackbarUtils.show(response.data['message'] ?? "An error occurred");
      return null;
    } on DioException catch (e) {
      AppLogger.debug("💎 MerchandiseService: DioException - ${e.type}, message: ${e.message}, response: ${e.response?.statusCode}");
      AppLogger.debug("ERROR statusCode getMerchandise : ${e.response?.statusCode}");
      AppLogger.debug("ERROR error getMerchandise: ${e.message}");
      final msg =
          e.response?.data?['message'] ?? e.message ?? "An error occurred";
      SnackbarUtils.show(isError: true, msg);
      return null;
    } catch (e) {
      AppLogger.debug("GENERIC ERROR getMerchandise: $e");
      SnackbarUtils.show(isError: true, "Failed to load merchandise data");
      return null;
    }
  }

  Future<Map?> claimMerchandise(String merchId) async {
    final token = LocalStorageService.getAccessToken();
    if (token == null || token.isEmpty) {
      SnackbarUtils.show(AppStrings.get(AppStrings.commonKeyTokenNotFound));
      return {};
    }

    try {
      LoadingUtils.show(AppStrings.get(AppStrings.commonKeyProcessing));
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
      LoadingUtils.hide();
      if (response.statusCode == 200 || response.statusCode == 201) {
        SnackbarUtils.show(
            isError: false, response.data['message'] ?? AppStrings.get(AppStrings.commonKeySuccess));
        return response.data;
      }
      SnackbarUtils.show(response.data['message'] ?? AppStrings.get(AppStrings.commonKeyError));
      return null;
    } on DioException catch (e) {
      LoadingUtils.hide();
      AppLogger.log("ERROR : ${e.response?.statusCode}");
      AppLogger.log("ERROR : ${e.response?.data}");
      final msg =
          e.response?.data?['message'] ?? e.message ?? AppStrings.get(AppStrings.commonKeyError);
      SnackbarUtils.show(msg);
      return null;
    } catch (e) {
      LoadingUtils.hide();
      SnackbarUtils.show(AppStrings.get(AppStrings.commonKeyError));
      return null;
    }
  }
}
