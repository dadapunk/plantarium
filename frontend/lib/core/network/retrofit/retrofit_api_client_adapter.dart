import 'package:dio/dio.dart';
import '../api_client.dart';
import 'api_client.dart';

/// An adapter that implements the [ApiClient] interface using [RetrofitApiClient].
///
/// This class adapts the Retrofit-based client to conform to the general
/// [ApiClient] interface, allowing it to be used wherever an [ApiClient]
/// is required.
class RetrofitApiClientAdapter implements ApiClient {
  final RetrofitApiClient _retrofitClient;
  final String _baseUrl;

  /// Creates a new instance of the adapter with the given Retrofit client.
  ///
  /// [retrofitClient] The Retrofit client to use for making API requests.
  /// [baseUrl] The base URL for all API requests.
  RetrofitApiClientAdapter({
    required RetrofitApiClient retrofitClient,
    required String baseUrl,
  }) : _retrofitClient = retrofitClient,
       _baseUrl = baseUrl;

  /// Creates a new instance of the adapter with a new Retrofit client.
  ///
  /// [dio] The Dio HTTP client to use for making requests.
  /// [baseUrl] The base URL for all API requests.
  factory RetrofitApiClientAdapter.create({
    required Dio dio,
    required String baseUrl,
  }) {
    final retrofitClient = RetrofitApiClient.create(dio: dio, baseUrl: baseUrl);
    return RetrofitApiClientAdapter(
      retrofitClient: retrofitClient,
      baseUrl: baseUrl,
    );
  }

  @override
  Future<Response<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final response = await _retrofitClient.get<T>(
      endpoint,
      queryParameters: queryParameters,
      options: options,
    );

    // Convert ApiResponse to Dio Response to match the ApiClient interface
    return Response<T>(
      requestOptions: RequestOptions(path: '$_baseUrl/$endpoint'),
      data: response.data as T,
      statusCode: 200,
    );
  }

  @override
  Future<Response<T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final response = await _retrofitClient.post<T>(
      endpoint,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );

    return Response<T>(
      requestOptions: RequestOptions(path: '$_baseUrl/$endpoint'),
      data: response.data as T,
      statusCode: 201,
    );
  }

  @override
  Future<Response<T>> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final response = await _retrofitClient.put<T>(
      endpoint,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );

    return Response<T>(
      requestOptions: RequestOptions(path: '$_baseUrl/$endpoint'),
      data: response.data as T,
      statusCode: 200,
    );
  }

  @override
  Future<Response<T>> delete<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final response = await _retrofitClient.delete<T>(
      endpoint,
      queryParameters: queryParameters,
      options: options,
    );

    return Response<T>(
      requestOptions: RequestOptions(path: '$_baseUrl/$endpoint'),
      data: response.data as T,
      statusCode: 200,
    );
  }

  @override
  Future<Response<T>> patch<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final response = await _retrofitClient.patch<T>(
      endpoint,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );

    return Response<T>(
      requestOptions: RequestOptions(path: '$_baseUrl/$endpoint'),
      data: response.data as T,
      statusCode: 200,
    );
  }
}
