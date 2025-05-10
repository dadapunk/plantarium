import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:plantarium/features/garden_notes/data/models/garden_note.dto.dart';
import 'package:plantarium/shared/services/garden_note_service_interface.dart';

class GardenNoteService implements IGardenNoteService {
  GardenNoteService({required Dio dio, required String baseUrl})
    : _dio = dio,
      _baseUrl = baseUrl;
  final Dio _dio;
  final String _baseUrl;

  @override
  void log(final String message) {
    if (kDebugMode) {
      print('GardenNoteService: $message');
    }
  }

  @override
  Object handleError(final Object error, final String operation) {
    log('Error $operation: $error');

    if (error is DioException) {
      log(
        'DioError details: ${error.response?.statusCode} - ${error.response?.data}',
      );
      log('Request: ${error.requestOptions.uri}');

      if (error.response?.statusCode == 500) {
        return Exception(
          'Server error: The operation could not be completed. Please try again later.',
        );
      }
    }

    return Exception('Failed to $operation: $error');
  }

  // Get all garden notes
  @override
  Future<List<GardenNoteDTO>> getAllNotes() async {
    log('Fetching all garden notes from $_baseUrl/garden-notes');
    try {
      final response = await _dio.get('$_baseUrl/garden-notes');
      final notes =
          (response.data as List)
              .map(
                (final json) =>
                    GardenNoteDTO.fromJson(json as Map<String, dynamic>),
              )
              .toList();
      log('Successfully fetched ${notes.length} garden notes');
      return notes;
    } catch (e) {
      throw handleError(e, 'fetching garden notes');
    }
  }

  // Get a single garden note by ID
  @override
  Future<GardenNoteDTO> getNoteById(final int id) async {
    log('Fetching garden note with ID: $id');
    try {
      final response = await _dio.get('$_baseUrl/garden-notes/$id');
      final note = GardenNoteDTO.fromJson(
        response.data as Map<String, dynamic>,
      );
      log('Successfully fetched note: ${note.title} (ID: $id)');
      return note;
    } catch (e) {
      throw handleError(e, 'fetching garden note with ID $id');
    }
  }

  // Create a new garden note
  @override
  Future<GardenNoteDTO> createNote(final GardenNoteDTO note) async {
    log('Creating new garden note with title: "${note.title}"');
    log('Request data: ${note.toJson()}');

    try {
      log('Sending POST request to $_baseUrl/garden-notes');
      final response = await _dio.post(
        '$_baseUrl/garden-notes',
        data: note.toJson(),
      );

      log('API response status: ${response.statusCode}');
      log('Response data: ${response.data}');

      final createdNote = GardenNoteDTO.fromJson(
        response.data as Map<String, dynamic>,
      );
      log('Successfully created note with ID: ${createdNote.id}');

      return createdNote;
    } catch (e) {
      throw handleError(e, 'creating garden note');
    }
  }

  // Update an existing garden note
  @override
  Future<GardenNoteDTO> updateNote(
    final int id,
    final GardenNoteDTO note,
  ) async {
    log('Updating garden note with ID: $id');
    log('Title: "${note.title}", Content length: ${note.note.length} chars');

    try {
      // Create a copy with the ID explicitly included
      final noteWithId = note.copyWith();
      final dataToSend = {...noteWithId.toJson(), 'id': id};
      log('Full data being sent: $dataToSend');

      log('Sending PUT request to $_baseUrl/garden-notes/$id');
      final response = await _dio.put(
        '$_baseUrl/garden-notes/$id',
        data: dataToSend,
      );

      log('API response status: ${response.statusCode}');
      log('Response data: ${response.data}');

      final updatedNote = GardenNoteDTO.fromJson(
        response.data as Map<String, dynamic>,
      );
      log('Successfully updated note: "${updatedNote.title}" (ID: $id)');

      return updatedNote;
    } catch (e) {
      throw handleError(e, 'updating garden note with ID $id');
    }
  }

  // Delete a garden note
  @override
  Future<void> deleteNote(final int id) async {
    log('Deleting garden note with ID: $id');

    try {
      log('Sending DELETE request to $_baseUrl/garden-notes/$id');
      final response = await _dio.delete('$_baseUrl/garden-notes/$id');
      log('Delete response status: ${response.statusCode}');
      log('Successfully deleted note with ID: $id');
    } catch (e) {
      throw handleError(e, 'deleting garden note with ID $id');
    }
  }
}
