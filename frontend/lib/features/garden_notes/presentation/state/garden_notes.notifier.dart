import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plantarium/features/garden_notes/domain/usecases/get_all_notes.usecase.dart';
import 'package:plantarium/features/garden_notes/domain/usecases/create_note.usecase.dart';
import 'package:plantarium/features/garden_notes/domain/usecases/update_note.usecase.dart';
import 'package:plantarium/features/garden_notes/domain/usecases/delete_note.usecase.dart';
import 'package:plantarium/features/garden_notes/domain/entities/garden_note.entity.dart';
import 'package:plantarium/features/garden_notes/presentation/state/garden_notes.state.dart';

/// Notifier for garden notes list
class GardenNotesNotifier extends StateNotifier<GardenNotesState> {
  /// Get all notes use case
  final GetAllNotesUseCase _getAllNotesUseCase;

  /// Create note use case
  final CreateNoteUseCase _createNoteUseCase;

  /// Update note use case
  final UpdateNoteUseCase _updateNoteUseCase;

  /// Delete note use case
  final DeleteNoteUseCase _deleteNoteUseCase;

  /// Constructor
  GardenNotesNotifier({
    required GetAllNotesUseCase getAllNotesUseCase,
    required CreateNoteUseCase createNoteUseCase,
    required UpdateNoteUseCase updateNoteUseCase,
    required DeleteNoteUseCase deleteNoteUseCase,
  }) : _getAllNotesUseCase = getAllNotesUseCase,
       _createNoteUseCase = createNoteUseCase,
       _updateNoteUseCase = updateNoteUseCase,
       _deleteNoteUseCase = deleteNoteUseCase,
       super(const GardenNotesState.initial());

  /// Load all garden notes
  Future<void> loadNotes() async {
    state = const GardenNotesState.loading();

    try {
      final notes = await _getAllNotesUseCase();
      state = GardenNotesState.success(notes: notes);
    } catch (e) {
      state = GardenNotesState.error(message: e.toString());
    }
  }

  /// Create a garden note
  Future<void> createNote(GardenNote note) async {
    try {
      final createdNote = await _createNoteUseCase(note);

      // Update the list of notes if we have them already
      state.maybeMap(
        success: (success) {
          state = GardenNotesState.success(
            notes: [...success.notes, createdNote],
          );
        },
        orElse: () {
          // If we don't have notes loaded yet, load them
          loadNotes();
        },
      );
    } catch (e) {
      state = GardenNotesState.error(message: e.toString());
    }
  }

  /// Update a garden note
  Future<void> updateNote(GardenNote note) async {
    try {
      final updatedNote = await _updateNoteUseCase(note);

      // Update the note in the list
      state.maybeMap(
        success: (success) {
          final updatedNotes =
              success.notes
                  .map((n) => n.id == updatedNote.id ? updatedNote : n)
                  .toList();

          state = GardenNotesState.success(notes: updatedNotes);
        },
        orElse: () {
          // If we don't have notes loaded yet, load them
          loadNotes();
        },
      );
    } catch (e) {
      state = GardenNotesState.error(message: e.toString());
    }
  }

  /// Delete a garden note
  Future<void> deleteNote(int id) async {
    try {
      await _deleteNoteUseCase(id);

      // Remove the note from the list
      state.maybeMap(
        success: (success) {
          final updatedNotes =
              success.notes.where((note) => note.id != id).toList();
          state = GardenNotesState.success(notes: updatedNotes);
        },
        orElse: () {
          // If we don't have notes loaded yet, load them
          loadNotes();
        },
      );
    } catch (e) {
      state = GardenNotesState.error(message: e.toString());
    }
  }

  /// Clear any error state
  void clearError() {
    state.maybeMap(
      error: (_) {
        // Get back to the previous state if possible
        final currentNotes = state.notes;
        if (currentNotes.isNotEmpty) {
          state = GardenNotesState.success(notes: currentNotes);
        } else {
          state = const GardenNotesState.initial();
        }
      },
      orElse: () {},
    );
  }
}
