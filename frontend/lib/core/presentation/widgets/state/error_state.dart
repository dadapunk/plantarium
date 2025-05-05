import 'package:flutter/material.dart';

/// A widget that displays an error state.
///
/// This widget provides a consistent error experience across the app.
class ErrorState extends StatelessWidget {
  /// The error message to display.
  final String message;

  /// Optional callback for the retry button.
  final VoidCallback? onRetry;

  /// Whether to show a retry button.
  final bool showRetry;

  /// Whether to show a back button.
  final bool showBackButton;

  /// Optional icon to display above the error message.
  final IconData? icon;

  /// Creates an error state widget.
  const ErrorState({
    Key? key,
    required this.message,
    this.onRetry,
    this.showRetry = true,
    this.showBackButton = false,
    this.icon = Icons.error_outline,
  }) : super(key: key);

  /// Creates an error state for network errors.
  factory ErrorState.network({
    String message =
        'Network connection error. Please check your connection and try again.',
    VoidCallback? onRetry,
    bool showRetry = true,
  }) {
    return ErrorState(
      message: message,
      onRetry: onRetry,
      showRetry: showRetry,
      icon: Icons.wifi_off,
    );
  }

  /// Creates an error state for server errors.
  factory ErrorState.server({
    String message = 'Server error. Please try again later.',
    VoidCallback? onRetry,
    bool showRetry = true,
  }) {
    return ErrorState(
      message: message,
      onRetry: onRetry,
      showRetry: showRetry,
      icon: Icons.cloud_off,
    );
  }

  /// Creates an error state for not found errors.
  factory ErrorState.notFound({
    String message = 'The requested resource was not found.',
    VoidCallback? onRetry,
    bool showRetry = true,
    bool showBackButton = true,
  }) {
    return ErrorState(
      message: message,
      onRetry: onRetry,
      showRetry: showRetry,
      showBackButton: showBackButton,
      icon: Icons.search_off,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 64, color: Theme.of(context).colorScheme.error),
              const SizedBox(height: 16),
            ],
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (showBackButton)
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Back'),
                  ),
                if (showBackButton && showRetry && onRetry != null)
                  const SizedBox(width: 16),
                if (showRetry && onRetry != null)
                  ElevatedButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
