import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:plantarium/features/garden_notes/data/models/garden_note.dto.dart';

/// Abstract class defining the API datasource interface for Garden Notes
abstract class GardenNotesApiDatasource {
  /// Get all garden notes from the API
  Future<List<GardenNoteDTO>> getAllNotes();

  /// Get a single garden note by ID
  Future<GardenNoteDTO> getNoteById(int id);

  /// Create a new garden note
  Future<GardenNoteDTO> createNote(GardenNoteDTO note);

  /// Update an existing garden note
  Future<GardenNoteDTO> updateNote(int id, GardenNoteDTO note);

  /// Delete a garden note
  Future<void> deleteNote(int id);
}

/// Implementation of the Garden Notes API datasource
class GardenNotesApiDatasourceImpl implements GardenNotesApiDatasource {
  final Dio _dio;
  final String _baseUrl;

  /// Create a new instance of the API datasource
  GardenNotesApiDatasourceImpl({required Dio dio, required String baseUrl})
    : _dio = dio,
      _baseUrl = baseUrl;

  void _log(String message) {
    if (kDebugMode) {
      print('GardenNotesApiDatasource: $message');
    }
  }

  @override
  Future<List<GardenNoteDTO>> getAllNotes() async {
    _log('Fetching all garden notes from $_baseUrl/garden-notes');
    try {
      final response = await _dio.get('$_baseUrl/garden-notes');
      final notes =
          (response.data as List)
              .map(
                (json) => GardenNoteDTO.fromJson(json as Map<String, dynamic>),
              )
              .toList();
      _log('Successfully fetched ${notes.length} garden notes');
      return notes;
    } catch (e) {
      _log('Error fetching garden notes: $e');
      if (e is DioError) {
        _log(
          'DioError details: ${e.response?.statusCode} - ${e.response?.data}',
        );
        _log('Request: ${e.requestOptions.uri}');
      }
      throw Exception('Failed to fetch garden notes: $e');
    }
  }

  @override
  Future<GardenNoteDTO> getNoteById(int id) async {
    _log('Fetching garden note with ID: $id');
    try {
      final response = await _dio.get('$_baseUrl/garden-notes/$id');
      final note = GardenNoteDTO.fromJson(
        response.data as Map<String, dynamic>,
      );
      _log('Successfully fetched note: ${note.title} (ID: $id)');
      return note;
    } catch (e) {
      _log('Error fetching garden note with ID $id: $e');
      if (e is DioError) {
        _log(
          'DioError details: ${e.response?.statusCode} - ${e.response?.data}',
        );
        _log('Request: ${e.requestOptions.uri}');
      }
      throw Exception('Failed to fetch garden note: $e');
    }
  }

  @override
  Future<GardenNoteDTO> createNote(GardenNoteDTO note) async {
    _log('Creating new garden note with title: "${note.title}"');
    _log('Request data: ${note.toJson()}');

    try {
      _log('Sending POST request to $_baseUrl/garden-notes');
      final response = await _dio.post(
        '$_baseUrl/garden-notes',
        data: note.toJson(),
      );

      _log('API response status: ${response.statusCode}');
      _log('Response data: ${response.data}');

      final createdNote = GardenNoteDTO.fromJson(
        response.data as Map<String, dynamic>,
      );
      _log('Successfully created note with ID: ${createdNote.id}');

      return createdNote;
    } catch (e) {
      _log('Error creating garden note: $e');

      if (e is DioError) {
        _log(
          'DioError details: ${e.response?.statusCode} - ${e.response?.data}',
        );
        _log('Request URL: ${e.requestOptions.uri}');
        _log('Request data: ${e.requestOptions.data}');

        if (e.response?.statusCode == 500) {
          throw Exception(
            'Server error: The note could not be created. Please check your input or try again later.',
          );
        }
      }

      throw Exception('Failed to create garden note: $e');
    }
  }

  @override
  Future<GardenNoteDTO> updateNote(int id, GardenNoteDTO note) async {
    _log('Updating garden note with ID: $id');
    _log('Title: "${note.title}"');
    _log(
      'Content (first 50 chars): "${note.note.substring(0, note.note.length > 50 ? 50 : note.note.length)}..."',
    );
    _log('Content length: ${note.note.length} chars');

    try {
      // Create a copy with the ID explicitly included
      final noteWithId = note.copyWith();
      final dataToSend = {...noteWithId.toJson(), 'id': id};
      _log('Full data being sent to server: $dataToSend');

      _log('Sending PUT request to $_baseUrl/garden-notes/$id');
      final response = await _dio.put(
        '$_baseUrl/garden-notes/$id',
        data: dataToSend,
      );

      _log('API response status: ${response.statusCode}');
      _log('Response data from server: ${response.data}');

      final updatedNote = GardenNoteDTO.fromJson(
        response.data as Map<String, dynamic>,
      );
      _log('Successfully updated note: "${updatedNote.title}" (ID: $id)');
      _log(
        'Returned content (first 50 chars): "${updatedNote.note.substring(0, updatedNote.note.length > 50 ? 50 : updatedNote.note.length)}..."',
      );

      return updatedNote;
    } catch (e) {
      _log('Error updating garden note with ID $id: $e');

      if (e is DioError) {
        _log(
          'DioError details: ${e.response?.statusCode} - ${e.response?.data}',
        );
        _log('Request URL: ${e.requestOptions.uri}');
        _log('Request data: ${e.requestOptions.data}');

        if (e.response?.statusCode == 500) {
          throw Exception(
            'Server error: The note could not be updated. Please check your input or try again later.',
          );
        }
      }

      throw Exception('Failed to update garden note: $e');
    }
  }

  @override
  Future<void> deleteNote(int id) async {
    _log('Deleting garden note with ID: $id');

    try {
      _log('Sending DELETE request to $_baseUrl/garden-notes/$id');
      final response = await _dio.delete('$_baseUrl/garden-notes/$id');
      _log('Delete response status: ${response.statusCode}');
      _log('Successfully deleted note with ID: $id');
    } catch (e) {
      _log('Error deleting garden note with ID $id: $e');

      if (e is DioError) {
        _log(
          'DioError details: ${e.response?.statusCode} - ${e.response?.data}',
        );
        _log('Request URL: ${e.requestOptions.uri}');
      }

      throw Exception('Failed to delete garden note: $e');
    }
  }
}
