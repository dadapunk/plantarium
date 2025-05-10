import 'package:flutter/material.dart';
import 'package:plantarium/features/planting_calendar/data/models/planting_event.dart';
import 'package:plantarium/features/planting_calendar/data/models/planting_recommendation.dart';

class PlantingCalendarProvider extends ChangeNotifier {
  // State variables
  DateTime _selectedMonth = DateTime.now();
  List<PlantingEvent> _events = [];
  List<PlantingRecommendation> _recommendations = [];
  String _selectedGarden = 'All Gardens';
  bool _isMonthView = true;
  bool _isLoading = false;
  String? _error;

  // Getters
  DateTime get selectedMonth => _selectedMonth;
  List<PlantingEvent> get events => _events;
  List<PlantingRecommendation> get recommendations => _recommendations;
  String get selectedGarden => _selectedGarden;
  bool get isMonthView => _isMonthView;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Events for a specific day
  List<PlantingEvent> getEventsForDay(final DateTime day) =>
      _events
          .where(
            (event) =>
                event.date.year == day.year &&
                event.date.month == day.month &&
                event.date.day == day.day,
          )
          .toList();

  // Check if a day has events
  bool hasEventsOnDay(final DateTime day) => getEventsForDay(day).isNotEmpty;

  // Get filtered events based on selected garden
  List<PlantingEvent> get filteredEvents {
    if (_selectedGarden == 'All Gardens') {
      return _events;
    } else {
      return _events
          .where((final event) => event.gardenName == _selectedGarden)
          .toList();
    }
  }

  // Set selected month
  void setSelectedMonth(final DateTime month) {
    _selectedMonth = DateTime(month.year, month.month);
    notifyListeners();
  }

  // Move to previous month
  void previousMonth() {
    _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
    notifyListeners();
  }

  // Move to next month
  void nextMonth() {
    _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
    notifyListeners();
  }

  // Set view mode (month or week)
  void setViewMode(final bool isMonthView) {
    _isMonthView = isMonthView;
    notifyListeners();
  }

  // Set selected garden
  void setSelectedGarden(final String garden) {
    _selectedGarden = garden;
    notifyListeners();
  }

  // Add a new event
  void addEvent(final PlantingEvent event) {
    _events.add(event);
    notifyListeners();
  }

  // Remove an event
  void removeEvent(final String eventId) {
    _events.removeWhere((final event) => event.id == eventId);
    notifyListeners();
  }

  // Load calendar data
  Future<void> loadCalendarData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // In a real app, this would be an API call or database query
      await Future.delayed(const Duration(milliseconds: 800));
      _events = _getMockEvents();
      _recommendations = _getMockRecommendations();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
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
