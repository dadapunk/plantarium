import 'package:plantarium/features/garden_notes/data/models/garden_note.dto.dart';
import 'package:plantarium/shared/services/base_service.dart';

/// Interface defining the contract for garden note operations
abstract class IGardenNoteService extends BaseService {
  /// Retrieves all garden notes
  Future<List<GardenNoteDTO>> getAllNotes();

  /// Retrieves a garden note by its ID
  Future<GardenNoteDTO> getNoteById(final int id);

  /// Creates a new garden note
  Future<GardenNoteDTO> createNote(final GardenNoteDTO note);

  /// Updates an existing garden note
  Future<GardenNoteDTO> updateNote(final int id, final GardenNoteDTO note);

  /// Deletes a garden note by its ID
  Future<void> deleteNote(final int id);
}
