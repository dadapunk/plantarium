import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:plantarium/features/dashboard/presentation/widgets/app_sidebar.dart';
import 'package:plantarium/features/planting_calendar/data/models/planting_event.dart';
import 'package:plantarium/features/planting_calendar/data/models/planting_recommendation.dart';
import 'package:plantarium/features/planting_calendar/presentation/providers/planting_calendar.provider.dart';
import 'package:plantarium/features/planting_calendar/presentation/state/planting_calendar.notifier.dart';
import 'package:plantarium/features/planting_calendar/presentation/state/planting_calendar.state.dart';
import 'package:plantarium/features/planting_calendar/presentation/widgets/monthly_calendar.dart';
import 'package:plantarium/features/planting_calendar/presentation/widgets/planting_recommendation_card.dart';
import 'package:plantarium/shared/widgets/app_widgets.dart';

class PlantingCalendarScreen extends ConsumerWidget {
  const PlantingCalendarScreen({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    // Get the provider and load data
    final notifier = ref.read(plantingCalendarProvider.notifier);

    // Initialize loading data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifier.loadCalendarData();
    });

    return const _PlantingCalendarContent();
  }
}

class _PlantingCalendarContent extends ConsumerStatefulWidget {
  const _PlantingCalendarContent({super.key});

  @override
  ConsumerState<_PlantingCalendarContent> createState() =>
      _PlantingCalendarContentState();
}

class _PlantingCalendarContentState
    extends ConsumerState<_PlantingCalendarContent> {
  PlantingEvent? _selectedEvent;

  @override
  Widget build(final BuildContext context) {
    final state = ref.watch(plantingCalendarProvider);
    final notifier = ref.read(plantingCalendarProvider.notifier);
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
                Expanded(child: _buildBody(context, state, notifier, theme)),
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
    final PlantingCalendarState state,
    final PlantingCalendarNotifier notifier,
    final ThemeData theme,
  ) {
    if (state.isLoading) {
      return AppLoadingIndicators.standard(message: 'Loading calendar data...');
    }

    if (state.hasError) {
      return AppErrorDisplays.standard(
        errorMessage: state.errorMessage ?? 'Unknown error',
        onRetry: () => notifier.loadCalendarData(),
      );
    }

    return Column(
      children: [
        // Calendar controls
        _buildCalendarControls(context, state, notifier, theme),

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
                        month: state.selectedMonth,
                        onDaySelected:
                            (date) => _showEventsForDay(context, date, state),
                        hasEvents: (date) => state.hasEventsOnDay(date),
                        getEventsForDay: (date) => state.getEventsForDay(date),
                        onPreviousMonth: () => notifier.previousMonth(),
                        onNextMonth: () => notifier.nextMonth(),
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
                        state,
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
    final PlantingCalendarState state,
    final PlantingCalendarNotifier notifier,
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
                isSelected: state.isMonthView,
                onTap: () => notifier.setViewMode(true),
                theme: theme,
              ),
              _buildViewToggleButton(
                label: 'Week',
                isSelected: !state.isMonthView,
                onTap: () => notifier.setViewMode(false),
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
              value: state.selectedGarden,
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
                  notifier.setSelectedGarden(newValue);
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
  }) => InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? theme.colorScheme.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color:
              isSelected
                  ? theme.colorScheme.onPrimary
                  : theme.textTheme.bodyLarge?.color,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    ),
  );

  Widget _buildRecommendationsSection(
    final BuildContext context,
    final PlantingCalendarState state,
    final ThemeData theme,
  ) {
    final recommendations = state.recommendations;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Text(
          'Planting Recommendations',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Based on your location and current season',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 16),

        // Recommendations list
        Expanded(
          child:
              recommendations.isEmpty
                  ? Center(
                    child: Text(
                      'No recommendations available',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.textTheme.bodyLarge?.color?.withOpacity(
                          0.7,
                        ),
                      ),
                    ),
                  )
                  : ListView.builder(
                    itemCount: recommendations.length,
                    itemBuilder:
                        (context, index) => PlantingRecommendationCard(
                          recommendation: recommendations[index],
                          onAddToCalendar:
                              () => _addRecommendationToCalendar(
                                context,
                                recommendations[index],
                              ),
                        ),
                  ),
        ),
      ],
    );
  }

  void _showEventsForDay(
    final BuildContext context,
    final DateTime date,
    final PlantingCalendarState state,
  ) {
    final events = state.getEventsForDay(date);

    if (events.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No events on ${DateFormat.yMMMd().format(date)}'),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Events on ${DateFormat.yMMMd().format(date)}'),
            content: SizedBox(
              width: 400,
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: events.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final event = events[index];
                  return ListTile(
                    title: Text(event.title),
                    subtitle: Text('${event.plantName} - ${event.eventType}'),
                    leading: CircleAvatar(
                      backgroundColor: _getEventColor(event.eventType),
                      child: Icon(
                        _getEventIcon(event.eventType),
                        color: Colors.white,
                      ),
                    ),
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

  Color _getEventColor(final String eventType) {
    switch (eventType.toLowerCase()) {
      case 'planting':
        return Colors.green;
      case 'harvesting':
        return Colors.orange;
      case 'maintenance':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getEventIcon(final String eventType) {
    switch (eventType.toLowerCase()) {
      case 'planting':
        return Icons.grass;
      case 'harvesting':
        return Icons.shopping_basket;
      case 'maintenance':
        return Icons.water_drop;
      default:
        return Icons.event;
    }
  }

  void _showAddEventDialog(final BuildContext context) {
    final notifier = ref.read(plantingCalendarProvider.notifier);

    // Form controllers
    final titleController = TextEditingController();
    final plantNameController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    String selectedGarden = 'Backyard Garden';
    String selectedEventType = 'Planting';

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add Planting Event'),
            content: SizedBox(
              width: 400,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title field
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Event Title',
                        hintText: 'e.g., Plant Tomatoes',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Plant name field
                    TextField(
                      controller: plantNameController,
                      decoration: const InputDecoration(
                        labelText: 'Plant Name',
                        hintText: 'e.g., Tomato',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Date picker
                    ListTile(
                      title: const Text('Event Date'),
                      subtitle: Text(DateFormat.yMMMd().format(selectedDate)),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now().subtract(
                            const Duration(days: 365),
                          ),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );
                        if (pickedDate != null) {
                          selectedDate = pickedDate;
                          setState(() {});
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // Garden dropdown
                    DropdownButtonFormField<String>(
                      value: selectedGarden,
                      decoration: const InputDecoration(labelText: 'Garden'),
                      items:
                          [
                            'Backyard Garden',
                            'Herb Garden',
                            'Container Garden',
                            'Raised Bed Garden',
                          ].map((garden) {
                            return DropdownMenuItem<String>(
                              value: garden,
                              child: Text(garden),
                            );
                          }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          selectedGarden = value;
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // Event type dropdown
                    DropdownButtonFormField<String>(
                      value: selectedEventType,
                      decoration: const InputDecoration(
                        labelText: 'Event Type',
                      ),
                      items:
                          ['Planting', 'Harvesting', 'Maintenance'].map((type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          selectedEventType = value;
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (titleController.text.isEmpty ||
                      plantNameController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill all required fields'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    return;
                  }

                  // Create and add new event
                  final newEvent = PlantingEvent(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: titleController.text,
                    date: selectedDate,
                    plantName: plantNameController.text,
                    gardenName: selectedGarden,
                    eventType: selectedEventType,
                  );

                  notifier.addEvent(newEvent);
                  Navigator.of(context).pop();
                },
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }

  void _addRecommendationToCalendar(
    final BuildContext context,
    final PlantingRecommendation recommendation,
  ) {
    // Create a new event from the recommendation
    final notifier = ref.read(plantingCalendarProvider.notifier);
    final now = DateTime.now();

    // Create a new event for the recommendation
    final newEvent = PlantingEvent(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Plant ${recommendation.plantName}',
      date: now,
      plantName: recommendation.plantName,
      gardenName: 'Backyard Garden', // Default garden
      eventType: 'Planting',
      notes:
          'Added from recommendations. ${recommendation.plantingTimeRange}. '
          'Requires ${recommendation.sunRequirement} and '
          '${recommendation.waterRequirement} water.',
    );

    // Add the event to the calendar
    notifier.addEvent(newEvent);

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added ${recommendation.plantName} to calendar'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
