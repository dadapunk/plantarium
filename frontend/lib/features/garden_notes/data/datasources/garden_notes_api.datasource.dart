import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:plantarium/core/errors/app_exception.dart';
import 'package:plantarium/core/network/models/api_response.dart';
import 'package:plantarium/features/garden_notes/data/datasources/garden_notes_api_client.dart';
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

/// Implementation of the Garden Notes API datasource using Retrofit
class RetrofitGardenNotesApiDatasource implements GardenNotesApiDatasource {
  final GardenNotesApiClient _apiClient;

  /// Create a new instance of the API datasource with Retrofit
  RetrofitGardenNotesApiDatasource({required GardenNotesApiClient apiClient})
    : _apiClient = apiClient;

  /// Factory constructor to create an instance with Dio and baseUrl
  factory RetrofitGardenNotesApiDatasource.create({
    required Dio dio,
    required String baseUrl,
  }) {
    final apiClient = GardenNotesApiClient.create(dio: dio, baseUrl: baseUrl);
    return RetrofitGardenNotesApiDatasource(apiClient: apiClient);
  }

  void _log(String message) {
    if (kDebugMode) {
      print('GardenNotesApiDatasource: $message');
    }
  }

  @override
  Future<List<GardenNoteDTO>> getAllNotes() async {
    _log('Fetching all garden notes');
    try {
      final response = await _apiClient.getAllNotes();
      if (!response.success || response.data == null) {
        throw ApiException(
          message: response.message,
          errorCode: response.errorCode,
        );
      }
      _log('Successfully fetched ${response.data!.length} garden notes');
      return response.data!;
    } catch (e) {
      _log('Error fetching garden notes: $e');
      throw ApiException(
        message: 'Failed to fetch garden notes: $e',
        errorCode: 'FETCH_NOTES_ERROR',
      );
    }
  }

  @override
  Future<GardenNoteDTO> getNoteById(int id) async {
    _log('Fetching garden note with ID: $id');
    try {
      final response = await _apiClient.getNoteById(id);
      if (!response.success || response.data == null) {
        throw ApiException(
          message: response.message,
          errorCode: response.errorCode,
        );
      }
      _log('Successfully fetched note: ${response.data!.title} (ID: $id)');
      return response.data!;
    } catch (e) {
      _log('Error fetching garden note with ID $id: $e');
      throw ApiException(
        message: 'Failed to fetch garden note: $e',
        errorCode: 'FETCH_NOTE_ERROR',
      );
    }
  }

  @override
  Future<GardenNoteDTO> createNote(GardenNoteDTO note) async {
    _log('Creating new garden note with title: "${note.title}"');
    try {
      final response = await _apiClient.createNote(note);
      if (!response.success || response.data == null) {
        throw ApiException(
          message: response.message,
          errorCode: response.errorCode,
        );
      }
      _log(
        'Successfully created note: ${response.data!.title} (ID: ${response.data!.id})',
      );
      return response.data!;
    } catch (e) {
      _log('Error creating garden note: $e');
      throw ApiException(
        message: 'Failed to create garden note: $e',
        errorCode: 'CREATE_NOTE_ERROR',
      );
    }
  }

  @override
  Future<GardenNoteDTO> updateNote(int id, GardenNoteDTO note) async {
    _log('Updating garden note with ID: $id');
    try {
      final response = await _apiClient.updateNote(id, note);
      if (!response.success || response.data == null) {
        throw ApiException(
          message: response.message,
          errorCode: response.errorCode,
        );
      }
      _log('Successfully updated note: ${response.data!.title} (ID: $id)');
      return response.data!;
    } catch (e) {
      _log('Error updating garden note with ID $id: $e');
      throw ApiException(
        message: 'Failed to update garden note: $e',
        errorCode: 'UPDATE_NOTE_ERROR',
      );
    }
  }

  @override
  Future<void> deleteNote(int id) async {
    _log('Deleting garden note with ID: $id');
    try {
      final response = await _apiClient.deleteNote(id);
      if (!response.success) {
        throw ApiException(
          message: response.message,
          errorCode: response.errorCode,
        );
      }
      _log('Successfully deleted note with ID: $id');
    } catch (e) {
      _log('Error deleting garden note with ID $id: $e');
      throw ApiException(
        message: 'Failed to delete garden note: $e',
        errorCode: 'DELETE_NOTE_ERROR',
      );
    }
  }
}

/// Legacy implementation of the Garden Notes API datasource using Dio directly
/// This will be deprecated once the Retrofit implementation is fully tested
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
      final createdNote = GardenNoteDTO.fromJson(
        response.data as Map<String, dynamic>,
      );
      _log(
        'Successfully created note: ${createdNote.title} (ID: ${createdNote.id})',
      );
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
    _log('Update data: ${note.toJson()}');

    try {
      _log('Sending PUT request to $_baseUrl/garden-notes/$id');
      final response = await _dio.put(
        '$_baseUrl/garden-notes/$id',
        data: note.toJson(),
      );
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
