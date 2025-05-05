import 'package:flutter/material.dart';
import 'package:plantarium/core/state/base_state.dart';
import 'package:plantarium/core/presentation/widgets/state/error_state.dart';
import 'package:plantarium/core/presentation/widgets/state/loading_state.dart';

/// A builder widget that renders UI based on a [BaseState].
///
/// This widget simplifies rendering different UI states in a consistent way.
class StateBuilder<T> extends StatelessWidget {
  /// The state to render.
  final BaseState<T> state;

  /// Builder function for rendering the success state.
  final Widget Function(T data) onSuccess;

  /// Optional builder function for rendering the loading state.
  /// If null, a default [LoadingState] will be used.
  final Widget Function(T? data)? onLoading;

  /// Optional builder function for rendering the error state.
  /// If null, a default [ErrorState] will be used.
  final Widget Function(String message, T? data, VoidCallback? retry)? onError;

  /// Optional function to call when retry is pressed in the error state.
  final VoidCallback? onRetry;

  /// Optional widget to display in the initial state.
  /// If null, a default [LoadingState] will be used.
  final Widget? initialWidget;

  /// Creates a state builder widget.
  const StateBuilder({
    Key? key,
    required this.state,
    required this.onSuccess,
    this.onLoading,
    this.onError,
    this.onRetry,
    this.initialWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return state.maybeMap(
      initial: (_) => initialWidget ?? const LoadingState(),
      loading:
          (loading) =>
              onLoading != null
                  ? onLoading!(loading.data)
                  : LoadingState(
                    message: 'Loading...',
                    showMessage: loading.data == null,
                  ),
      success: (success) => onSuccess(success.data),
      error:
          (error) =>
              onError != null
                  ? onError!(error.message, error.data, onRetry)
                  : ErrorState(message: error.message, onRetry: onRetry),
      orElse: () => const SizedBox(),
    );
  }
}

/// A builder widget that renders UI based on a [BaseState] for content in a list or grid.
///
/// Similar to [StateBuilder] but optimized for displaying content in lists with
/// appropriate empty state handling.
class ContentStateBuilder<T> extends StatelessWidget {
  /// The state to render.
  final BaseState<T> state;

  /// Builder function for rendering the success state.
  final Widget Function(T data) onSuccess;

  /// Function to check if the data is empty.
  final bool Function(T data) isEmpty;

  /// Optional builder function for rendering the empty state.
  /// If null, a default empty state message will be used.
  final Widget Function()? onEmpty;

  /// Optional builder function for rendering the loading state.
  /// If null, a default [LoadingState] will be used.
  final Widget Function()? onLoading;

  /// Optional builder function for rendering the error state.
  /// If null, a default [ErrorState] will be used.
  final Widget Function(String message, VoidCallback? retry)? onError;

  /// Optional function to call when retry is pressed in the error state.
  final VoidCallback? onRetry;

  /// The text to display when the data is empty.
  final String emptyText;

  /// Creates a content state builder widget.
  const ContentStateBuilder({
    Key? key,
    required this.state,
    required this.onSuccess,
    required this.isEmpty,
    this.onEmpty,
    this.onLoading,
    this.onError,
    this.onRetry,
    this.emptyText = 'No data available',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return state.maybeMap(
      initial: (_) => onLoading != null ? onLoading!() : const LoadingState(),
      loading: (_) => onLoading != null ? onLoading!() : const LoadingState(),
      success: (success) {
        if (isEmpty(success.data)) {
          return onEmpty != null
              ? onEmpty!()
              : Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.info_outline,
                        size: 48,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        emptyText,
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
        }
        return onSuccess(success.data);
      },
      error:
          (error) =>
              onError != null
                  ? onError!(error.message, onRetry)
                  : ErrorState(message: error.message, onRetry: onRetry),
      orElse: () => const SizedBox(),
    );
  }
}
