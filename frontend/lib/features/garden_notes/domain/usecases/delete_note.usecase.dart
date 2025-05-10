import 'package:plantarium/features/garden_notes/domain/repositories/garden_notes.repository.dart';

/// Use case for deleting a garden note
class DeleteNoteUseCase {
  /// Constructor
  const DeleteNoteUseCase(this.repository);

  /// The garden notes repository
  final GardenNotesRepository repository;

  /// Execute the use case to delete a note by ID
  Future<void> call(final int id) => repository.deleteNote(id);
}
