import 'package:flutter/material.dart';

/// A collection of loading indicators for the application
class AppLoadingIndicators {
  /// Standard loading indicator with text
  static Widget standard({
    final String message = 'Loading...',
    final bool centered = true,
  }) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 16),
        Text(message),
      ],
    );

    return centered ? Center(child: content) : content;
  }

  /// Inline loading indicator for smaller contexts
  static Widget inline({final double size = 20, final Color? color}) =>
      SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(strokeWidth: 2.0, color: color),
      );

  /// Overlay loading indicator with semi-transparent background
  static Widget overlay({
    final String message = 'Loading...',
    final bool dismissible = false,
    final VoidCallback? onDismiss,
  }) => Stack(
    children: [
      Positioned.fill(
        child: GestureDetector(
          onTap: dismissible ? onDismiss : null,
          child: Container(
            color: Colors.black.withOpacity(0.5),
            child: standard(message: message),
          ),
        ),
      ),
    ],
  );

  /// Shimmer loading effect placeholder - to be implemented
  /// Using a simple container placeholder for now
  static Widget shimmer({
    required final double width,
    required final double height,
    final double borderRadius = 8.0,
  }) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: Colors.grey.shade300,
      borderRadius: BorderRadius.circular(borderRadius),
    ),
  );
}
