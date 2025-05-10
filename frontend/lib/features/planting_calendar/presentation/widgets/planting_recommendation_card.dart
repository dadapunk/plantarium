import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:plantarium/features/planting_calendar/data/models/planting_recommendation.dart';

class PlantingRecommendationCard extends StatelessWidget {
  const PlantingRecommendationCard({
    Key? key,
    required this.recommendation,
    required this.onAddToCalendar,
  }) : super(key: key);
  final PlantingRecommendation recommendation;
  final VoidCallback onAddToCalendar;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final statusLabel =
        recommendation.isIdealTime
            ? 'Ideal Time'
            : recommendation.isPossible
            ? 'Possible'
            : 'Not Recommended';
    final statusColor =
        recommendation.isIdealTime
            ? Colors.green
            : recommendation.isPossible
            ? Colors.orange
            : Colors.red;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Plant name with status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  recommendation.plantName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    statusLabel,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Planting time range
            Text(
              recommendation.plantingTimeRange,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),

            // Sun and water requirements
            Row(
              children: [
                // Sun requirements
                Row(
                  children: [
                    const Icon(Icons.wb_sunny, size: 18, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      recommendation.sunRequirement,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(width: 16),

                // Water requirements
                Row(
                  children: [
                    const Icon(Icons.water_drop, size: 18, color: Colors.blue),
                    const SizedBox(width: 4),
                    Text(
                      recommendation.waterRequirement,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Add to calendar button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onAddToCalendar,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(color: theme.colorScheme.primary),
                ),
                child: const Text('Add to Calendar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<PlantingRecommendation>(
        'recommendation',
        recommendation,
      ),
    );
    properties.add(
      ObjectFlagProperty<VoidCallback>.has('onAddToCalendar', onAddToCalendar),
    );
  }
}
