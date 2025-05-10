import 'package:dio/dio.dart';

/// Base exception class for all application exceptions
///
/// This provides a consistent interface for handling errors throughout the app
abstract class AppException implements Exception {
  AppException({required this.message, this.errorCode, this.details});
  final String message;
  final String? errorCode;
  final dynamic details;

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
  ApiException({required super.message, super.errorCode, super.details});

  /// Creates an [ApiException] from a [DioException]
  factory ApiException.fromDioException(final DioException e) {
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
  StorageException({required super.message, super.errorCode, super.details});
}

/// Exception thrown when there is an error with business logic
///
/// This is used to represent errors in domain logic or validation
class DomainException extends AppException {
  DomainException({required super.message, super.errorCode, super.details});
}

/// Exception thrown when there is an unauthorized access attempt
///
/// This is used when authentication or authorization fails
class AuthException extends AppException {
  AuthException({
    required super.message,
    final String? errorCode,
    super.details,
  }) : super(errorCode: errorCode ?? 'AUTH_ERROR');
}

/// Exception thrown when there is a configuration error
///
/// This is used when the application is misconfigured
class ConfigException extends AppException {
  ConfigException({
    required super.message,
    final String? errorCode,
    super.details,
  }) : super(errorCode: errorCode ?? 'CONFIG_ERROR');
}
