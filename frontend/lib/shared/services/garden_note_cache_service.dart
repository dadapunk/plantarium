import 'dart:convert';

import 'package:plantarium/features/garden_notes/data/models/garden_note.dto.dart';
import 'package:plantarium/shared/services/garden_note_cache_service_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Implementation of the garden note cache service using SharedPreferences
class GardenNoteCacheService implements IGardenNoteCacheService {
  /// Key used to store garden notes in SharedPreferences
  static const _storageKey = 'garden_notes_cache';

  @override
  Future<void> cacheNotes(final List<GardenNoteDTO> notes) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notesJsonString = jsonEncode(
        notes.map((note) => note.toJson()).toList(),
      );
      await prefs.setString(_storageKey, notesJsonString);
    } catch (e) {
      // Simple error handling for the MVP
      log('Error caching garden notes: $e');
      handleError(e, 'cacheNotes');
    }
  }

  @override
  Future<List<GardenNoteDTO>> getCachedNotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notesJsonString = prefs.getString(_storageKey);

      if (notesJsonString == null || notesJsonString.isEmpty) {
        return [];
      }

      final List<dynamic> notesJson = jsonDecode(notesJsonString) as List;
      return notesJson
          .map(
            (noteJson) =>
                GardenNoteDTO.fromJson(noteJson as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      // Simple error handling for the MVP
      log('Error retrieving cached garden notes: $e');
      handleError(e, 'getCachedNotes');
      return [];
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_storageKey);
    } catch (e) {
      // Simple error handling for the MVP
      log('Error clearing garden notes cache: $e');
      handleError(e, 'clearCache');
    }
  }

  @override
  void dispose() {
    // No resources to dispose in this implementation
  }

  @override
  Object handleError(final Object error, final String operation) {
    // Simple error handling for MVP
    print('GardenNoteCacheService error in $operation: $error');
    return error;
  }

  @override
  void log(final String message) {
    // Simple logging for MVP
    print('GardenNoteCacheService: $message');
  }
}
