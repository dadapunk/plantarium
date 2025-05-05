import 'package:flutter/material.dart';
import 'package:plantarium/shared/widgets/date_display.dart';

class UpcomingTasksSection extends StatelessWidget {
  const UpcomingTasksSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Mock data for tasks - would come from a provider in a real app
    final tasksList = [
      {
        'title': 'Water tomatoes',
        'garden': 'Backyard Garden',
        'date': DateTime.now(),
        'status': 'today',
      },
      {
        'title': 'Harvest lettuce',
        'garden': 'Backyard Garden',
        'date': DateTime.now().add(const Duration(days: 1)),
        'status': 'tomorrow',
      },
      {
        'title': 'Prune basil',
        'garden': 'Herb Garden',
        'date': DateTime.now().add(const Duration(days: 2)),
        'status': 'upcoming',
      },
      {
        'title': 'Plant carrots',
        'garden': 'Container Garden',
        'date': DateTime.now().add(const Duration(days: 3)),
        'status': 'upcoming',
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upcoming Tasks',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tasks for the next 7 days',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),

          // Task list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount:
                  tasksList.length + 1, // +1 for the "View All Tasks" button
              itemBuilder: (context, index) {
                // "View All Tasks" button at the end
                if (index == tasksList.length) {
                  return _buildViewAllTasksButton(theme);
                }

                // Task item
                final task = tasksList[index];
                return _buildTaskItem(
                  context: context,
                  title: task['title'] as String,
                  garden: task['garden'] as String,
                  date: task['date'] as DateTime,
                  status: task['status'] as String,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem({
    required BuildContext context,
    required String title,
    required String garden,
    required DateTime date,
    required String status,
  }) {
    final theme = Theme.of(context);

    // Determine status text and icon
    IconData statusIcon;
    String statusText;
    Color statusColor;

    switch (status) {
      case 'today':
        statusIcon = Icons.today;
        statusText = 'Today';
        statusColor = Colors.amber;
        break;
      case 'tomorrow':
        statusIcon = Icons.access_time;
        statusText = 'Tomorrow';
        statusColor = Colors.blue;
        break;
      case 'upcoming':
      default:
        statusIcon = Icons.event;
        statusText = 'May ${date.day}';
        statusColor = Colors.green;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Task content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  garden,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),

          // Task date
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Icon(statusIcon, size: 14, color: statusColor),
                const SizedBox(width: 4),
                Text(
                  statusText,
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
  }

  Widget _buildViewAllTasksButton(ThemeData theme) {
    return Container(
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
        child: const Text('View All Tasks'),
      ),
    );
  }
}
