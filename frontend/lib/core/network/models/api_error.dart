import 'package:dio/dio.dart';

/// Represents an error that occurred during an API request.
class ApiError implements Exception {
  final String message;
  final int? statusCode;
  final String? errorCode;
  final Map<String, dynamic>? errorDetails;
  final DioException? dioException;

  ApiError({
    required this.message,
    this.statusCode,
    this.errorCode,
    this.errorDetails,
    this.dioException,
  });

  /// Creates an [ApiError] from a [DioException].
  factory ApiError.fromDioException(DioException e) {
    final response = e.response;
    final data = response?.data;

    if (data is Map<String, dynamic>) {
      return ApiError(
        message: data['message'] ?? e.message ?? 'An error occurred',
        statusCode: response?.statusCode,
        errorCode: data['error_code'],
        errorDetails: data['error_details'],
        dioException: e,
      );
    }

    return ApiError(
      message: e.message ?? 'An error occurred',
      statusCode: response?.statusCode,
      dioException: e,
    );
  }

  @override
  String toString() {
    final buffer = StringBuffer('ApiError: $message');
    if (statusCode != null) {
      buffer.write(' (Status: $statusCode)');
    }
    if (errorCode != null) {
      buffer.write(' [Code: $errorCode]');
    }
    return buffer.toString();
  }
}
