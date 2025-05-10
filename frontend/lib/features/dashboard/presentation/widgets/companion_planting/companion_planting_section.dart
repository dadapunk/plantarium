import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CompanionPlantingSection extends StatefulWidget {
  const CompanionPlantingSection({super.key});

  @override
  State<CompanionPlantingSection> createState() =>
      _CompanionPlantingSectionState();
}

class _CompanionPlantingSectionState extends State<CompanionPlantingSection> {
  String _selectedPlant = 'Tomatoes';

  // Mock data for companion planting guide
  final Map<String, List<Map<String, dynamic>>> _companionData = {
    'Tomatoes': [
      {
        'plant': 'Basil',
        'relationship': 'Companion',
        'benefit': 'Improves growth and flavor, repels pests',
        'icon': Icons.check_circle,
        'color': Colors.green,
      },
      {
        'plant': 'Carrots',
        'relationship': 'Companion',
        'benefit': 'Tomatoes provide shade, carrots loosen soil',
        'icon': Icons.check_circle,
        'color': Colors.green,
      },
      {
        'plant': 'Potatoes',
        'relationship': 'Avoid',
        'benefit': 'Share diseases and pests',
        'icon': Icons.cancel,
        'color': Colors.red,
      },
    ],
    'Lettuce': [
      {
        'plant': 'Onions',
        'relationship': 'Companion',
        'benefit': 'Onions deter pests that attack lettuce',
        'icon': Icons.check_circle,
        'color': Colors.green,
      },
      {
        'plant': 'Strawberries',
        'relationship': 'Companion',
        'benefit': 'Compatible growth habits',
        'icon': Icons.check_circle,
        'color': Colors.green,
      },
      {
        'plant': 'Sunflowers',
        'relationship': 'Avoid',
        'benefit': 'Sunflowers can stunt lettuce growth',
        'icon': Icons.cancel,
        'color': Colors.red,
      },
    ],
    'Peppers': [
      {
        'plant': 'Onions',
        'relationship': 'Companion',
        'benefit': 'Deter pests with strong scent',
        'icon': Icons.check_circle,
        'color': Colors.green,
      },
      {
        'plant': 'Basil',
        'relationship': 'Companion',
        'benefit': 'Improves flavor and growth',
        'icon': Icons.check_circle,
        'color': Colors.green,
      },
      {
        'plant': 'Fennel',
        'relationship': 'Avoid',
        'benefit': 'Inhibits growth of most plants',
        'icon': Icons.cancel,
        'color': Colors.red,
      },
    ],
  };

  List<String> get plantNames => _companionData.keys.toList();

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
              'Companion Planting Guide',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Find compatible plants for your garden',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 16),

            // Plant selector
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: theme.dividerColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedPlant,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items:
                      plantNames
                          .map(
                            (plant) => DropdownMenuItem<String>(
                              value: plant,
                              child: Text(plant),
                            ),
                          )
                          .toList(),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedPlant = newValue;
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Companion plants list
            Expanded(
              child: ListView.builder(
                itemCount: _companionData[_selectedPlant]?.length ?? 0,
                itemBuilder: (final context, final index) {
                  final companionInfo = _companionData[_selectedPlant]![index];
                  return _buildCompanionItem(companionInfo, theme);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanionItem(
    final Map<String, dynamic> info,
    final ThemeData theme,
  ) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: theme.cardColor.withOpacity(0.5),
      border: Border.all(color: theme.dividerColor.withOpacity(0.3)),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(info['icon'] as IconData, color: info['color'] as Color, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                info['plant'] as String,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${info['relationship'] as String}: ${info['benefit'] as String}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<String>('plantNames', plantNames));
  }
}
