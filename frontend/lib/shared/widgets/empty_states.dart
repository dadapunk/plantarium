import 'package:flutter/material.dart';

/// A collection of empty state widgets for the application
class AppEmptyStates {
  /// Standard empty state display with customizable content
  static Widget standard({
    required final String title,
    final String? subtitle,
    final IconData icon = Icons.inbox_outlined,
    final Color? iconColor,
    final Widget? actionButton,
    final bool centered = true,
  }) {
    final content = Padding(
      padding: const EdgeInsets.all(16),
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
    final String title = 'No items found',
    final String? subtitle,
    final VoidCallback? onActionPressed,
    final String actionLabel = 'Add Item',
    final IconData icon = Icons.format_list_bulleted,
  }) => standard(
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

  /// Empty state specifically for search results
  static Widget forSearch({
    final String title = 'No results found',
    final String? subtitle = 'Try different search terms',
    final VoidCallback? onClearSearch,
  }) => standard(
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
