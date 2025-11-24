// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:sehati/app/common/utils/snackbar_utils.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/data/models/forum_comment_model.dart';
import 'package:sehati/app/data/models/forum_content_model.dart';
import 'package:sehati/app/data/services/local_storage_service.dart';

class ForumService {
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

  Future<List<ForumContentModel>?> getForum({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final token = LocalStorageService.getAccessToken();
      if (token == null || token.isEmpty) {
        SnackbarUtils.show("Token tidak ditemukan. Silakan login ulang.");
        return null;
      }

      final response = await _dio.get(
        "${ApiEndpoints.FORUM_CONTENT}?limit=$limit&offset=$offset",
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List data = response.data['data'];

        return data.map((e) => ForumContentModel.fromJson(e)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'Gagal memuat data');
      }
    } on DioException catch (e) {
      final msg = e.response?.data['message'] ?? '';
      print("Error: $msg");
      return null;
    }
  }

  Future<Map<String, dynamic>?> likePost(String postId) async {
    try {
      final token = LocalStorageService.getAccessToken();

      if (token == null || token.isEmpty) {
        SnackbarUtils.show("Token tidak ditemukan. Silakan login ulang.");
        return null;
      }

      final response = await _dio.post(
        "${ApiEndpoints.FORUM_CONTENT}/$postId/like",
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data["data"];
      }

      return null;
    } on DioException catch (e) {
      final msg = e.response?.data['message'] ?? '';
      SnackbarUtils.show(isError: true, msg);
      return null;
    }
  }

  Future<List<ForumComment>?> getForumDetail(String postId) async {
    try {
      final token = LocalStorageService.getAccessToken();

      if (token == null || token.isEmpty) {
        SnackbarUtils.show("Token tidak ditemukan. Silakan login ulang.");
        return null;
      }

      final response = await _dio.get(
        "${ApiEndpoints.FORUM_CONTENT}/$postId",
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List comments = response.data["data"]["comments"];

        return comments.map((c) => ForumComment.fromJson(c)).toList();
      }

      return null;
    } on DioException catch (e) {
      final msg = e.response?.data['message'] ?? '';
      SnackbarUtils.show(isError: true, msg);
      return null;
    }
  }

  Future<bool> postComment(String postId, String comment) async {
    try {
      final token = LocalStorageService.getAccessToken();

      if (token == null || token.isEmpty) {
        SnackbarUtils.show("Token tidak ditemukan. Silakan login ulang.");
        return false;
      }

      final response = await _dio.post(
        "${ApiEndpoints.FORUM_CONTENT}/$postId/comment",
        queryParameters: {"comment": comment},
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return response.statusCode == 201;
    } on DioException catch (e) {
      final msg = e.response?.data['message'] ?? '';
      SnackbarUtils.show(isError: true, msg);
      return false;
    }
  }
Future<bool> createPost({
  required String caption,
  required String filePath,
}) async {
  try {
    final token = LocalStorageService.getAccessToken();

    if (token == null || token.isEmpty) {
      SnackbarUtils.show("Token tidak ditemukan. Silakan login ulang.");
      return false;
    }

    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        filePath,
        filename: filePath.split("/").last,
      ),
      'caption': caption,
    });

    final response = await _dio.post(
      "${ApiEndpoints.FORUM_CONTENT}/?caption=$caption",
      data: formData,
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      SnackbarUtils.show(isError: false, "Postingan berhasil dibuat");
      return true;
    }

    SnackbarUtils.show("Gagal membuat postingan");
    return false;
  } on DioException catch (e) {
    print("status: ${e.response?.statusCode}");
    print("data  : ${e.response?.data}");
    print("error : ${e.message}");

    final msg = e.response?.data?["message"] ?? "";
    SnackbarUtils.show(isError: true, msg);
    return false;
  }
}

}
