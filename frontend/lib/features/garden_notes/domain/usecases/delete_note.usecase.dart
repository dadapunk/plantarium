import 'package:plantarium/features/garden_notes/domain/repositories/garden_notes.repository.dart';

/// Use case for deleting a garden note
class DeleteNoteUseCase {
  /// The garden notes repository
  final GardenNotesRepository repository;

  /// Constructor
  const DeleteNoteUseCase(this.repository);

  /// Execute the use case to delete a note by ID
  Future<void> call(int id) {
    return repository.deleteNote(id);
  }
}
