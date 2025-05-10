/// Domain entity for a Garden Note
///
/// This represents a note in the domain layer, independent of data layer concerns
class GardenNote {
  /// Creates a new garden note
  const GardenNote({
    this.id,
    required this.title,
    required this.content,
    required this.date,
  });

  /// Unique identifier for the note
  final int? id;

  /// Title of the note
  final String title;

  /// Content of the note
  final String content;

  /// Date when the note was created or last modified
  final DateTime date;

  /// Creates a copy of this note with the given fields replaced with new values
  GardenNote copyWith({
    final int? id,
    final String? title,
    final String? content,
    final DateTime? date,
  }) => GardenNote(
    id: id ?? this.id,
    title: title ?? this.title,
    content: content ?? this.content,
    date: date ?? this.date,
  );
}
