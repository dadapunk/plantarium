import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A reusable widget for displaying formatted dates
class DateDisplay extends StatelessWidget {
  /// The date to display
  final DateTime date;

  /// The format to use (optional, default is determined by the [formatType] property)
  final String? customFormat;

  /// The type of format to use
  final DateFormatType formatType;

  /// Text style to apply
  final TextStyle? style;

  /// Whether to show relative dates (e.g., "Today", "Yesterday")
  final bool useRelative;

  /// Constructor for DateDisplay
  const DateDisplay({
    super.key,
    required this.date,
    this.customFormat,
    this.formatType = DateFormatType.standard,
    this.style,
    this.useRelative = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final actualStyle = style ?? theme.textTheme.bodySmall;

    return Text(_getFormattedDate(), style: actualStyle);
  }

  String _getFormattedDate() {
    if (useRelative) {
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return 'Today';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      }
    }

    if (customFormat != null) {
      return DateFormat(customFormat!).format(date);
    }

    switch (formatType) {
      case DateFormatType.standard:
        return DateFormat('dd/MM/yyyy').format(date);
      case DateFormatType.long:
        return DateFormat('MMMM d, yyyy').format(date);
      case DateFormatType.short:
        return DateFormat('MM/dd').format(date);
      case DateFormatType.time:
        return DateFormat('HH:mm').format(date);
      case DateFormatType.dateTime:
        return DateFormat('dd/MM/yyyy HH:mm').format(date);
    }
  }
}

/// Enum for different date formats
enum DateFormatType {
  standard, // 31/12/2023
  long, // December 31, 2023
  short, // 12/31
  time, // 14:30
  dateTime, // 31/12/2023 14:30
}
