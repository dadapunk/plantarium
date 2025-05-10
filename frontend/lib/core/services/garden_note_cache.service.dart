import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:plantarium/features/garden_notes/data/models/garden_note.dto.dart';
import 'package:plantarium/shared/services/garden_note_cache_service_interface.dart';

/// A simplified garden note cache service using SharedPreferences for the MVP
class GardenNoteCacheService implements IGardenNoteCacheService {
  static const String _cacheKey = 'garden_notes_cache';

  /// Logs a message to the console in debug mode
  @override
  void log(final String message) {
    if (kDebugMode) {
      print('🗃️ GardenNoteCacheService: $message');
    }
  }

  /// Handles errors in a consistent way
  @override
  Object handleError(final Object error, final String operation) {
    log('Error $operation: $error');
    return Exception('Failed to $operation: $error');
  }

  /// Caches a list of garden notes using SharedPreferences
  @override
  Future<void> cacheNotes(final List<GardenNoteDTO> notes) async {
    log('Caching ${notes.length} garden notes');
    try {
      final prefs = await SharedPreferences.getInstance();

      // Convert notes to JSON string
      final List<Map<String, dynamic>> jsonList =
          notes
              .map(
                (note) => {
                  'id': note.id,
                  'title': note.title,
                  'note': note.note,
                  'date': note.date.toIso8601String(),
                },
              )
              .toList();

      // Store in shared preferences
      await prefs.setString(_cacheKey, jsonEncode(jsonList));

      log('Successfully cached ${notes.length} garden notes');
    } catch (e) {
      throw handleError(e, 'cache garden notes');
    }
  }

  /// Retrieves cached garden notes from SharedPreferences
  @override
  Future<List<GardenNoteDTO>> getCachedNotes() async {
    log('Retrieving cached garden notes');
    try {
      final prefs = await SharedPreferences.getInstance();

      // Get cached JSON string
      final jsonString = prefs.getString(_cacheKey);
      if (jsonString == null) {
        log('No cached garden notes found');
        return [];
      }

      // Parse JSON and convert to DTOs
      final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
      final notes =
          jsonList
              .map(
                (json) => GardenNoteDTO(
                  id: json['id'] as int,
                  title: json['title'] as String,
                  note: json['note'] as String,
                  date: DateTime.parse(json['date'] as String),
                ),
              )
              .toList();

      log('Retrieved ${notes.length} cached garden notes');
      return notes;
    } catch (e) {
      log('Error retrieving cached notes: $e');
      // On error, return empty list instead of throwing to improve resilience
      return [];
    }
  }

  /// Clears the cached garden notes
  @override
  Future<void> clearCache() async {
    log('Clearing garden notes cache');
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cacheKey);
      log('Garden notes cache cleared successfully');
    } catch (e) {
      throw handleError(e, 'clear garden notes cache');
    }
  }
}
