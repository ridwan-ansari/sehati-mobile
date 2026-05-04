// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sehati/app/data/config/dio_factory.dart';
import 'package:sehati/app/common/utils/snackbar_utils.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/data/models/forum_comment_model.dart';
import 'package:sehati/app/data/models/forum_content_model.dart';
import 'package:sehati/app/data/services/local_storage_service.dart';

class ForumService {
  final Dio _dio = DioFactory.create();

  Future<List<ForumContentModel>?> getForum({
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
      }
      SnackbarUtils.show(response.data['message'] ?? 'An error occurred');
      return null;
    } on DioException catch (e) {
      final msg =
          e.response?.data?['message'] ?? e.message ?? 'An error occurred';
      print("Error: $msg");
      SnackbarUtils.show(isError: true, msg);
      return null;
    }
  }

  Future<Map<String, dynamic>?> likePost(String postId) async {
    try {
      final token = LocalStorageService.getAccessToken();

      if (token == null || token.isEmpty) {
        SnackbarUtils.show("Token not found. Please log in again.");
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
      EasyLoading.dismiss();
      final msg =
          e.response?.data?['message'] ?? e.message ?? 'An error occurred';
      SnackbarUtils.show(isError: true, msg);
      return null;
    }
  }

  Future<List<ForumComment>?> getForumDetail(String postId) async {
    try {
      final token = LocalStorageService.getAccessToken();

      if (token == null || token.isEmpty) {
        SnackbarUtils.show("Token not found. Please log in again.");
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
      EasyLoading.dismiss();
      final msg =
          e.response?.data?['message'] ?? e.message ?? 'An error occurred';
      SnackbarUtils.show(isError: true, msg);
      return null;
    }
  }

  Future<bool> postComment(String postId, String comment) async {
    try {
      final token = LocalStorageService.getAccessToken();

      if (token == null || token.isEmpty) {
        SnackbarUtils.show("Token not found. Please log in again.");
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
      if (response.statusCode == 201 || response.statusCode == 200) {
        SnackbarUtils.show(
            isError: false, response.data['message'] ?? "Success");
        return true;
      }
      return false;
    } on DioException catch (e) {
      EasyLoading.dismiss();
      final msg =
          e.response?.data?['message'] ?? e.message ?? 'An error occurred';
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
        SnackbarUtils.show("Token not found. Please log in again.");
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
        EasyLoading.dismiss();
        SnackbarUtils.show(
            isError: false, response.data['message'] ?? "Success");
        return true;
      }

      EasyLoading.dismiss();
      SnackbarUtils.show(response.data['message'] ?? "An error occurred");
      return false;
    } on DioException catch (e) {
      EasyLoading.dismiss();
      print("status: ${e.response?.statusCode}");
      print("data  : ${e.response?.data}");
      print("error : ${e.message}");

      final msg =
          e.response?.data?["message"] ?? e.message ?? "An error occurred";
      SnackbarUtils.show(isError: true, msg);
      return false;
    }
  }

}
