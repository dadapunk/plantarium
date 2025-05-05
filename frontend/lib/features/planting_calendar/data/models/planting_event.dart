class PlantingEvent {
  final String id;
  final String title;
  final DateTime date;
  final String plantName;
  final String gardenName;
  final String eventType; // planting, harvesting, fertilizing, etc.
  final String notes;

  PlantingEvent({
    required this.id,
    required this.title,
    required this.date,
    required this.plantName,
    required this.gardenName,
    required this.eventType,
    this.notes = '',
  });

  // Create a copy with potentially modified fields
  PlantingEvent copyWith({
    String? id,
    String? title,
    DateTime? date,
    String? plantName,
    String? gardenName,
    String? eventType,
    String? notes,
  }) {
    return PlantingEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      plantName: plantName ?? this.plantName,
      gardenName: gardenName ?? this.gardenName,
      eventType: eventType ?? this.eventType,
      notes: notes ?? this.notes,
    );
  }
}
