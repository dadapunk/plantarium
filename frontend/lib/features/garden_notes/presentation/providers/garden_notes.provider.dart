import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plantarium/features/garden_notes/domain/repositories/garden_notes.repository.dart';
import 'package:plantarium/features/garden_notes/domain/usecases/get_all_notes.usecase.dart';
import 'package:plantarium/features/garden_notes/domain/usecases/get_note_by_id.usecase.dart';
import 'package:plantarium/features/garden_notes/domain/usecases/create_note.usecase.dart';
import 'package:plantarium/features/garden_notes/domain/usecases/update_note.usecase.dart';
import 'package:plantarium/features/garden_notes/domain/usecases/delete_note.usecase.dart';
import 'package:plantarium/features/garden_notes/presentation/state/garden_notes.state.dart';
import 'package:plantarium/features/garden_notes/presentation/state/garden_notes.notifier.dart';
import 'package:plantarium/features/garden_notes/presentation/state/garden_note_detail.notifier.dart';
import 'package:plantarium/shared/di/service_locator.dart';

/// Provider for the garden notes repository
final gardenNotesRepositoryProvider = Provider<GardenNotesRepository>(
  (final ref) => getIt<GardenNotesRepository>(),
);

/// Provider for the get all notes use case
final getAllNotesUseCaseProvider = Provider<GetAllNotesUseCase>(
  (final ref) => getIt<GetAllNotesUseCase>(),
);

/// Provider for the get note by ID use case
final getNoteByIdUseCaseProvider = Provider<GetNoteByIdUseCase>(
  (final ref) => getIt<GetNoteByIdUseCase>(),
);

/// Provider for the create note use case
final createNoteUseCaseProvider = Provider<CreateNoteUseCase>(
  (final ref) => getIt<CreateNoteUseCase>(),
);

/// Provider for the update note use case
final updateNoteUseCaseProvider = Provider<UpdateNoteUseCase>(
  (final ref) => getIt<UpdateNoteUseCase>(),
);

/// Provider for the delete note use case
final deleteNoteUseCaseProvider = Provider<DeleteNoteUseCase>(
  (final ref) => getIt<DeleteNoteUseCase>(),
);

/// Provider for garden notes state notifier
final gardenNotesProvider =
    StateNotifierProvider<GardenNotesNotifier, GardenNotesState>(
      (final ref) => GardenNotesNotifier(
        getAllNotesUseCase: ref.watch(getAllNotesUseCaseProvider),
        createNoteUseCase: ref.watch(createNoteUseCaseProvider),
        updateNoteUseCase: ref.watch(updateNoteUseCaseProvider),
        deleteNoteUseCase: ref.watch(deleteNoteUseCaseProvider),
      ),
    );

/// Provider for garden note detail state notifier
final gardenNoteDetailProvider = StateNotifierProvider.autoDispose<
  GardenNoteDetailNotifier,
  GardenNoteDetailState
>(
  (final ref) => GardenNoteDetailNotifier(
    getNoteByIdUseCase: ref.watch(getNoteByIdUseCaseProvider),
    createNoteUseCase: ref.watch(createNoteUseCaseProvider),
    updateNoteUseCase: ref.watch(updateNoteUseCaseProvider),
    deleteNoteUseCase: ref.watch(deleteNoteUseCaseProvider),
  ),
);

/// Provider to get a specific garden note by ID
final gardenNoteByIdProvider = Provider.family<void, int>((
  final ref,
  final id,
) {
  final detailNotifier = ref.watch(gardenNoteDetailProvider.notifier);
  detailNotifier.loadNote(id);
});
