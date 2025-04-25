import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

/// Interceptor that logs API requests and responses.
class LoggingInterceptor extends Interceptor {
  final Logger _logger;

  LoggingInterceptor() : _logger = Logger();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.i('''
🚀 Request: ${options.method} ${options.uri}
Headers: ${options.headers}
Query Parameters: ${options.queryParameters}
Body: ${options.data}
''');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logger.i('''
✅ Response: ${response.statusCode} ${response.statusMessage}
Headers: ${response.headers}
Body: ${response.data}
''');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.e('''
❌ Error: ${err.type}
Status: ${err.response?.statusCode}
Message: ${err.message}
Response: ${err.response?.data}
''');
    handler.next(err);
  }
}
