import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:plantarium/core/errors/app_exception.dart';

/// Interceptor that handles API errors and converts them to [AppException] instances.
class ErrorInterceptor extends Interceptor {
  /// Creates a new error interceptor.
  ///
  /// [debug] enables debug logging.
  ErrorInterceptor({bool debug = false}) : _debug = debug;
  final bool _debug;

  @override
  void onError(final DioException err, final ErrorInterceptorHandler handler) {
    _logDebug('Error: ${err.type} - ${err.message}');

    // Create an app exception from the Dio error
    final appException = _mapDioErrorToAppException(err);

    // Reject with the modified exception
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: appException,
        response: err.response,
        type: err.type,
        message: appException.message,
      ),
    );
  }

  /// Maps a Dio error to an app exception.
  AppException _mapDioErrorToAppException(final DioException err) {
    final statusCode = err.response?.statusCode;

    _logDebug('Status code: $statusCode');

    // Map by status code
    if (statusCode != null) {
      switch (statusCode) {
        case 400:
          return ApiException(
            message: _extractErrorMessage(err) ?? 'Bad request',
            errorCode: 'BAD_REQUEST',
            details: _extractErrorDetails(err),
          );

        case 401:
          return AuthException(
            message: _extractErrorMessage(err) ?? 'Unauthorized',
            errorCode: 'UNAUTHORIZED',
            details: _extractErrorDetails(err),
          );

        case 403:
          return AuthException(
            message: _extractErrorMessage(err) ?? 'Forbidden',
            errorCode: 'FORBIDDEN',
            details: _extractErrorDetails(err),
          );

        case 404:
          return ApiException(
            message: _extractErrorMessage(err) ?? 'Resource not found',
            errorCode: 'NOT_FOUND',
            details: _extractErrorDetails(err),
          );

        case 409:
          return ApiException(
            message: _extractErrorMessage(err) ?? 'Conflict',
            errorCode: 'CONFLICT',
            details: _extractErrorDetails(err),
          );

        case 422:
          return ApiException(
            message: _extractErrorMessage(err) ?? 'Validation error',
            errorCode: 'VALIDATION_ERROR',
            details: _extractErrorDetails(err),
          );

        case 500:
        case 501:
        case 502:
        case 503:
        case 504:
          return ApiException(
            message: _extractErrorMessage(err) ?? 'Server error',
            errorCode: 'SERVER_ERROR',
            details: _extractErrorDetails(err),
          );

        default:
          return ApiException(
            message: _extractErrorMessage(err) ?? 'API error',
            errorCode: 'API_ERROR',
            details: _extractErrorDetails(err),
          );
      }
    }

    // Map by error type
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: 'Connection timed out',
          errorCode: 'TIMEOUT',
          details: {
            'type': err.type.toString(),
            'uri': err.requestOptions.uri.toString(),
          },
        );

      case DioExceptionType.badCertificate:
        return ApiException(
          message: 'Bad SSL certificate',
          errorCode: 'BAD_CERTIFICATE',
          details: {'uri': err.requestOptions.uri.toString()},
        );

      case DioExceptionType.connectionError:
        return ApiException(
          message: 'Connection error',
          errorCode: 'CONNECTION_ERROR',
          details: {'uri': err.requestOptions.uri.toString()},
        );

      case DioExceptionType.cancel:
        return ApiException(
          message: 'Request cancelled',
          errorCode: 'REQUEST_CANCELLED',
          details: {'uri': err.requestOptions.uri.toString()},
        );

      default:
        return ApiException(
          message: err.message ?? 'Unknown error',
          errorCode: 'UNKNOWN_ERROR',
          details: {
            'type': err.type.toString(),
            'uri': err.requestOptions.uri.toString(),
          },
        );
    }
  }

  /// Extracts the error message from a Dio error.
  String? _extractErrorMessage(final DioException err) {
    try {
      final data = err.response?.data;

      if (data != null && data is Map<String, dynamic>) {
        // Check various common error message fields
        return data['message'] as String? ??
            data['error'] as String? ??
            data['error_message'] as String? ??
            data['errorMessage'] as String?;
      }

      return err.message;
    } catch (e) {
      _logDebug('Error extracting message: $e');
      return err.message;
    }
  }

  /// Extracts error details from a Dio error.
  Map<String, dynamic>? _extractErrorDetails(final DioException err) {
    try {
      final data = err.response?.data;
      final details = <String, dynamic>{};

      // Include request info
      details['path'] = err.requestOptions.path;
      details['method'] = err.requestOptions.method;

      if (data != null && data is Map<String, dynamic>) {
        // Add response data
        if (data.containsKey('errors')) {
          details['errors'] = data['errors'];
        } else if (data.containsKey('details')) {
          details['details'] = data['details'];
        } else if (data.containsKey('error_details')) {
          details['details'] = data['error_details'];
        }
      }

      return details.isNotEmpty ? details : null;
    } catch (e) {
      _logDebug('Error extracting details: $e');
      return null;
    }
  }

  /// Logs a debug message if debug is enabled.
  void _logDebug(final String message) {
    if (_debug && kDebugMode) {
      print('ErrorInterceptor: $message');
    }
  }
}
