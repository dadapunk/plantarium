import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/api_error.dart';
import 'logging_interceptor.dart';

/// Factory for creating and configuring API client interceptors
class InterceptorFactory {
  /// Creates standard interceptors for the API client
  static List<Interceptor> createStandardInterceptors({
    bool enableLogging = true,
  }) {
    final interceptors = <Interceptor>[];

    // Add logging interceptor if enabled
    if (enableLogging) {
      interceptors.add(LoggingInterceptor());
    }

    return interceptors;
  }

  /// Sets up a Dio instance with standard interceptors
  static Dio createDioWithStandardInterceptors({
    required String baseUrl,
    Duration timeout = const Duration(seconds: 30),
    bool enableLogging = true,
  }) {
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
      createStandardInterceptors(enableLogging: enableLogging),
    );

    return dio;
  }
}
