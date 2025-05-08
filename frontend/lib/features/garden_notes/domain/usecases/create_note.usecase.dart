import 'package:plantarium/features/garden_notes/domain/entities/garden_note.entity.dart';
import 'package:plantarium/features/garden_notes/domain/repositories/garden_notes.repository.dart';

/// Use case for creating a garden note
class CreateNoteUseCase {
  /// The garden notes repository
  final GardenNotesRepository repository;

  /// Constructor
  const CreateNoteUseCase(this.repository);

  /// Execute the use case to create a note
  Future<GardenNote> call(GardenNote note) {
    return repository.createNote(note);
  }
}
