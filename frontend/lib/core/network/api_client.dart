import 'package:dio/dio.dart';

/// Interface for API clients used throughout the application
///
/// This abstract class defines the common functionality that any API client
/// implementation must provide, ensuring consistency across different features.
abstract class ApiClient {
  /// Performs a GET request to the specified endpoint
  ///
  /// [endpoint] is the relative path to the resource
  /// [queryParameters] are optional query parameters to include in the request
  /// [options] are additional Dio request options
  Future<Response<T>> get<T>(
    final String endpoint, {
    final Map<String, dynamic>? queryParameters,
    final Options? options,
  });

  /// Performs a POST request to the specified endpoint
  ///
  /// [endpoint] is the relative path to the resource
  /// [data] is the body of the request
  /// [queryParameters] are optional query parameters to include in the request
  /// [options] are additional Dio request options
  Future<Response<T>> post<T>(
    final String endpoint, {
    final dynamic data,
    final Map<String, dynamic>? queryParameters,
    final Options? options,
  });

  /// Performs a PUT request to the specified endpoint
  ///
  /// [endpoint] is the relative path to the resource
  /// [data] is the body of the request
  /// [queryParameters] are optional query parameters to include in the request
  /// [options] are additional Dio request options
  Future<Response<T>> put<T>(
    final String endpoint, {
    final dynamic data,
    final Map<String, dynamic>? queryParameters,
    final Options? options,
  });

  /// Performs a DELETE request to the specified endpoint
  ///
  /// [endpoint] is the relative path to the resource
  /// [data] is the optional body of the request
  /// [queryParameters] are optional query parameters to include in the request
  /// [options] are additional Dio request options
  Future<Response<T>> delete<T>(
    final String endpoint, {
    final dynamic data,
    final Map<String, dynamic>? queryParameters,
    final Options? options,
  });

  /// Performs a PATCH request to the specified endpoint
  ///
  /// [endpoint] is the relative path to the resource
  /// [data] is the body of the request
  /// [queryParameters] are optional query parameters to include in the request
  /// [options] are additional Dio request options
  Future<Response<T>> patch<T>(
    final String endpoint, {
    final dynamic data,
    final Map<String, dynamic>? queryParameters,
    final Options? options,
  });
}

/// Default implementation of the ApiClient interface using Dio
class DioApiClient implements ApiClient {
  /// Creates a new instance of the API client
  ///
  /// [dio] is the Dio instance to use for HTTP requests
  /// [baseUrl] is the base URL for all API requests
  DioApiClient({required Dio dio, required String baseUrl})
    : _dio = dio,
      _baseUrl = baseUrl;
  final Dio _dio;
  final String _baseUrl;

  @override
  Future<Response<T>> get<T>(
    final String endpoint, {
    final Map<String, dynamic>? queryParameters,
    final Options? options,
  }) => _dio.get<T>(
    '$_baseUrl/$endpoint',
    queryParameters: queryParameters,
    options: options,
  );

  @override
  Future<Response<T>> post<T>(
    final String endpoint, {
    final dynamic data,
    final Map<String, dynamic>? queryParameters,
    final Options? options,
  }) => _dio.post<T>(
    '$_baseUrl/$endpoint',
    data: data,
    queryParameters: queryParameters,
    options: options,
  );

  @override
  Future<Response<T>> put<T>(
    final String endpoint, {
    final dynamic data,
    final Map<String, dynamic>? queryParameters,
    final Options? options,
  }) => _dio.put<T>(
    '$_baseUrl/$endpoint',
    data: data,
    queryParameters: queryParameters,
    options: options,
  );

  @override
  Future<Response<T>> delete<T>(
    final String endpoint, {
    final dynamic data,
    final Map<String, dynamic>? queryParameters,
    final Options? options,
  }) => _dio.delete<T>(
    '$_baseUrl/$endpoint',
    data: data,
    queryParameters: queryParameters,
    options: options,
  );

  @override
  Future<Response<T>> patch<T>(
    final String endpoint, {
    final dynamic data,
    final Map<String, dynamic>? queryParameters,
    final Options? options,
  }) => _dio.patch<T>(
    '$_baseUrl/$endpoint',
    data: data,
    queryParameters: queryParameters,
    options: options,
  );
}
