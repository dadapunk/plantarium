import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:plantarium/features/dashboard/presentation/widgets/plant_health/plant_health_status_bar.dart';

class PlantHealthSection extends StatefulWidget {
  const PlantHealthSection({super.key});

  @override
  State<PlantHealthSection> createState() => _PlantHealthSectionState();
}

class _PlantHealthSectionState extends State<PlantHealthSection> {
  String _selectedFilter = 'All Plants';

  // Mock data for plant health status
  final List<Map<String, dynamic>> _plantHealthData = [
    {
      'name': 'Tomatoes',
      'health': 0.75,
      'status': 'Good',
      'statusColor': Colors.green,
    },
    {
      'name': 'Lettuce',
      'health': 0.90,
      'status': 'Excellent',
      'statusColor': Colors.green,
    },
    {
      'name': 'Peppers',
      'health': 0.55,
      'status': 'Needs Attention',
      'statusColor': Colors.orange,
    },
    {
      'name': 'Basil',
      'health': 0.70,
      'status': 'Good',
      'statusColor': Colors.green,
    },
    {
      'name': 'Carrots',
      'health': 0.35,
      'status': 'Poor',
      'statusColor': Colors.red,
    },
  ];

  List<Map<String, dynamic>> get filteredPlants {
    if (_selectedFilter == 'All Plants') {
      return _plantHealthData;
    } else if (_selectedFilter == 'Issues') {
      return _plantHealthData
          .where(
            (final plant) =>
                plant['status'] == 'Poor' ||
                plant['status'] == 'Needs Attention',
          )
          .toList();
    } else if (_selectedFilter == 'Healthy') {
      return _plantHealthData
          .where(
            (final plant) =>
                plant['status'] == 'Good' || plant['status'] == 'Excellent',
          )
          .toList();
    }
    return _plantHealthData;
  }

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section title
            Text(
              'Plant Health',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Current status of your plants',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 16),

            // Filter buttons
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterButton('All Plants', theme),
                  const SizedBox(width: 8),
                  _buildFilterButton('Issues', theme),
                  const SizedBox(width: 8),
                  _buildFilterButton('Healthy', theme),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Plant health list
            Expanded(
              child: ListView.builder(
                itemCount: filteredPlants.length,
                itemBuilder: (final context, final index) {
                  final plant = filteredPlants[index];
                  return PlantHealthStatusBar(
                    plantName: plant['name'],
                    healthPercentage: plant['health'],
                    status: plant['status'],
                    statusColor: plant['statusColor'],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(final String label, final ThemeData theme) {
    final isSelected = _selectedFilter == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? theme.primaryColor.withOpacity(0.1)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? theme.primaryColor : theme.dividerColor,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color:
                isSelected
                    ? theme.primaryColor
                    : theme.textTheme.bodyMedium?.color,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      IterableProperty<Map<String, dynamic>>('filteredPlants', filteredPlants),
    );
  }
}
