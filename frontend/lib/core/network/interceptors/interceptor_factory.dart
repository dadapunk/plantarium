import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:plantarium/core/config/app_config.dart';

import 'cache_interceptor.dart';
import 'error_interceptor.dart';
import 'logging_interceptor.dart';
import 'retry_interceptor.dart';

/// Factory for creating and configuring interceptors.
///
/// This class simplifies the setup of Dio interceptors by providing methods
/// to create preconfigured interceptor instances.
class InterceptorFactory {
  // Private constructor to prevent instantiation
  InterceptorFactory._();

  /// Creates all standard interceptors based on the provided configuration.
  ///
  /// The interceptors are added in the correct order for proper request/response handling.
  static Future<List<Interceptor>> createStandardInterceptors({
    required AppConfig config,
    SharedPreferences? prefs,
  }) async {
    final interceptors = <Interceptor>[];

    // Cache interceptor (if prefs is provided)
    if (prefs != null) {
      interceptors.add(
        CacheInterceptor(
          prefs: prefs,
          defaultMaxAge: const Duration(minutes: 30),
          debug: config.enableLogging,
        ),
      );
    }

    // Add retry interceptor for automatic retries
    interceptors.add(RetryInterceptor());

    // Add error interceptor for standard error handling
    interceptors.add(ErrorInterceptor(debug: config.enableLogging));

    // Add logging interceptor conditionally based on config
    if (config.enableLogging) {
      interceptors.add(LoggingInterceptor());
    }

    return interceptors;
  }

  /// Sets up a Dio instance with standard interceptors.
  static Future<Dio> createDioWithStandardInterceptors({
    required AppConfig config,
    SharedPreferences? prefs,
    List<Interceptor>? additionalInterceptors,
  }) async {
    // Create the Dio instance with basic configuration
    final dio = Dio(
      BaseOptions(
        baseUrl: config.apiBaseUrl,
        connectTimeout: config.timeoutDuration,
        receiveTimeout: config.timeoutDuration,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Create and add standard interceptors
    final standardInterceptors = await createStandardInterceptors(
      config: config,
      prefs: prefs,
    );
    dio.interceptors.addAll(standardInterceptors);

    // Add any additional interceptors
    if (additionalInterceptors != null && additionalInterceptors.isNotEmpty) {
      dio.interceptors.addAll(additionalInterceptors);
    }

    return dio;
  }
}
