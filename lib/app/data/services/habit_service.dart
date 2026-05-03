import 'package:dio/dio.dart';
import 'package:sehati/app/data/config/dio_factory.dart';
import 'package:sehati/app/common/utils/snackbar_utils.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/data/models/response/habit_question_model.dart';
import 'package:sehati/app/data/services/local_storage_service.dart';

class HabitService {
  final Dio _dio = DioFactory.create();

  /// GET ALL EXERCISE QUESTIONS
  Future<List<HabitQuestionModel>?> getFoodQuestions() async {
    try {
      final token = LocalStorageService.getAccessToken();
      if (token == null || token.isEmpty) {
        SnackbarUtils.show("Token not found. Please log in again.");
        return null;
      }
      final response = await _dio.get(
        ApiEndpoints.HABIT_LIST,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((e) => HabitQuestionModel.fromJson(e)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'Gagal memuat soal');
      }
    } on DioException catch (e) {
      final msg = e.response?.data['message'] ?? '';
  
      SnackbarUtils.show(isError: true, msg);
      rethrow;
    }
  }

  Future<bool> submiteHabitAnswer({
    required List<Map<String, dynamic>> answers,
  }) async {
    try {
      final token = LocalStorageService.getAccessToken();
      if (token == null || token.isEmpty) {
        SnackbarUtils.show("Token not found. Please log in again.");
        return false;
      }

      final body = {"answers": answers};
      final response = await _dio.post(
        ApiEndpoints.HABIT_ANSWER,
        data: body,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 201) {
        SnackbarUtils.show(isError: false, "Answer sent successfully");
        return true;
      } else {
        SnackbarUtils.show(
          response.data['message'] ?? "Failed to send reply",
        );
        return false;
      }
    } on DioException catch (e) {
      final msg = e.response?.data['message'] ?? "Failed to send reply";
      SnackbarUtils.show(msg + "(${e.response?.statusCode})");
      return false;
    }
  }
}
