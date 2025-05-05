import 'package:flutter/material.dart';
import 'package:plantarium/features/dashboard/presentation/widgets/app_sidebar.dart';
import 'package:plantarium/features/garden_layout/presentation/widgets/garden_grid.dart';

class GardenLayoutScreen extends StatelessWidget {
  final String gardenName;

  const GardenLayoutScreen({Key? key, this.gardenName = 'Backyard Garden'})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Row(
        children: [
          // Sidebar navigation
          const AppSidebar(selectedIndex: 1),

          // Main content
          Expanded(
            child: Column(
              children: [
                // App bar
                _buildAppBar(theme),

                // Garden layout content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const GardenGrid(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(ThemeData theme) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Title and garden name
          Text(
            'Garden Layout: $gardenName',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          // Edit button
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.edit),
            label: const Text('Edit Layout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
