import 'package:flutter/material.dart';

/// A collection of empty state widgets for the application
class AppEmptyStates {
  /// Standard empty state display with customizable content
  static Widget standard({
    required String title,
    String? subtitle,
    IconData icon = Icons.inbox_outlined,
    Color? iconColor,
    Widget? actionButton,
    bool centered = true,
  }) {
    final content = Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: iconColor ?? Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ],
          if (actionButton != null) ...[
            const SizedBox(height: 24),
            actionButton,
          ],
        ],
      ),
    );

    return centered ? Center(child: content) : content;
  }

  /// Empty state for lists or search results
  static Widget forList({
    String title = 'No items found',
    String? subtitle,
    VoidCallback? onActionPressed,
    String actionLabel = 'Add Item',
    IconData icon = Icons.format_list_bulleted,
  }) {
    return standard(
      title: title,
      subtitle: subtitle,
      icon: icon,
      actionButton:
          onActionPressed != null
              ? ElevatedButton.icon(
                onPressed: onActionPressed,
                icon: const Icon(Icons.add),
                label: Text(actionLabel),
              )
              : null,
    );
  }

  /// Empty state specifically for search results
  static Widget forSearch({
    String title = 'No results found',
    String? subtitle = 'Try different search terms',
    VoidCallback? onClearSearch,
  }) {
    return standard(
      title: title,
      subtitle: subtitle,
      icon: Icons.search_off,
      actionButton:
          onClearSearch != null
              ? OutlinedButton(
                onPressed: onClearSearch,
                child: const Text('Clear Search'),
              )
              : null,
    );
  }
}
