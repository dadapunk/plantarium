import 'package:dio/dio.dart';

/// Base exception class for all application exceptions
///
/// This provides a consistent interface for handling errors throughout the app
abstract class AppException implements Exception {
  final String message;
  final String? errorCode;
  final dynamic details;

  AppException({required this.message, this.errorCode, this.details});

  @override
  String toString() {
    final buffer = StringBuffer(message);
    if (errorCode != null) {
      buffer.write(' [Code: $errorCode]');
    }
    return buffer.toString();
  }
}

/// Exception thrown when there is an error with network requests
///
/// This is used to represent errors that occur during API calls
class ApiException extends AppException {
  ApiException({required String message, String? errorCode, dynamic details})
    : super(message: message, errorCode: errorCode, details: details);

  /// Creates an [ApiException] from a [DioException]
  factory ApiException.fromDioException(DioException e) {
    final response = e.response;
    final data = response?.data;

    if (data is Map<String, dynamic>) {
      return ApiException(
        message:
            (data['message'] as String?) ?? e.message ?? 'An error occurred',
        errorCode: data['error_code'] as String?,
        details: data['error_details'],
      );
    }

    return ApiException(
      message: e.message ?? 'An error occurred',
      errorCode: 'HTTP_ERROR',
      details: {
        'statusCode': response?.statusCode,
        'requestPath': e.requestOptions.path,
      },
    );
  }
}

/// Exception thrown when there is an error with local data storage
///
/// This is used to represent errors that occur when accessing local storage
class StorageException extends AppException {
  StorageException({
    required String message,
    String? errorCode,
    dynamic details,
  }) : super(message: message, errorCode: errorCode, details: details);
}

/// Exception thrown when there is an error with business logic
///
/// This is used to represent errors in domain logic or validation
class DomainException extends AppException {
  DomainException({required String message, String? errorCode, dynamic details})
    : super(message: message, errorCode: errorCode, details: details);
}

/// Exception thrown when there is an unauthorized access attempt
///
/// This is used when authentication or authorization fails
class AuthException extends AppException {
  AuthException({required String message, String? errorCode, dynamic details})
    : super(
        message: message,
        errorCode: errorCode ?? 'AUTH_ERROR',
        details: details,
      );
}

/// Exception thrown when there is a configuration error
///
/// This is used when the application is misconfigured
class ConfigException extends AppException {
  ConfigException({required String message, String? errorCode, dynamic details})
    : super(
        message: message,
        errorCode: errorCode ?? 'CONFIG_ERROR',
        details: details,
      );
}
