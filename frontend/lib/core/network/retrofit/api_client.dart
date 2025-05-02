import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../api_client.dart';
import '../models/api_response.dart';

part 'api_client.g.dart';

/// A Retrofit implementation of the [ApiClient] interface.
///
/// This class uses code generation to create type-safe API methods
/// with minimal boilerplate code.
@RestApi()
abstract class RetrofitApiClient {
  /// Factory constructor that creates a new instance of the API client.
  ///
  /// [dio] is the Dio HTTP client to use for making requests.
  /// [baseUrl] is the base URL for all API requests.
  factory RetrofitApiClient(Dio dio, {String baseUrl}) = _RetrofitApiClient;

  /// Creates a new instance with the specified [dio] client and [baseUrl].
  ///
  /// This is a convenient way to create a new instance with custom configuration.
  static RetrofitApiClient create({required Dio dio, required String baseUrl}) {
    return RetrofitApiClient(dio, baseUrl: baseUrl);
  }

  /// Performs a GET request to the specified endpoint.
  ///
  /// [path] The relative path to the resource.
  /// [queryParameters] Optional query parameters to include in the request.
  /// [options] Additional Dio request options.
  @GET('{path}')
  Future<ApiResponse<T>> get<T>(
    @Path('path') String path, {
    @Queries() Map<String, dynamic>? queryParameters,
    @DioOptions() Options? options,
  });

  /// Performs a POST request to the specified endpoint.
  ///
  /// [path] The relative path to the resource.
  /// [data] The body of the request.
  /// [queryParameters] Optional query parameters to include in the request.
  /// [options] Additional Dio request options.
  @POST('{path}')
  Future<ApiResponse<T>> post<T>(
    @Path('path') String path, {
    @Body() dynamic data,
    @Queries() Map<String, dynamic>? queryParameters,
    @DioOptions() Options? options,
  });

  /// Performs a PUT request to the specified endpoint.
  ///
  /// [path] The relative path to the resource.
  /// [data] The body of the request.
  /// [queryParameters] Optional query parameters to include in the request.
  /// [options] Additional Dio request options.
  @PUT('{path}')
  Future<ApiResponse<T>> put<T>(
    @Path('path') String path, {
    @Body() dynamic data,
    @Queries() Map<String, dynamic>? queryParameters,
    @DioOptions() Options? options,
  });

  /// Performs a DELETE request to the specified endpoint.
  ///
  /// [path] The relative path to the resource.
  /// [queryParameters] Optional query parameters to include in the request.
  /// [options] Additional Dio request options.
  @DELETE('{path}')
  Future<ApiResponse<T>> delete<T>(
    @Path('path') String path, {
    @Queries() Map<String, dynamic>? queryParameters,
    @DioOptions() Options? options,
  });

  /// Performs a PATCH request to the specified endpoint.
  ///
  /// [path] The relative path to the resource.
  /// [data] The body of the request.
  /// [queryParameters] Optional query parameters to include in the request.
  /// [options] Additional Dio request options.
  @PATCH('{path}')
  Future<ApiResponse<T>> patch<T>(
    @Path('path') String path, {
    @Body() dynamic data,
    @Queries() Map<String, dynamic>? queryParameters,
    @DioOptions() Options? options,
  });
}
