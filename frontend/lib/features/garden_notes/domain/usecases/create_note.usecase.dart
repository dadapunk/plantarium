import 'package:plantarium/features/garden_notes/domain/entities/garden_note.entity.dart';
import 'package:plantarium/features/garden_notes/domain/repositories/garden_notes.repository.dart';

/// Use case for creating a garden note
class CreateNoteUseCase {
  /// Constructor
  const CreateNoteUseCase(this.repository);

  /// The garden notes repository
  final GardenNotesRepository repository;

  /// Execute the use case to create a note
  Future<GardenNote> call(final GardenNote note) => repository.createNote(note);
}
