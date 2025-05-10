import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plantarium/features/garden_notes/domain/usecases/get_note_by_id.usecase.dart';
import 'package:plantarium/features/garden_notes/domain/usecases/create_note.usecase.dart';
import 'package:plantarium/features/garden_notes/domain/usecases/update_note.usecase.dart';
import 'package:plantarium/features/garden_notes/domain/usecases/delete_note.usecase.dart';
import 'package:plantarium/features/garden_notes/domain/entities/garden_note.entity.dart';
import 'package:plantarium/features/garden_notes/presentation/state/garden_notes.state.dart';

/// Notifier for garden note detail operations
class GardenNoteDetailNotifier extends StateNotifier<GardenNoteDetailState> {
  /// Constructor
  GardenNoteDetailNotifier({
    required GetNoteByIdUseCase getNoteByIdUseCase,
    required CreateNoteUseCase createNoteUseCase,
    required UpdateNoteUseCase updateNoteUseCase,
    required DeleteNoteUseCase deleteNoteUseCase,
  }) : _getNoteByIdUseCase = getNoteByIdUseCase,
       _createNoteUseCase = createNoteUseCase,
       _updateNoteUseCase = updateNoteUseCase,
       _deleteNoteUseCase = deleteNoteUseCase,
       super(const GardenNoteDetailState.initial());

  /// Get note by ID use case
  final GetNoteByIdUseCase _getNoteByIdUseCase;

  /// Create note use case
  final CreateNoteUseCase _createNoteUseCase;

  /// Update note use case
  final UpdateNoteUseCase _updateNoteUseCase;

  /// Delete note use case
  final DeleteNoteUseCase _deleteNoteUseCase;

  /// Load a garden note by ID
  Future<void> loadNote(final int id) async {
    state = const GardenNoteDetailState.loading();

    try {
      final note = await _getNoteByIdUseCase(id);
      state = GardenNoteDetailState.success(note: note);
    } catch (e) {
      state = GardenNoteDetailState.error(message: e.toString());
    }
  }

  /// Create a new garden note
  Future<void> createNote(final GardenNote note) async {
    state = const GardenNoteDetailState.saving();

    try {
      final createdNote = await _createNoteUseCase(note);
      state = GardenNoteDetailState.saved(note: createdNote);
    } catch (e) {
      state = GardenNoteDetailState.error(message: e.toString());
    }
  }

  /// Update an existing garden note
  Future<void> updateNote(final GardenNote note) async {
    state = const GardenNoteDetailState.saving();

    try {
      final updatedNote = await _updateNoteUseCase(note);
      state = GardenNoteDetailState.saved(note: updatedNote);
    } catch (e) {
      state = GardenNoteDetailState.error(message: e.toString());
    }
  }

  /// Delete a garden note
  Future<void> deleteNote(final int id) async {
    state = const GardenNoteDetailState.deleting();

    try {
      await _deleteNoteUseCase(id);
      state = const GardenNoteDetailState.deleted();
    } catch (e) {
      state = GardenNoteDetailState.error(message: e.toString());
    }
  }

  /// Save a garden note (create or update)
  Future<void> saveNote(final GardenNote note) async {
    if (note.id == null) {
      await createNote(note);
    } else {
      await updateNote(note);
    }
  }

  /// Reset the state to initial
  void reset() {
    state = const GardenNoteDetailState.initial();
  }

  /// Clear any error state
  void clearError() {
    if (state.hasError) {
      final currentNote = state.note;
      if (currentNote != null) {
        state = GardenNoteDetailState.success(note: currentNote);
      } else {
        state = const GardenNoteDetailState.initial();
      }
    }
  }
}
