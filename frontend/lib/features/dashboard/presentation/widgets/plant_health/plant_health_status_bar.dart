import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PlantHealthStatusBar extends StatelessWidget {
  const PlantHealthStatusBar({
    Key? key,
    required this.plantName,
    required this.healthPercentage,
    required this.status,
    required this.statusColor,
  }) : super(key: key);
  final String plantName;
  final double healthPercentage;
  final String status;
  final Color statusColor;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Plant name and status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                plantName,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Health bar
          Stack(
            children: [
              // Background track
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: theme.dividerColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),

              // Progress indicator
              FractionallySizedBox(
                widthFactor: healthPercentage,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: _getHealthColor(healthPercentage),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Percentage text
          Text(
            '${(healthPercentage * 100).toInt()}% health',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
            ),
          ),

          const SizedBox(height: 4),
          Divider(color: theme.dividerColor.withOpacity(0.3)),
        ],
      ),
    );
  }

  Color _getHealthColor(final double health) {
    if (health >= 0.7) {
      return Colors.green;
    } else if (health >= 0.4) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('plantName', plantName));
    properties.add(DoubleProperty('healthPercentage', healthPercentage));
    properties.add(StringProperty('status', status));
    properties.add(ColorProperty('statusColor', statusColor));
  }
}
