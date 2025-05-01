import 'package:flutter/foundation.dart';
import 'package:plantarium/features/garden_notes/data/models/garden_note.dto.dart';
import 'package:plantarium/core/services/garden_note.service.dart';
import 'package:plantarium/core/services/garden_note_cache.service.dart';
import 'package:plantarium/core/network/models/api_error.dart';

class GardenNotesProvider with ChangeNotifier {
  final GardenNoteService gardenNoteService;
  final GardenNoteCacheService _cacheService;
  List<GardenNoteDTO> _notes = [];
  bool _isLoading = false;
  String? _error;
  String? _errorCode;
  Map<String, dynamic>? _errorDetails;

  GardenNotesProvider(this.gardenNoteService)
    : _cacheService = GardenNoteCacheService();

  List<GardenNoteDTO> get notes => _notes;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get errorCode => _errorCode;
  Map<String, dynamic>? get errorDetails => _errorDetails;

  void _setError(ApiError apiError) {
    _error = apiError.message;
    _errorCode = apiError.errorCode;
    _errorDetails = apiError.errorDetails;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    _errorCode = null;
    _errorDetails = null;
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

  Future<void> createNote(GardenNoteDTO note) async {
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

  Future<void> updateNote(GardenNoteDTO note) async {
    try {
      final updatedNote = await gardenNoteService.updateNote(note.id!, note);
      _notes = _notes.map((n) => n.id == note.id ? updatedNote : n).toList();
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

  Future<void> deleteNote(int id) async {
    try {
      await gardenNoteService.deleteNote(id);
      _notes = _notes.where((note) => note.id != id).toList();
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
