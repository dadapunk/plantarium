import 'package:flutter/material.dart';
import 'package:plantarium/shared/widgets/app_card.dart';

class ActiveGardensSection extends StatelessWidget {
  const ActiveGardensSection({super.key});

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);

    // Mock data for gardens - would come from a provider in a real app
    final gardensList = [
      {'name': 'Backyard Garden', 'plants': 12, 'icon': Icons.yard},
      {'name': 'Herb Garden', 'plants': 8, 'icon': Icons.eco},
      {'name': 'Container Garden', 'plants': 5, 'icon': Icons.inbox},
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
                  'Active Gardens',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'You have ${gardensList.length} active gardens',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),

          // Garden cards
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount:
                  gardensList.length + 1, // +1 for the "Manage Gardens" button
              itemBuilder: (final context, final index) {
                // "Manage Gardens" button at the end
                if (index == gardensList.length) {
                  return _buildManageGardensButton(theme);
                }

                // Garden card
                final garden = gardensList[index];
                return _buildGardenCard(
                  context: context,
                  name: garden['name']! as String,
                  plants: garden['plants']! as int,
                  icon: garden['icon']! as IconData,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGardenCard({
    required final BuildContext context,
    required final String name,
    required final int plants,
    required final IconData icon,
  }) {
    final theme = Theme.of(context);

    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      onTap: () {},
      title: name,
      icon: icon,
      actions: [
        Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: theme.iconTheme.color?.withOpacity(0.5),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          '$plants plants',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
          ),
        ),
      ),
    );
  }

  Widget _buildManageGardensButton(final ThemeData theme) => Container(
    margin: const EdgeInsets.only(top: 8),
    child: ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.cardColor,
        foregroundColor: theme.textTheme.bodyLarge?.color,
        elevation: 0,
        side: BorderSide(color: theme.dividerColor),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: const Text('Manage Gardens'),
    ),
  );
}
