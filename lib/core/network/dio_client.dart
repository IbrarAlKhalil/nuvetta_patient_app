import 'package:dio/dio.dart';
import '../config/env.dart';

class DioClient {
  static final Dio dio = _createDio();

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: Env.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // Add interceptor for logging
    dio.interceptors.add(LoggingInterceptor());

    return dio;
  }
}

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print(
      '🔵 [Dio Request] ${options.method} ${options.baseUrl}${options.path}',
    );
    print('📤 Headers: ${options.headers}');
    print('📤 Data: ${options.data}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
      '🟢 [Dio Response] ${response.statusCode} ${response.requestOptions.path}',
    );
    print('📥 Data: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('🔴 [Dio Error] ${err.type}: ${err.message}');
    print('📍 URL: ${err.requestOptions.baseUrl}${err.requestOptions.path}');
    print('⏱️  Base URL: ${err.requestOptions.baseUrl}');
    super.onError(err, handler);
  }
}
