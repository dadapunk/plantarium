import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/api_error.dart';
import 'logging_interceptor.dart';
import 'cache_interceptor.dart';

/// Factory for creating and configuring API client interceptors
class InterceptorFactory {
  /// Creates standard interceptors for the API client
  static Future<List<Interceptor>> createStandardInterceptors({
    bool enableLogging = true,
    bool enableCaching = true,
  }) async {
    final interceptors = <Interceptor>[];

    // Add cache interceptor if enabled
    if (enableCaching) {
      final prefs = await SharedPreferences.getInstance();
      interceptors.add(CacheInterceptor(prefs: prefs));
    }

    // Add logging interceptor if enabled
    if (enableLogging) {
      interceptors.add(LoggingInterceptor());
    }

    return interceptors;
  }

  /// Sets up a Dio instance with standard interceptors
  static Future<Dio> createDioWithStandardInterceptors({
    required String baseUrl,
    Duration timeout = const Duration(seconds: 30),
    bool enableLogging = true,
    bool enableCaching = true,
  }) async {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: timeout,
        receiveTimeout: timeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add standard interceptors
    dio.interceptors.addAll(
      await createStandardInterceptors(
        enableLogging: enableLogging,
        enableCaching: enableCaching,
      ),
    );

    return dio;
  }
}
