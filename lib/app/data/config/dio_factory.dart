import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/utils/app_logger.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/data/services/language_service.dart';
import 'package:sehati/app/data/services/local_storage_service.dart';
import 'package:sehati/app/routes/app_routes.dart';

class DioFactory {
  static Dio create({
    Duration connectTimeout = const Duration(seconds: 10),
    Duration receiveTimeout = const Duration(seconds: 10),
    bool includeContentType = true,
  }) {
    final dio = Dio(
      BaseOptions(
        headers: {
          if (includeContentType) 'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout,
      ),
    );
    dio.interceptors.add(_LanguageInterceptor());
    dio.interceptors.add(_AuthInterceptor(dio));
    return dio;
  }
}

class _LanguageInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    try {
      final lang = Get.find<LanguageService>().currentLanguage.value;
      options.headers['Accept-Language'] = lang;
    } catch (_) {
      // LanguageService not yet available; omit header
    }
    handler.next(options);
  }
}

/// Handles 401 transparently: attempts /refresh once, retries the failed
/// request, or silently logs the user out (no snackbar/message) when the
/// refresh also fails. The user is routed to /login so they understand
/// re-authentication is required without any error text shown.
class _AuthInterceptor extends Interceptor {
  _AuthInterceptor(this._dio);

  final Dio _dio;

  static const _retryFlag = '_retried_after_refresh';
  static Future<bool>? _inflightRefresh;
  static bool _redirecting = false;

  bool _isAuthEndpoint(String url) {
    return url.contains('/api/auth/login') ||
        url.contains('/api/auth/register') ||
        url.contains('/api/auth/refresh') ||
        url.contains('/api/auth/reset-password') ||
        url.contains('/api/auth/verify/account');
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final status = err.response?.statusCode;
    final requestUrl = err.requestOptions.uri.toString();
    final alreadyRetried = err.requestOptions.extra[_retryFlag] == true;

    if (status != 401 || _isAuthEndpoint(requestUrl) || alreadyRetried) {
      return handler.next(err);
    }

    final refreshToken = LocalStorageService.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      await _forceLogout();
      return handler.next(err);
    }

    _inflightRefresh ??= _refresh(refreshToken);
    final refreshed = await _inflightRefresh!;
    _inflightRefresh = null;

    if (!refreshed) {
      await _forceLogout();
      return handler.next(err);
    }

    try {
      final newToken = LocalStorageService.getAccessToken();
      final retryOptions = err.requestOptions
        ..headers['Authorization'] = 'Bearer $newToken'
        ..extra[_retryFlag] = true;

      final response = await _dio.fetch(retryOptions);
      return handler.resolve(response);
    } on DioException catch (retryErr) {
      if (retryErr.response?.statusCode == 401) {
        await _forceLogout();
      }
      return handler.next(retryErr);
    } catch (_) {
      return handler.next(err);
    }
  }

  Future<bool> _refresh(String refreshToken) async {
    try {
      final refreshDio = Dio(
        BaseOptions(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $refreshToken',
          },
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      final response = await refreshDio.post(ApiEndpoints.REFRESH_TOKEN);
      if (response.statusCode == 200 && response.data?['data'] != null) {
        final data = response.data['data'];
        final newAccess = data['access_token'];
        final newRefresh = data['refresh_token'];
        if (newAccess is String && newAccess.isNotEmpty) {
          await LocalStorageService.setAccessToken(newAccess);
        }
        if (newRefresh is String && newRefresh.isNotEmpty) {
          await LocalStorageService.setRefreshToken(newRefresh);
        }
        return newAccess is String && newAccess.isNotEmpty;
      }
      return false;
    } catch (e) {
      AppLogger.log('Refresh token failed silently: $e');
      return false;
    }
  }

  Future<void> _forceLogout() async {
    if (_redirecting) return;
    _redirecting = true;
    await LocalStorageService.clearTokens();
    Future.microtask(() {
      try {
        if (Get.currentRoute != AppRoutes.LOGIN) {
          Get.offAllNamed(AppRoutes.LOGIN);
        }
      } catch (_) {
        // Get navigator may not be ready; ignore.
      } finally {
        _redirecting = false;
      }
    });
  }
}
