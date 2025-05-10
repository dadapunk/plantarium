import 'package:flutter/material.dart';
import 'package:plantarium/features/dashboard/presentation/widgets/active_gardens_section.dart';
import 'package:plantarium/features/dashboard/presentation/widgets/upcoming_tasks_section.dart';
import 'package:plantarium/features/dashboard/presentation/widgets/weather_forecast_section.dart';
import 'package:plantarium/features/dashboard/presentation/widgets/app_sidebar.dart';
import 'package:plantarium/features/dashboard/presentation/widgets/plant_health/plant_health_section.dart';
import 'package:plantarium/features/dashboard/presentation/widgets/companion_planting/companion_planting_section.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Row(
        children: [
          // Sidebar navigation
          const AppSidebar(selectedIndex: 0),

          // Main content
          Expanded(
            child: Column(
              children: [
                // App bar
                _buildAppBar(theme),

                // Dashboard content
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // First row with three sections
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Active Gardens section - left column (wider)
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 8),
                                  child: ActiveGardensSection(),
                                ),
                              ),

                              // Upcoming Tasks section - middle column
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: UpcomingTasksSection(),
                                ),
                              ),

                              // Weather Forecast section - right column
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: WeatherForecastSection(),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 16),

                        // Second row with plant health and companion planting
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Plant Health section - left column
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 8),
                                  child: PlantHealthSection(),
                                ),
                              ),

                              // Companion Planting Guide section - right column
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: CompanionPlantingSection(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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

  Widget _buildAppBar(final ThemeData theme) => Container(
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
        // Title and welcome message
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Welcome back, Gardener!',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
            ),
          ],
        ),

        // Right side actions
        Row(
          children: [
            // Temperature display
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: theme.cardColor,
              ),
              child: Row(
                children: [
                  Icon(Icons.wb_sunny_outlined, color: Colors.amber, size: 18),
                  const SizedBox(width: 4),
                  Text('22°C', style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Sync Data button
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.sync),
              label: const Text('Sync Data'),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: theme.primaryColor),
              ),
            ),
            const SizedBox(width: 12),

            // New Garden button
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('New Garden'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
