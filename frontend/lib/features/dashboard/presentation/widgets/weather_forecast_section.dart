import 'package:flutter/material.dart';

class WeatherForecastSection extends StatelessWidget {
  const WeatherForecastSection({super.key});

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);

    // Mock data for weather forecast - would come from a weather API in a real app
    final forecastList = [
      {
        'day': 'Today',
        'condition': 'Sunny',
        'temperature': 22,
        'icon': Icons.wb_sunny_outlined,
      },
      {
        'day': 'Tomorrow',
        'condition': 'Light Rain',
        'temperature': 20,
        'icon': Icons.grain,
      },
      {
        'day': 'Friday',
        'condition': 'Partly Cloudy',
        'temperature': 21,
        'icon': Icons.cloud,
      },
      {
        'day': 'Saturday',
        'condition': 'Sunny',
        'temperature': 24,
        'icon': Icons.wb_sunny_outlined,
      },
      {
        'day': 'Sunday',
        'condition': 'Sunny',
        'temperature': 25,
        'icon': Icons.wb_sunny_outlined,
      },
    ];

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Weather Forecast',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '5-day forecast for your location',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),

          // Weather forecast list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount:
                  forecastList.length +
                  1, // +1 for the "Detailed Forecast" button
              itemBuilder: (final context, final index) {
                // "Detailed Forecast" button at the end
                if (index == forecastList.length) {
                  return _buildDetailedForecastButton(theme);
                }

                // Weather day item
                final forecast = forecastList[index];
                return _buildWeatherDayItem(
                  day: forecast['day']! as String,
                  condition: forecast['condition']! as String,
                  temperature: forecast['temperature']! as int,
                  icon: forecast['icon']! as IconData,
                  theme: theme,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDayItem({
    required final String day,
    required final String condition,
    required final int temperature,
    required final IconData icon,
    required final ThemeData theme,
  }) {
    Color iconColor;

    // Set icon color based on weather condition
    if (condition.contains('Sunny')) {
      iconColor = Colors.amber;
    } else if (condition.contains('Rain')) {
      iconColor = Colors.blue;
    } else if (condition.contains('Cloud')) {
      iconColor = Colors.grey;
    } else {
      iconColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.dividerColor, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          // Weather icon
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(width: 16),

          // Day and condition
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  condition,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),

          // Temperature
          Text(
            '$temperature°C',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedForecastButton(final ThemeData theme) => Container(
    margin: const EdgeInsets.only(top: 16),
    child: ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.cardColor,
        foregroundColor: theme.textTheme.bodyLarge?.color,
        elevation: 0,
        side: BorderSide(color: theme.dividerColor),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: const Text('Detailed Forecast'),
    ),
  );
}
