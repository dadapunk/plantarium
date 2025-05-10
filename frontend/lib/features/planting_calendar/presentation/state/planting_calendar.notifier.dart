import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plantarium/features/planting_calendar/data/models/planting_event.dart';
import 'package:plantarium/features/planting_calendar/data/models/planting_recommendation.dart';
import 'package:plantarium/features/planting_calendar/presentation/state/planting_calendar.state.dart';

/// Notifier for planting calendar
class PlantingCalendarNotifier extends StateNotifier<PlantingCalendarState> {
  /// Constructor
  PlantingCalendarNotifier() : super(const PlantingCalendarState.initial());

  /// Load calendar data
  Future<void> loadCalendarData() async {
    state = const PlantingCalendarState.loading();

    try {
      // In a real app, this would call a repository or use case
      await Future.delayed(const Duration(milliseconds: 800));
      final events = _getMockEvents();
      final recommendations = _getMockRecommendations();

      state = PlantingCalendarState.success(
        events: events,
        recommendations: recommendations,
        selectedMonth: DateTime.now(),
        selectedGarden: 'All Gardens',
        isMonthView: true,
      );
    } catch (e) {
      state = PlantingCalendarState.error(message: e.toString());
    }
  }

  /// Set selected month
  void setSelectedMonth(final DateTime month) {
    state.maybeMap(
      success: (success) {
        state = PlantingCalendarState.success(
          events: success.events,
          recommendations: success.recommendations,
          selectedMonth: DateTime(month.year, month.month),
          selectedGarden: success.selectedGarden,
          isMonthView: success.isMonthView,
        );
      },
      orElse: () {},
    );
  }

  /// Move to previous month
  void previousMonth() {
    state.maybeMap(
      success: (success) {
        final newMonth = DateTime(
          success.selectedMonth.year,
          success.selectedMonth.month - 1,
        );

        state = PlantingCalendarState.success(
          events: success.events,
          recommendations: success.recommendations,
          selectedMonth: newMonth,
          selectedGarden: success.selectedGarden,
          isMonthView: success.isMonthView,
        );
      },
      orElse: () {},
    );
  }

  /// Move to next month
  void nextMonth() {
    state.maybeMap(
      success: (success) {
        final newMonth = DateTime(
          success.selectedMonth.year,
          success.selectedMonth.month + 1,
        );

        state = PlantingCalendarState.success(
          events: success.events,
          recommendations: success.recommendations,
          selectedMonth: newMonth,
          selectedGarden: success.selectedGarden,
          isMonthView: success.isMonthView,
        );
      },
      orElse: () {},
    );
  }

  /// Set view mode (month or week)
  void setViewMode(final bool isMonthView) {
    state.maybeMap(
      success: (success) {
        state = PlantingCalendarState.success(
          events: success.events,
          recommendations: success.recommendations,
          selectedMonth: success.selectedMonth,
          selectedGarden: success.selectedGarden,
          isMonthView: isMonthView,
        );
      },
      orElse: () {},
    );
  }

  /// Set selected garden
  void setSelectedGarden(final String garden) {
    state.maybeMap(
      success: (success) {
        state = PlantingCalendarState.success(
          events: success.events,
          recommendations: success.recommendations,
          selectedMonth: success.selectedMonth,
          selectedGarden: garden,
          isMonthView: success.isMonthView,
        );
      },
      orElse: () {},
    );
  }

  /// Add a new event
  void addEvent(final PlantingEvent event) {
    state.maybeMap(
      success: (success) {
        final updatedEvents = [...success.events, event];

        state = PlantingCalendarState.success(
          events: updatedEvents,
          recommendations: success.recommendations,
          selectedMonth: success.selectedMonth,
          selectedGarden: success.selectedGarden,
          isMonthView: success.isMonthView,
        );
      },
      orElse: () {},
    );
  }

  /// Remove an event
  void removeEvent(final String eventId) {
    state.maybeMap(
      success: (success) {
        final updatedEvents =
            success.events.where((event) => event.id != eventId).toList();

        state = PlantingCalendarState.success(
          events: updatedEvents,
          recommendations: success.recommendations,
          selectedMonth: success.selectedMonth,
          selectedGarden: success.selectedGarden,
          isMonthView: success.isMonthView,
        );
      },
      orElse: () {},
    );
  }

  /// Clear any error state
  void clearError() {
    state.maybeMap(
      error: (_) {
        state = const PlantingCalendarState.initial();
      },
      orElse: () {},
    );
  }

  // Mock data for planting events
  List<PlantingEvent> _getMockEvents() {
    final now = DateTime.now();
    final currentYear = now.year;
    final currentMonth = now.month;

    return [
      PlantingEvent(
        id: '1',
        title: 'Plant Tomatoes',
        date: DateTime(currentYear, currentMonth, 2),
        plantName: 'Tomato',
        gardenName: 'Backyard Garden',
        eventType: 'Planting',
      ),
      PlantingEvent(
        id: '2',
        title: 'Harvest Lettuce',
        date: DateTime(currentYear, currentMonth, 5),
        plantName: 'Lettuce',
        gardenName: 'Container Garden',
        eventType: 'Harvesting',
      ),
      PlantingEvent(
        id: '3',
        title: 'Fertilize Peppers',
        date: DateTime(currentYear, currentMonth, 8),
        plantName: 'Bell Pepper',
        gardenName: 'Backyard Garden',
        eventType: 'Maintenance',
      ),
      PlantingEvent(
        id: '4',
        title: 'Plant Carrots',
        date: DateTime(currentYear, currentMonth, 10),
        plantName: 'Carrot',
        gardenName: 'Raised Bed Garden',
        eventType: 'Planting',
      ),
      PlantingEvent(
        id: '5',
        title: 'Water Herbs',
        date: DateTime(currentYear, currentMonth, 14),
        plantName: 'Basil',
        gardenName: 'Herb Garden',
        eventType: 'Maintenance',
      ),
      PlantingEvent(
        id: '6',
        title: 'Plant Cucumbers',
        date: DateTime(currentYear, currentMonth, 20),
        plantName: 'Cucumber',
        gardenName: 'Backyard Garden',
        eventType: 'Planting',
      ),
      PlantingEvent(
        id: '7',
        title: 'Prune Tomatoes',
        date: DateTime(currentYear, currentMonth, 22),
        plantName: 'Tomato',
        gardenName: 'Backyard Garden',
        eventType: 'Maintenance',
      ),
      PlantingEvent(
        id: '8',
        title: 'Harvest Carrots',
        date: DateTime(currentYear, currentMonth, 28),
        plantName: 'Carrot',
        gardenName: 'Raised Bed Garden',
        eventType: 'Harvesting',
      ),
    ];
  }

  // Mock data for planting recommendations
  List<PlantingRecommendation> _getMockRecommendations() => [
    PlantingRecommendation(
      id: '1',
      plantName: 'Tomato',
      plantingTimeRange: 'Mid-May to Early June',
      sunRequirement: 'Full Sun',
      waterRequirement: 'Moderate',
      isIdealTime: true,
    ),
    PlantingRecommendation(
      id: '2',
      plantName: 'Lettuce',
      plantingTimeRange: 'Now until mid-June',
      sunRequirement: 'Partial Shade',
      waterRequirement: 'Regular',
      isIdealTime: true,
    ),
    PlantingRecommendation(
      id: '3',
      plantName: 'Carrot',
      plantingTimeRange: 'Early May to mid-June',
      sunRequirement: 'Full Sun',
      waterRequirement: 'Regular',
      isIdealTime: true,
    ),
    PlantingRecommendation(
      id: '4',
      plantName: 'Bell Pepper',
      plantingTimeRange: 'Late May to mid-June',
      sunRequirement: 'Full Sun',
      waterRequirement: 'Moderate',
      isPossible: true,
    ),
    PlantingRecommendation(
      id: '5',
      plantName: 'Basil',
      plantingTimeRange: 'Mid-May to late June',
      sunRequirement: 'Full Sun',
      waterRequirement: 'Moderate',
      isIdealTime: true,
    ),
    PlantingRecommendation(
      id: '6',
      plantName: 'Cucumber',
      plantingTimeRange: 'Late May to mid-June',
      sunRequirement: 'Full Sun',
      waterRequirement: 'Regular',
      isPossible: true,
    ),
  ];
}
