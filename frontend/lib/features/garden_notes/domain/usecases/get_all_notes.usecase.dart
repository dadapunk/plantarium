import 'package:plantarium/features/garden_notes/domain/entities/garden_note.entity.dart';
import 'package:plantarium/features/garden_notes/domain/repositories/garden_notes.repository.dart';

/// Use case for getting all garden notes
class GetAllNotesUseCase {
  /// The garden notes repository
  final GardenNotesRepository repository;

  /// Constructor
  const GetAllNotesUseCase(this.repository);

  /// Execute the use case to get all notes
  Future<List<GardenNote>> call() {
    return repository.getAllNotes();
  }
}
