import 'package:dio/dio.dart';
import 'package:sehati/app/common/utils/snackbar_utils.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/data/models/video_model.dart';
import 'package:sehati/app/data/services/local_storage_service.dart';

class EdutainmentService {
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

  // ---------------------------------------------------------------------------
  // GET VIDEO LIST (with search + pagination)
  // ---------------------------------------------------------------------------
  Future<List<VideoModel>?> getVideos({
    int limit = 10,
    int offset = 0,
    String? search,
  }) async {
    try {
      final token = await LocalStorageService.getAccessToken();
      if (token == null || token.isEmpty) {
        SnackbarUtils.show("Token not found. Please log in again.");
        return null;
      }

      print("limit ${limit}");
      print("offset ${offset}");
      print("search ${search}");

      final response = await _dio.get(
        ApiEndpoints.VIDEO,
        queryParameters: {
          'limit': limit,
          'offset': offset,
          if (search != null && search.isNotEmpty) 'title': search,
        },
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      print("response get vide : ${response.statusCode}");
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((e) => VideoModel.fromJson(e)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'Gagal memuat data video');
      }
    } on DioException catch (e) {
      final msg = e.response?.data['message'] ?? e.error;
      SnackbarUtils.show(isError: true, msg + "${e.response?.statusCode}");
      return null;
    }
  }

  Future<bool> claimReward(String videoId) async {
  try {
    final token = await LocalStorageService.getAccessToken();
    if (token == null || token.isEmpty) {
      SnackbarUtils.show("Token not found. Please login.");
      return false;
    }

    final response = await _dio.post(
      ApiEndpoints.VIDEO_CLAIM_REWARD,
      data: {
        "video_id": videoId,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      ),
    );

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  } on DioException catch (e) {
    final msg = e.response?.data['message'] ?? e.message;
    SnackbarUtils.show(isError: true, msg);
    return false;
  }
}

}
