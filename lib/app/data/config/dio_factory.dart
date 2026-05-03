import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:sehati/app/data/services/language_service.dart';

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
