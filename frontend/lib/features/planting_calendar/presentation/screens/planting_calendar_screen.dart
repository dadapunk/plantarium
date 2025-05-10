import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:plantarium/features/dashboard/presentation/widgets/app_sidebar.dart';
import 'package:plantarium/features/planting_calendar/data/models/planting_event.dart';
import 'package:plantarium/features/planting_calendar/presentation/providers/planting_calendar_provider.dart';
import 'package:plantarium/features/planting_calendar/presentation/widgets/monthly_calendar.dart';
import 'package:plantarium/features/planting_calendar/presentation/widgets/planting_recommendation_card.dart';
import 'package:plantarium/shared/widgets/app_widgets.dart';

class PlantingCalendarScreen extends StatelessWidget {
  const PlantingCalendarScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    // Get the provider from context and load data
    final provider = Provider.of<PlantingCalendarProvider>(
      context,
      listen: false,
    );

    // Initialize loading data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.loadCalendarData();
    });

    return const _PlantingCalendarContent();
  }
}

class _PlantingCalendarContent extends StatefulWidget {
  const _PlantingCalendarContent({super.key});

  @override
  State<_PlantingCalendarContent> createState() =>
      _PlantingCalendarContentState();
}

class _PlantingCalendarContentState extends State<_PlantingCalendarContent> {
  PlantingEvent? _selectedEvent;

  @override
  Widget build(final BuildContext context) {
    final provider = context.watch<PlantingCalendarProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      body: Row(
        children: [
          // Sidebar navigation
          const AppSidebar(selectedIndex: 3),

          // Main content
          Expanded(
            child: Column(
              children: [
                // App bar
                _buildAppBar(theme),

                // Content area
                Expanded(child: _buildBody(context, provider, theme)),
              ],
            ),
          ),
        ],
      ),
      // Add event button
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEventDialog(context),
        tooltip: 'Add Event',
        child: const Icon(Icons.add),
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
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Planting Calendar',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Plan and track your planting schedule',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _buildBody(
    final BuildContext context,
    final PlantingCalendarProvider provider,
    final ThemeData theme,
  ) {
    if (provider.isLoading) {
      return AppLoadingIndicators.standard(message: 'Loading calendar data...');
    }

    if (provider.error != null) {
      return AppErrorDisplays.standard(
        errorMessage: provider.error ?? 'Unknown error',
        onRetry: provider.loadCalendarData,
      );
    }

    return Column(
      children: [
        // Calendar controls
        _buildCalendarControls(context, provider, theme),

        // Calendar + Recommendations
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Calendar section
                Expanded(
                  flex: 3,
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: MonthlyCalendar(
                        month: provider.selectedMonth,
                        onDaySelected:
                            (final date) =>
                                _showEventsForDay(context, date, provider),
                        hasEvents: provider.hasEventsOnDay,
                        getEventsForDay: provider.getEventsForDay,
                        onPreviousMonth: provider.previousMonth,
                        onNextMonth: provider.nextMonth,
                      ),
                    ),
                  ),
                ),

                // Planting recommendations section
                Expanded(
                  flex: 2,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: _buildRecommendationsSection(
                        context,
                        provider,
                        theme,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarControls(
    final BuildContext context,
    final PlantingCalendarProvider provider,
    final ThemeData theme,
  ) => Padding(
    padding: const EdgeInsets.all(16.0),
    child: Row(
      children: [
        // Month/Week view toggle
        Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: theme.dividerColor),
          ),
          child: Row(
            children: [
              _buildViewToggleButton(
                label: 'Month',
                isSelected: provider.isMonthView,
                onTap: () => provider.setViewMode(true),
                theme: theme,
              ),
              _buildViewToggleButton(
                label: 'Week',
                isSelected: !provider.isMonthView,
                onTap: () => provider.setViewMode(false),
                theme: theme,
              ),
            ],
          ),
        ),

        const Spacer(),

        // Garden filter dropdown
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: theme.dividerColor),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: provider.selectedGarden,
              icon: const Icon(Icons.keyboard_arrow_down),
              items:
                  [
                    'All Gardens',
                    'Backyard Garden',
                    'Herb Garden',
                    'Container Garden',
                    'Raised Bed Garden',
                  ].map((String garden) {
                    return DropdownMenuItem<String>(
                      value: garden,
                      child: Text(garden),
                    );
                  }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  provider.setSelectedGarden(newValue);
                }
              },
            ),
          ),
        ),

        const SizedBox(width: 16),

        // Filter button
        ElevatedButton.icon(
          onPressed: () {
            // Filter functionality would go here
          },
          icon: const Icon(Icons.filter_list),
          label: const Text('Filter'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),

        const SizedBox(width: 16),

        // Add event button
        ElevatedButton.icon(
          onPressed: () => _showAddEventDialog(context),
          icon: const Icon(Icons.add),
          label: const Text('Add Event'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    ),
  );

  Widget _buildViewToggleButton({
    required final String label,
    required final bool isSelected,
    required final VoidCallback onTap,
    required final ThemeData theme,
  }) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? theme.colorScheme.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: isSelected ? Colors.white : theme.textTheme.bodyMedium?.color,
          fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
        ),
      ),
    ),
  );

  Widget _buildRecommendationsSection(
    final BuildContext context,
    final PlantingCalendarProvider provider,
    final ThemeData theme,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Section title
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Planting Recommendations',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Based on your climate zone and current season',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              // View all recommendations
            },
            child: const Text('View All'),
          ),
        ],
      ),
      const SizedBox(height: 16),

      // Recommendations list
      Expanded(
        child:
            provider.recommendations.isEmpty
                ? _buildEmptyRecommendations(theme)
                : _buildRecommendationsList(context, provider, theme),
      ),

      // Climate data info
      Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 16,
            color: theme.colorScheme.primary.withOpacity(0.7),
          ),
          const SizedBox(width: 8),
          Text(
            'Based on your local climate data',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
            ),
          ),
        ],
      ),
    ],
  );

  Widget _buildEmptyRecommendations(final ThemeData theme) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.eco,
          size: 48,
          color: theme.colorScheme.primary.withOpacity(0.5),
        ),
        const SizedBox(height: 16),
        Text(
          'No planting recommendations available',
          style: theme.textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Check back later or update your location',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );

  Widget _buildRecommendationsList(
    final BuildContext context,
    final PlantingCalendarProvider provider,
    final ThemeData theme,
  ) {
    // Show only the first few recommendations in this view
    final recommendations = provider.recommendations.take(3).toList();

    return ListView.builder(
      itemCount: recommendations.length,
      itemBuilder: (final context, final index) {
        final recommendation = recommendations[index];
        return PlantingRecommendationCard(
          recommendation: recommendation,
          onAddToCalendar:
              () => _addRecommendationToCalendar(context, recommendation),
        );
      },
    );
  }

  void _showEventsForDay(
    final BuildContext context,
    final DateTime date,
    final PlantingCalendarProvider provider,
  ) {
    final events = provider.getEventsForDay(date);

    if (events.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No events on ${DateFormat('MMMM d, yyyy').format(date)}',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder:
          (final context) => AlertDialog(
            title: Text('Events on ${DateFormat('MMMM d, yyyy').format(date)}'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return ListTile(
                    title: Text(event.title),
                    subtitle: Text('${event.gardenName} - ${event.eventType}'),
                    leading: const Icon(Icons.event),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  void _showAddEventDialog(final BuildContext context) {
    // This would show a dialog to add a new event
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Add event functionality would be implemented here'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _addRecommendationToCalendar(
    final BuildContext context,
    final dynamic recommendation,
  ) {
    // This would add the recommendation to the calendar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added ${recommendation.plantName} to calendar'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
