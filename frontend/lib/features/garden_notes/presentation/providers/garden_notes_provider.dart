import 'package:flutter/foundation.dart';
import 'package:plantarium/features/garden_notes/data/models/garden_note.dto.dart';
import 'package:plantarium/shared/services/garden_note_cache_service_interface.dart';
import 'package:plantarium/core/network/models/api_error.dart';

/// Provider for garden notes that uses only local storage for the MVP
class GardenNotesProvider with ChangeNotifier {
  /// Constructor
  GardenNotesProvider(this._cacheService);

  final IGardenNoteCacheService _cacheService;
  List<GardenNoteDTO> _notes = [];
  bool _isLoading = false;
  String? _error;

  /// The list of garden notes
  List<GardenNoteDTO> get notes => _notes;

  /// Whether the provider is loading data
  bool get isLoading => _isLoading;

  /// The current error, if any
  String? get error => _error;

  void _setError(final String message) {
    _error = message;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  /// Load garden notes from local storage
  Future<void> loadNotes() async {
    _isLoading = true;
    _clearError();
    notifyListeners();

    try {
      // Load from local storage
      final cachedNotes = await _cacheService.getCachedNotes();
      _notes = cachedNotes;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading garden notes: $e');
      }
      _setError('Failed to load garden notes: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Create a new garden note
  Future<void> createNote(final GardenNoteDTO note) async {
    try {
      // Generate a temporary ID for local storage
      // In a real app with a backend, the server would assign an ID
      final newNote = GardenNoteDTO(
        id: DateTime.now().millisecondsSinceEpoch,
        title: note.title,
        note: note.note,
        date: note.date,
      );

      _notes = [..._notes, newNote];
      await _cacheService.cacheNotes(_notes);
      _clearError();
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error creating garden note: $e');
      }
      _setError('Failed to create garden note: $e');
      rethrow;
    }
  }

  /// Update an existing garden note
  Future<void> updateNote(final GardenNoteDTO note) async {
    try {
      if (note.id == null) {
        throw ArgumentError('Note ID cannot be null for update operation');
      }

      _notes = _notes.map((n) => n.id == note.id ? note : n).toList();
      await _cacheService.cacheNotes(_notes);
      _clearError();
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error updating garden note: $e');
      }
      _setError('Failed to update garden note: $e');
      rethrow;
    }
  }

  /// Delete a garden note
  Future<void> deleteNote(final int id) async {
    try {
      _notes = _notes.where((note) => note.id != id).toList();
      await _cacheService.cacheNotes(_notes);
      _clearError();
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting garden note: $e');
      }
      _setError('Failed to delete garden note: $e');
      rethrow;
    }
  }

  /// Clear any errors
  void clearError() {
    _clearError();
  }
}
