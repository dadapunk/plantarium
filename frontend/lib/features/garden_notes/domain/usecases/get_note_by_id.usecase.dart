import 'package:plantarium/features/garden_notes/domain/entities/garden_note.entity.dart';
import 'package:plantarium/features/garden_notes/domain/repositories/garden_notes.repository.dart';

/// Use case for getting a garden note by ID
class GetNoteByIdUseCase {
  /// The garden notes repository
  final GardenNotesRepository repository;

  /// Constructor
  const GetNoteByIdUseCase(this.repository);

  /// Execute the use case to get a note by ID
  Future<GardenNote> call(int id) {
    return repository.getNoteById(id);
  }
}
