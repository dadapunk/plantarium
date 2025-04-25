import 'package:dio/dio.dart';
import '../interceptors/error_interceptor.dart';
import '../interceptors/logging_interceptor.dart';
import '../interceptors/retry_interceptor.dart';
import '../models/api_response.dart';
import '../models/api_error.dart';

/// A wrapper around Dio for making HTTP requests to the NestJS backend.
class ApiClient {
  final Dio _dio;
  final String baseUrl;

  /// Creates a new [ApiClient] instance.
  ///
  /// [baseUrl] is the base URL for all API requests.
  /// [timeout] is the timeout duration for requests in seconds.
  /// [enableLogging] determines whether to enable request/response logging.
  ApiClient({
    required this.baseUrl,
    int timeout = 30,
    bool enableLogging = false,
  }) : _dio = Dio(
         BaseOptions(
           baseUrl: baseUrl,
           connectTimeout: Duration(seconds: timeout),
           receiveTimeout: Duration(seconds: timeout),
           headers: {
             'Content-Type': 'application/json',
             'Accept': 'application/json',
           },
         ),
       ) {
    _setupInterceptors(enableLogging);
  }

  void _setupInterceptors(bool enableLogging) {
    _dio.interceptors.addAll([
      ErrorInterceptor(),
      RetryInterceptor(),
      if (enableLogging) LoggingInterceptor(),
    ]);
  }

  /// Converts dynamic response data to a Map<String, dynamic>.
  Map<String, dynamic> _normalizeResponseData(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data;
    }
    return {'success': true, 'message': 'Success', 'data': data};
  }

  /// Sends a GET request to the specified [path].
  ///
  /// [queryParameters] are added to the URL as query parameters.
  /// Returns an [ApiResponse] containing the parsed response data.
  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(Object? json)? fromJson,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      final normalizedData = _normalizeResponseData(response.data);
      return ApiResponse<T>.fromJson(
        normalizedData,
        fromJson ?? (json) => json as T,
      );
    } on DioException catch (e) {
      throw ApiError.fromDioException(e);
    }
  }

  /// Sends a POST request to the specified [path].
  ///
  /// [data] is the request body to be sent.
  /// Returns an [ApiResponse] containing the parsed response data.
  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Options? options,
    T Function(Object? json)? fromJson,
  }) async {
    try {
      final response = await _dio.post(path, data: data, options: options);
      final normalizedData = _normalizeResponseData(response.data);
      return ApiResponse<T>.fromJson(
        normalizedData,
        fromJson ?? (json) => json as T,
      );
    } on DioException catch (e) {
      throw ApiError.fromDioException(e);
    }
  }

  /// Sends a PUT request to the specified [path].
  ///
  /// [data] is the request body to be sent.
  /// Returns an [ApiResponse] containing the parsed response data.
  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    Options? options,
    T Function(Object? json)? fromJson,
  }) async {
    try {
      final response = await _dio.put(path, data: data, options: options);
      final normalizedData = _normalizeResponseData(response.data);
      return ApiResponse<T>.fromJson(
        normalizedData,
        fromJson ?? (json) => json as T,
      );
    } on DioException catch (e) {
      throw ApiError.fromDioException(e);
    }
  }

  /// Sends a DELETE request to the specified [path].
  ///
  /// Returns an [ApiResponse] containing the parsed response data.
  Future<ApiResponse<T>> delete<T>(
    String path, {
    Options? options,
    T Function(Object? json)? fromJson,
  }) async {
    try {
      final response = await _dio.delete(path, options: options);
      final normalizedData = _normalizeResponseData(response.data);
      return ApiResponse<T>.fromJson(
        normalizedData,
        fromJson ?? (json) => json as T,
      );
    } on DioException catch (e) {
      throw ApiError.fromDioException(e);
    }
  }

  /// Sends a PATCH request to the specified [path].
  ///
  /// [data] is the request body to be sent.
  /// Returns an [ApiResponse] containing the parsed response data.
  Future<ApiResponse<T>> patch<T>(
    String path, {
    dynamic data,
    Options? options,
    T Function(Object? json)? fromJson,
  }) async {
    try {
      final response = await _dio.patch(path, data: data, options: options);
      final normalizedData = _normalizeResponseData(response.data);
      return ApiResponse<T>.fromJson(
        normalizedData,
        fromJson ?? (json) => json as T,
      );
    } on DioException catch (e) {
      throw ApiError.fromDioException(e);
    }
  }
}
