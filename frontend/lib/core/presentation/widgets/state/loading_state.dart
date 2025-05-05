import 'package:flutter/material.dart';

/// A widget that displays a loading state.
///
/// This widget provides a consistent loading experience across the app.
class LoadingState extends StatelessWidget {
  /// Optional text to display below the loader.
  final String? message;

  /// Whether to show the loading state with a full-screen overlay.
  final bool isOverlay;

  /// The size of the loading indicator.
  final double size;

  /// The color of the loading indicator. If null, it uses the theme's primary color.
  final Color? color;

  /// Whether to show a text message with the loading indicator.
  final bool showMessage;

  /// Creates a loading state widget.
  const LoadingState({
    Key? key,
    this.message,
    this.isOverlay = false,
    this.size = 36.0,
    this.color,
    this.showMessage = true,
  }) : super(key: key);

  /// Creates a loading state that covers the entire screen with an overlay.
  factory LoadingState.fullScreen({
    String? message,
    Color? color,
    bool showMessage = true,
  }) {
    return LoadingState(
      message: message,
      isOverlay: true,
      size: 48.0,
      color: color,
      showMessage: showMessage,
    );
  }

  @override
  Widget build(BuildContext context) {
    final loadingWidget = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? Theme.of(context).primaryColor,
              ),
            ),
          ),
          if (showMessage && message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );

    if (isOverlay) {
      return Container(
        color: Colors.black.withOpacity(0.5),
        child: loadingWidget,
      );
    }

    return loadingWidget;
  }
}
