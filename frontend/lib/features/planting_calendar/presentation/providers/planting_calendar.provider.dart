import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plantarium/features/planting_calendar/presentation/state/planting_calendar.notifier.dart';
import 'package:plantarium/features/planting_calendar/presentation/state/planting_calendar.state.dart';

/// Provider for planting calendar
final plantingCalendarProvider =
    StateNotifierProvider<PlantingCalendarNotifier, PlantingCalendarState>(
      (ref) => PlantingCalendarNotifier(),
    );
