import 'package:plantarium/features/garden_notes/domain/entities/garden_note.entity.dart';
import 'package:plantarium/features/garden_notes/domain/repositories/garden_notes.repository.dart';

/// Use case for updating a garden note
class UpdateNoteUseCase {
  /// Constructor
  const UpdateNoteUseCase(this.repository);

  /// The garden notes repository
  final GardenNotesRepository repository;

  /// Execute the use case to update a note
  Future<GardenNote> call(final GardenNote note) {
    if (note.id == null) {
      throw ArgumentError('Cannot update a note without an ID');
    }
    return repository.updateNote(note);
  }
}
