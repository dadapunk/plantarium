import 'package:plantarium/features/garden_notes/domain/entities/garden_note.entity.dart';
import 'package:plantarium/features/garden_notes/domain/repositories/garden_notes.repository.dart';

/// Use case for getting all garden notes
class GetAllNotesUseCase {
  /// Constructor
  const GetAllNotesUseCase(this.repository);

  /// The garden notes repository
  final GardenNotesRepository repository;

  /// Execute the use case to get all notes
  Future<List<GardenNote>> call() => repository.getAllNotes();
}
