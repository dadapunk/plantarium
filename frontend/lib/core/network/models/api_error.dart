import 'package:dio/dio.dart';

/// Represents an error that occurred during an API request.
class ApiError implements Exception {
  final String message;
  final int? statusCode;

  ApiError({required this.message, this.statusCode});

  /// Creates an [ApiError] from a [DioException].
  factory ApiError.fromDioException(DioException e) {
    final response = e.response;
    final data = response?.data;

    String errorMessage = 'An error occurred';

    if (data is Map<String, dynamic> && data['message'] != null) {
      errorMessage = data['message'] as String;
    } else if (e.message != null) {
      errorMessage = e.message!;
    }

    return ApiError(message: errorMessage, statusCode: response?.statusCode);
  }

  @override
  String toString() {
    return 'ApiError: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
  }
}
