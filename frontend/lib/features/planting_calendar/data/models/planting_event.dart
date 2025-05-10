class PlantingEvent {
  PlantingEvent({
    required this.id,
    required this.title,
    required this.date,
    required this.plantName,
    required this.gardenName,
    required this.eventType,
    this.notes = '',
  });
  final String id;
  final String title;
  final DateTime date;
  final String plantName;
  final String gardenName;
  final String eventType; // planting, harvesting, fertilizing, etc.
  final String notes;

  // Create a copy with potentially modified fields
  PlantingEvent copyWith({
    final String? id,
    final String? title,
    final DateTime? date,
    final String? plantName,
    final String? gardenName,
    final String? eventType,
    final String? notes,
  }) => PlantingEvent(
    id: id ?? this.id,
    title: title ?? this.title,
    date: date ?? this.date,
    plantName: plantName ?? this.plantName,
    gardenName: gardenName ?? this.gardenName,
    eventType: eventType ?? this.eventType,
    notes: notes ?? this.notes,
  );
}
