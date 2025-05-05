import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_state.freezed.dart';

/// A base class for all state classes in the application.
/// It provides a consistent way to handle loading, error, and data states.
///
/// [T] is the type of data that will be stored in the state.
@freezed
class BaseState<T> with _$BaseState<T> {
  /// Private constructor required by freezed
  const BaseState._();

  /// Initial state with no data, no loading, and no error.
  const factory BaseState.initial() = _Initial<T>;

  /// Loading state with optional previous data.
  ///
  /// The [data] parameter allows for optimistic UI updates where you can
  /// display the previous successful data while loading new data.
  const factory BaseState.loading({T? data}) = _Loading<T>;

  /// Success state with required data.
  const factory BaseState.success({required T data}) = _Success<T>;

  /// Error state with required error and optional previous data.
  ///
  /// The [data] parameter allows you to display the previous successful data
  /// along with an error message.
  const factory BaseState.error({
    required String message,
    Object? error,
    StackTrace? stackTrace,
    T? data,
  }) = _Error<T>;

  /// Helper to check if the state is loading.
  bool get isLoading => maybeMap(loading: (_) => true, orElse: () => false);

  /// Helper to check if the state contains an error.
  bool get hasError => maybeMap(error: (_) => true, orElse: () => false);

  /// Helper to check if the state contains data.
  bool get hasData => maybeMap(
    success: (_) => true,
    loading: (state) => state.data != null,
    error: (state) => state.data != null,
    orElse: () => false,
  );

  /// Helper to get the data from any state that might contain it.
  T? get data => maybeMap(
    success: (state) => state.data,
    loading: (state) => state.data,
    error: (state) => state.data,
    orElse: () => null,
  );

  /// Helper to get the error message if there is one.
  String? get errorMessage =>
      maybeMap(error: (state) => state.message, orElse: () => null);
}
