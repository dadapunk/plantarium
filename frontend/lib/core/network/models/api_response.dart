import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'api_response.freezed.dart';
part 'api_response.g.dart';

/// A standardized response model for API calls.
@Freezed(genericArgumentFactories: true)
class ApiResponse<T> with _$ApiResponse<T> {
  const factory ApiResponse({
    required final bool success,
    required final String message,
    final T? data,
    @JsonKey(name: 'error_code') final String? errorCode,
    @JsonKey(name: 'error_details') final Map<String, dynamic>? errorDetails,
  }) = _ApiResponse<T>;

  factory ApiResponse.fromJson(
    final Map<String, dynamic> json,
    final T Function(Object? json) fromJsonT,
  ) => _$ApiResponseFromJson(json, fromJsonT);
}
