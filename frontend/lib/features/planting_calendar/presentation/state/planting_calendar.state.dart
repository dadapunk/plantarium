import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:plantarium/features/planting_calendar/data/models/planting_event.dart';
import 'package:plantarium/features/planting_calendar/data/models/planting_recommendation.dart';

part 'planting_calendar.state.freezed.dart';

/// State for planting calendar
@freezed
class PlantingCalendarState with _$PlantingCalendarState {
  /// Private constructor required by freezed
  const PlantingCalendarState._();

  /// Initial state
  const factory PlantingCalendarState.initial() = _Initial;

  /// Loading state
  const factory PlantingCalendarState.loading() = _Loading;

  /// Success state with loaded calendar data
  const factory PlantingCalendarState.success({
    required final List<PlantingEvent> events,
    required final List<PlantingRecommendation> recommendations,
    required final DateTime selectedMonth,
    required final String selectedGarden,
    required final bool isMonthView,
  }) = _Success;

  /// Error state
  const factory PlantingCalendarState.error({required final String message}) =
      _Error;

  /// Helper to check if the state is in loading state
  bool get isLoading => maybeMap(loading: (_) => true, orElse: () => false);

  /// Helper to check if the state contains an error
  bool get hasError => maybeMap(error: (_) => true, orElse: () => false);

  /// Helper to get all events
  List<PlantingEvent> get allEvents =>
      maybeMap(success: (state) => state.events, orElse: () => []);

  /// Helper to get the filtered events based on selected garden
  List<PlantingEvent> get filteredEvents => maybeMap(
    success: (state) {
      if (state.selectedGarden == 'All Gardens') {
        return state.events;
      } else {
        return state.events
            .where((event) => event.gardenName == state.selectedGarden)
            .toList();
      }
    },
    orElse: () => [],
  );

  /// Helper to get events for a specific day
  List<PlantingEvent> getEventsForDay(final DateTime day) => maybeMap(
    success:
        (state) =>
            state.events
                .where(
                  (event) =>
                      event.date.year == day.year &&
                      event.date.month == day.month &&
                      event.date.day == day.day,
                )
                .toList(),
    orElse: () => [],
  );

  /// Helper to check if a day has events
  bool hasEventsOnDay(final DateTime day) => getEventsForDay(day).isNotEmpty;

  /// Helper to get all recommendations
  List<PlantingRecommendation> get recommendations =>
      maybeMap(success: (state) => state.recommendations, orElse: () => []);

  /// Helper to get the selected month
  DateTime get selectedMonth => maybeMap(
    success: (state) => state.selectedMonth,
    orElse: () => DateTime.now(),
  );

  /// Helper to get the selected garden
  String get selectedGarden => maybeMap(
    success: (state) => state.selectedGarden,
    orElse: () => 'All Gardens',
  );

  /// Helper to check if it's month view
  bool get isMonthView =>
      maybeMap(success: (state) => state.isMonthView, orElse: () => true);

  /// Helper to get the error message
  String? get errorMessage =>
      maybeMap(error: (state) => state.message, orElse: () => null);
}
