import 'package:flutter/material.dart';

/// A collection of error display widgets for the application
class AppErrorDisplays {
  /// Standard error display with retry option
  static Widget standard({
    required final String errorMessage,
    final String? errorCode,
    final VoidCallback? onRetry,
    final bool centered = true,
  }) {
    final content = Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red.shade700),
          const SizedBox(height: 16),
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ],
      ),
    );

    return centered ? Center(child: content) : content;
  }

  /// Inline error display for small contexts
  static Widget inline({
    required final String errorMessage,
    final VoidCallback? onRetry,
  }) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(Icons.error_outline, size: 16, color: Colors.red.shade700),
      const SizedBox(width: 8),
      Flexible(
        child: Text(
          errorMessage,
          style: TextStyle(fontSize: 12, color: Colors.red.shade700),
        ),
      ),
      if (onRetry != null) ...[
        const SizedBox(width: 8),
        InkWell(
          onTap: onRetry,
          child: const Icon(Icons.refresh, size: 16, color: Colors.blue),
        ),
      ],
    ],
  );

  /// Banner error display for the top of the screen
  static Widget banner({
    required final String errorMessage,
    final VoidCallback? onDismiss,
  }) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    color: Colors.red.shade700,
    child: Row(
      children: [
        const Icon(Icons.warning_amber_rounded, color: Colors.white),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            errorMessage,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        if (onDismiss != null)
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: onDismiss,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
      ],
    ),
  );
}
