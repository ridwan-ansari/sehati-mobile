import 'package:dio/dio.dart';
import 'package:sehati/app/common/utils/snackbar_utils.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/data/models/leaderboard_model.dart';
import 'package:sehati/app/data/services/local_storage_service.dart';

class LeaderboardService {
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

  /// GET LEADERBOARD
  Future<List<LeaderboardModel>?> getLeaderboard() async {
    try {
      final token = LocalStorageService.getAccessToken();
      if (token == null || token.isEmpty) {
        SnackbarUtils.show("Token not found. Please log in again.");
        return null;
      }

      final response = await _dio.get(
        ApiEndpoints.LEADERBOARD,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((e) => LeaderboardModel.fromJson(e)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'Gagal memuat leaderboard');
      }
    } on DioException catch (e) {
      final msg = e.response?.data['message'] ?? 'Gagal memuat leaderboard';
      SnackbarUtils.show(isError: true, msg);
      rethrow;
    }
  }
}
