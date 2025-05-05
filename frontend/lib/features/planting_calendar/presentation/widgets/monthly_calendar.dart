import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plantarium/features/planting_calendar/data/models/planting_event.dart';

class MonthlyCalendar extends StatelessWidget {
  final DateTime month;
  final Function(DateTime) onDaySelected;
  final bool Function(DateTime) hasEvents;
  final List<PlantingEvent> Function(DateTime) getEventsForDay;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  const MonthlyCalendar({
    Key? key,
    required this.month,
    required this.onDaySelected,
    required this.hasEvents,
    required this.getEventsForDay,
    required this.onPreviousMonth,
    required this.onNextMonth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final daysInMonth = _getDaysInMonth(month.year, month.month);
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final startingWeekday =
        firstDayOfMonth.weekday % 7; // 0 for Sunday, 1 for Monday, etc.

    return Column(
      children: [
        // Month header with navigation
        _buildMonthHeader(theme),

        // Day of week header
        _buildDayOfWeekHeader(theme),

        // Calendar grid
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.0,
            ),
            itemCount: 42, // 6 weeks * 7 days
            itemBuilder: (context, index) {
              // Calculate the day number
              final dayOffset = index - startingWeekday;
              final day = dayOffset + 1;

              if (dayOffset < 0 || day > daysInMonth) {
                // Empty cell for days outside the current month
                return Container();
              }

              // Current day being rendered
              final date = DateTime(month.year, month.month, day);
              final isToday = _isToday(date);
              final hasEventsOnDay = hasEvents(date);

              // Weather icon (would be replaced with real data)
              final weatherIcon = _getWeatherIconForDay(day);

              return _buildDayCell(
                context,
                day,
                date,
                isToday,
                hasEventsOnDay,
                weatherIcon,
                theme,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMonthHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous month button
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: onPreviousMonth,
            tooltip: 'Previous month',
          ),

          // Month and year display
          Text(
            DateFormat('MMMM yyyy').format(month),
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          // Next month button
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: onNextMonth,
            tooltip: 'Next month',
          ),
        ],
      ),
    );
  }

  Widget _buildDayOfWeekHeader(ThemeData theme) {
    final dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children:
            dayNames.map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildDayCell(
    BuildContext context,
    int day,
    DateTime date,
    bool isToday,
    bool hasEventsOnDay,
    IconData? weatherIcon,
    ThemeData theme,
  ) {
    return InkWell(
      onTap: () => onDaySelected(date),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: theme.dividerColor.withOpacity(0.3)),
          color: isToday ? theme.colorScheme.primary.withOpacity(0.2) : null,
        ),
        child: Column(
          children: [
            // Day number and weather icon
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Day number
                  Text(day.toString(), style: theme.textTheme.bodyMedium),

                  // Weather icon
                  if (weatherIcon != null)
                    Icon(
                      weatherIcon,
                      size: 16,
                      color: _getWeatherIconColor(weatherIcon),
                    ),
                ],
              ),
            ),

            // Event indicator
            if (hasEventsOnDay)
              Expanded(
                child: Center(
                  child: Icon(
                    Icons.add,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  int _getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  // Mock function to get weather icon for a day
  IconData? _getWeatherIconForDay(int day) {
    // This would be replaced with real weather data in a production app
    if (day % 4 == 0) {
      return Icons.wb_sunny; // Sunny
    } else if (day % 4 == 1) {
      return Icons.cloud; // Cloudy
    } else if (day % 4 == 2) {
      return Icons.water_drop; // Rainy
    }
    return null;
  }

  // Get color for weather icon
  Color _getWeatherIconColor(IconData icon) {
    if (icon == Icons.wb_sunny) {
      return Colors.amber;
    } else if (icon == Icons.cloud) {
      return Colors.grey;
    } else if (icon == Icons.water_drop) {
      return Colors.blue;
    }
    return Colors.grey;
  }
}
