import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:plantarium/features/garden_notes/domain/entities/garden_note.entity.dart';

part 'garden_notes.state.freezed.dart';

/// State for garden notes list
@freezed
class GardenNotesState with _$GardenNotesState {
  /// Private constructor required by freezed
  const GardenNotesState._();

  /// Initial state
  const factory GardenNotesState.initial() = _Initial;

  /// Loading state
  const factory GardenNotesState.loading() = _Loading;

  /// Success state with loaded notes
  const factory GardenNotesState.success({
    required final List<GardenNote> notes,
  }) = _Success;

  /// Error state
  const factory GardenNotesState.error({
    required final String message,
    final String? errorCode,
    final Map<String, dynamic>? errorDetails,
  }) = _Error;

  /// Helper to check if the state is in loading state
  bool get isLoading => maybeMap(loading: (_) => true, orElse: () => false);

  /// Helper to check if the state contains an error
  bool get hasError => maybeMap(error: (_) => true, orElse: () => false);

  /// Helper to get the notes from the success state
  List<GardenNote> get notes =>
      maybeMap(success: (final state) => state.notes, orElse: () => []);

  /// Helper to get the error message
  String? get errorMessage =>
      maybeMap(error: (final state) => state.message, orElse: () => null);
}

/// State for garden note detail (view/edit/create)
@freezed
class GardenNoteDetailState with _$GardenNoteDetailState {
  /// Private constructor required by freezed
  const GardenNoteDetailState._();

  /// Initial state
  const factory GardenNoteDetailState.initial() = _DetailInitial;

  /// Loading state when fetching a note
  const factory GardenNoteDetailState.loading() = _DetailLoading;

  /// Success state with loaded note
  const factory GardenNoteDetailState.success({
    required final GardenNote note,
  }) = _DetailSuccess;

  /// Error state
  const factory GardenNoteDetailState.error({
    required final String message,
    final String? errorCode,
    final Map<String, dynamic>? errorDetails,
  }) = _DetailError;

  /// State when creating or updating a note
  const factory GardenNoteDetailState.saving() = _DetailSaving;

  /// State after successful save
  const factory GardenNoteDetailState.saved({required final GardenNote note}) =
      _DetailSaved;

  /// State when deleting a note
  const factory GardenNoteDetailState.deleting() = _DetailDeleting;

  /// State after successful delete
  const factory GardenNoteDetailState.deleted() = _DetailDeleted;

  /// Helper to check if the state is in loading state
  bool get isLoading => maybeMap(loading: (_) => true, orElse: () => false);

  /// Helper to check if the state is in saving state
  bool get isSaving => maybeMap(saving: (_) => true, orElse: () => false);

  /// Helper to check if the state is in deleting state
  bool get isDeleting => maybeMap(deleting: (_) => true, orElse: () => false);

  /// Helper to check if any operation is in progress
  bool get isProcessing => isLoading || isSaving || isDeleting;

  /// Helper to check if the state contains an error
  bool get hasError => maybeMap(error: (_) => true, orElse: () => false);

  /// Helper to get the note from states that contain it
  GardenNote? get note => maybeMap(
    success: (final state) => state.note,
    saved: (final state) => state.note,
    orElse: () => null,
  );

  /// Helper to get the error message
  String? get errorMessage =>
      maybeMap(error: (final state) => state.message, orElse: () => null);
}
