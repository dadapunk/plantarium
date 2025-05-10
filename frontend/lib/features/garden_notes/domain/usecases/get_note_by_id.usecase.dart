import 'package:plantarium/features/garden_notes/domain/entities/garden_note.entity.dart';
import 'package:plantarium/features/garden_notes/domain/repositories/garden_notes.repository.dart';

/// Use case for getting a garden note by ID
class GetNoteByIdUseCase {
  /// Constructor
  const GetNoteByIdUseCase(this.repository);

  /// The garden notes repository
  final GardenNotesRepository repository;

  /// Execute the use case to get a note by ID
  Future<GardenNote> call(final int id) => repository.getNoteById(id);
}
