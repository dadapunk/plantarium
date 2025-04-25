import 'package:dio/dio.dart';

/// Interceptor that retries failed requests based on certain conditions.
class RetryInterceptor extends Interceptor {
  static const maxRetries = 3;
  static const retryableStatusCodes = [408, 500, 502, 503, 504];

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    final response = err.response;

    // Don't retry if we've already retried too many times
    final retryCount = options.extra['retryCount'] as int? ?? 0;
    if (retryCount >= maxRetries) {
      return handler.next(err);
    }

    // Only retry on specific status codes
    if (response != null &&
        !retryableStatusCodes.contains(response.statusCode)) {
      return handler.next(err);
    }

    // Don't retry on certain error types
    if (err.type == DioExceptionType.cancel ||
        err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      return handler.next(err);
    }

    // Add retry count to request options
    options.extra['retryCount'] = retryCount + 1;

    // Calculate delay with exponential backoff
    final delay = Duration(milliseconds: 1000 * (1 << retryCount));
    await Future.delayed(delay);

    // Retry the request
    try {
      final response = await err.requestOptions.dio.fetch(options);
      handler.resolve(response);
    } catch (e) {
      handler.next(err);
    }
  }
}
