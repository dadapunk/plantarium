import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:plantarium/core/network/api_client.dart';
import 'package:plantarium/core/network/models/api_response.dart';

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
  factory RetrofitApiClient(final Dio dio, {final String baseUrl}) =
      _RetrofitApiClient;

  /// Creates a new instance with the specified [dio] client and [baseUrl].
  ///
  /// This is a convenient way to create a new instance with custom configuration.
  static RetrofitApiClient create({
    required final Dio dio,
    required final String baseUrl,
  }) => RetrofitApiClient(dio, baseUrl: baseUrl);

  /// Performs a GET request to the specified endpoint.
  ///
  /// [path] The relative path to the resource.
  /// [queryParameters] Optional query parameters to include in the request.
  /// [options] Additional Dio request options.
  @GET('{path}')
  Future<ApiResponse<T>> get<T>(
    @Path('path') final String path, {
    @Queries() final Map<String, dynamic>? queryParameters,
    @DioOptions() final Options? options,
  });

  /// Performs a POST request to the specified endpoint.
  ///
  /// [path] The relative path to the resource.
  /// [data] The body of the request.
  /// [queryParameters] Optional query parameters to include in the request.
  /// [options] Additional Dio request options.
  @POST('{path}')
  Future<ApiResponse<T>> post<T>(
    @Path('path') final String path, {
    @Body() final dynamic data,
    @Queries() final Map<String, dynamic>? queryParameters,
    @DioOptions() final Options? options,
  });

  /// Performs a PUT request to the specified endpoint.
  ///
  /// [path] The relative path to the resource.
  /// [data] The body of the request.
  /// [queryParameters] Optional query parameters to include in the request.
  /// [options] Additional Dio request options.
  @PUT('{path}')
  Future<ApiResponse<T>> put<T>(
    @Path('path') final String path, {
    @Body() final dynamic data,
    @Queries() final Map<String, dynamic>? queryParameters,
    @DioOptions() final Options? options,
  });

  /// Performs a DELETE request to the specified endpoint.
  ///
  /// [path] The relative path to the resource.
  /// [queryParameters] Optional query parameters to include in the request.
  /// [options] Additional Dio request options.
  @DELETE('{path}')
  Future<ApiResponse<T>> delete<T>(
    @Path('path') final String path, {
    @Queries() final Map<String, dynamic>? queryParameters,
    @DioOptions() final Options? options,
  });

  /// Performs a PATCH request to the specified endpoint.
  ///
  /// [path] The relative path to the resource.
  /// [data] The body of the request.
  /// [queryParameters] Optional query parameters to include in the request.
  /// [options] Additional Dio request options.
  @PATCH('{path}')
  Future<ApiResponse<T>> patch<T>(
    @Path('path') final String path, {
    @Body() final dynamic data,
    @Queries() final Map<String, dynamic>? queryParameters,
    @DioOptions() final Options? options,
  });
}
