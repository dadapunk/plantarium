import 'package:plantarium/features/garden_notes/domain/entities/garden_note.entity.dart';

/// Repository interface for Garden Notes
abstract class GardenNotesRepository {
  /// Get all garden notes
  Future<List<GardenNote>> getAllNotes();

  /// Get a garden note by ID
  Future<GardenNote> getNoteById(int id);

  /// Create a new garden note
  Future<GardenNote> createNote(GardenNote note);

  /// Update an existing garden note
  Future<GardenNote> updateNote(GardenNote note);

  /// Delete a garden note by ID
  Future<void> deleteNote(int id);
}
