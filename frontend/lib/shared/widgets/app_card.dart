import 'package:flutter/material.dart';

/// A reusable card component with consistent styling
class AppCard extends StatelessWidget {
  /// The card's content
  final Widget child;

  /// Optional title for the card
  final String? title;

  /// Optional subtitle for the card
  final String? subtitle;

  /// Optional icon to display in the card header
  final IconData? icon;

  /// Callback when the card is tapped
  final VoidCallback? onTap;

  /// Elevation of the card
  final double elevation;

  /// Padding applied to the card content
  final EdgeInsetsGeometry contentPadding;

  /// Margin around the card
  final EdgeInsetsGeometry margin;

  /// Border radius of the card
  final BorderRadius borderRadius;

  /// Actions to display in the card header
  final List<Widget>? actions;

  const AppCard({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.icon,
    this.onTap,
    this.elevation = 2,
    this.contentPadding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.only(bottom: 16),
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasHeader = title != null || subtitle != null || icon != null;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasHeader) ...[
          Padding(
            padding: EdgeInsets.only(
              left: contentPadding.horizontal / 2,
              right: contentPadding.horizontal / 2,
              top: contentPadding.vertical / 2,
              bottom: subtitle != null ? 0 : contentPadding.vertical / 2,
            ),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title != null)
                        Text(title!, style: theme.textTheme.titleMedium),
                      if (subtitle != null)
                        Text(subtitle!, style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
                if (actions != null) ...actions!,
              ],
            ),
          ),
          if (subtitle != null)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Divider(height: 1),
            ),
        ],
        Padding(
          padding: EdgeInsets.only(
            left: contentPadding.horizontal / 2,
            right: contentPadding.horizontal / 2,
            top: hasHeader ? 0 : contentPadding.vertical / 2,
            bottom: contentPadding.vertical / 2,
          ),
          child: child,
        ),
      ],
    );

    return Card(
      margin: margin,
      elevation: elevation,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      child: InkWell(onTap: onTap, borderRadius: borderRadius, child: content),
    );
  }
}
