
import 'package:dio/dio.dart';
import 'package:sehati/app/common/localization/app_strings.dart';
import 'package:sehati/app/data/config/dio_factory.dart';
import 'package:sehati/app/common/utils/snackbar_utils.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/data/models/video_model.dart';
import 'package:sehati/app/data/services/local_storage_service.dart';
import 'package:sehati/app/common/utils/app_logger.dart';

class EdutainmentService {
  final Dio _dio = DioFactory.create();

  // ---------------------------------------------------------------------------
  // GET VIDEO LIST (with search + pagination)
  // ---------------------------------------------------------------------------
  Future<List<VideoModel>?> getVideos({
    int limit = 10,
    int offset = 0,
    String? search,
  }) async {
    try {
      final token = LocalStorageService.getAccessToken();
      if (token == null || token.isEmpty) {
        SnackbarUtils.show(AppStrings.get(AppStrings.commonKeyTokenNotFound));
        return null;
      }

      final response = await _dio.get(
        ApiEndpoints.VIDEO,
        queryParameters: {
          'limit': limit,
          'offset': offset,
          if (search != null && search.isNotEmpty) 'title': search,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((e) => VideoModel.fromJson(e)).toList();
      } else {
        throw Exception(response.data['message'] ?? AppStrings.get(AppStrings.snackKeyLoadFailed));
      }
    } on DioException catch (e) {
      final msg = e.response?.data['message'] ?? e.message ?? AppStrings.get(AppStrings.snackKeyLoadFailed);
      SnackbarUtils.show(isError: true, msg);
      return null;
    }
  }

  Future<bool> claimReward(String videoId) async {
    try {
      final token = LocalStorageService.getAccessToken();
      if (token == null || token.isEmpty) {
        SnackbarUtils.show(AppStrings.get(AppStrings.commonKeyTokenNotFound));
        return false;
      }

      final response = await _dio.post(
        ApiEndpoints.VIDEO_CLAIM_REWARD,
        data: {"video_id": videoId},
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            'Content-Type': 'application/x-www-form-urlencoded',
            'Accept': 'application/json',
          },
        ),
      );

      AppLogger.log("CLAIM YOUTUBE STATUS : ${response.statusCode}");
      AppLogger.log("CLAIM YOUTUBE STATUS : ${response.data}");
      if (response.statusCode == 201) {
        return true;
      }

      return false;
    } on DioException catch (e) {
      AppLogger.log("[E]CLAIM YOUTUBE STATUS : ${e.response?.statusCode}");
      AppLogger.log("[E]CLAIM YOUTUBE STATUS : ${e.response?.data}");
      SnackbarUtils.show(
          isError: true,
          e.response?.data['message'] ?? e.message ?? AppStrings.get(AppStrings.commonKeyError));
      return false;
    }
  }
}
