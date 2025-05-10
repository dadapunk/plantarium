import 'package:flutter/foundation.dart';
import 'package:plantarium/features/garden_notes/data/models/garden_note.dto.dart';
import 'package:plantarium/shared/services/garden_note_service_interface.dart';
import 'package:plantarium/shared/services/garden_note_cache_service_interface.dart';
import 'package:plantarium/core/network/models/api_error.dart';

class GardenNotesProvider with ChangeNotifier {
  GardenNotesProvider(this.gardenNoteService, this._cacheService);
  final IGardenNoteService gardenNoteService;
  final IGardenNoteCacheService _cacheService;
  List<GardenNoteDTO> _notes = [];
  bool _isLoading = false;
  String? _error;

  List<GardenNoteDTO> get notes => _notes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setError(final ApiError apiError) {
    _error = apiError.message;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> loadNotes() async {
    _isLoading = true;
    _clearError();
    notifyListeners();

    try {
      // First try to load from cache
      final cachedNotes = await _cacheService.getCachedNotes();
      if (cachedNotes.isNotEmpty) {
        _notes = cachedNotes;
        notifyListeners();
      }

      // Then load from network and update cache
      final networkNotes = await gardenNoteService.getAllNotes();
      _notes = networkNotes;
      await _cacheService.cacheNotes(networkNotes);
    } on ApiError catch (e) {
      _setError(e);
    } catch (e) {
      _setError(ApiError(message: e.toString()));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createNote(final GardenNoteDTO note) async {
    try {
      final createdNote = await gardenNoteService.createNote(note);
      _notes = [..._notes, createdNote];
      await _cacheService.cacheNotes(_notes);
      _clearError();
      notifyListeners();
    } on ApiError catch (e) {
      _setError(e);
      rethrow;
    } catch (e) {
      _setError(ApiError(message: e.toString()));
      rethrow;
    }
  }

  Future<void> updateNote(final GardenNoteDTO note) async {
    try {
      final updatedNote = await gardenNoteService.updateNote(note.id!, note);
      _notes =
          _notes.map((final n) => n.id == note.id ? updatedNote : n).toList();
      await _cacheService.cacheNotes(_notes);
      _clearError();
      notifyListeners();
    } on ApiError catch (e) {
      _setError(e);
      rethrow;
    } catch (e) {
      _setError(ApiError(message: e.toString()));
      rethrow;
    }
  }

  Future<void> deleteNote(final int id) async {
    try {
      await gardenNoteService.deleteNote(id);
      _notes = _notes.where((final note) => note.id != id).toList();
      await _cacheService.cacheNotes(_notes);
      _clearError();
      notifyListeners();
    } on ApiError catch (e) {
      _setError(e);
      rethrow;
    } catch (e) {
      _setError(ApiError(message: e.toString()));
      rethrow;
    }
  }

  void clearError() {
    _clearError();
  }
}
