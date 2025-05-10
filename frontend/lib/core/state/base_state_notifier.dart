import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plantarium/core/state/base_state.dart';

/// A base class for StateNotifiers that use [BaseState].
///
/// This provides common functionality for handling loading, success, and error states.
/// [T] is the type of data managed by this notifier.
abstract class BaseStateNotifier<T> extends StateNotifier<BaseState<T>> {
  /// Creates a new BaseStateNotifier with an initial state.
  BaseStateNotifier() : super(const BaseState.initial());

  /// Sets the state to loading while preserving previous data if available.
  void setLoading() {
    state = BaseState.loading(data: state.data);
  }

  /// Sets the state to success with the provided data.
  void setSuccess(final T data) {
    state = BaseState.success(data: data);
  }

  /// Sets the state to error with the provided message and optional previous data.
  void setError(
    final String message, {
    final Object? error,
    final StackTrace? stackTrace,
  }) {
    state = BaseState.error(
      message: message,
      error: error,
      stackTrace: stackTrace,
      data: state.data,
    );
  }

  /// A utility method to run an async operation with proper state handling.
  ///
  /// This method automatically sets the state to loading before the operation,
  /// sets it to success if the operation succeeds, and sets it to error if the operation fails.
  ///
  /// Example usage:
  /// ```dart
  /// Future<void> fetchData() async {
  ///   await runWithState(() async {
  ///     final result = await repository.fetchData();
  ///     return result;
  ///   });
  /// }
  /// ```
  Future<void> runWithState(final Future<T> Function() callback) async {
    try {
      setLoading();
      final result = await callback();
      setSuccess(result);
    } catch (e, stackTrace) {
      setError(e.toString(), error: e, stackTrace: stackTrace);
    }
  }
}
