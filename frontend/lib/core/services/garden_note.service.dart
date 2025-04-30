import 'package:dio/dio.dart';
import 'package:plantarium/core/models/garden/garden_note.dto.dart';

class GardenNoteService {
  final Dio _dio;
  final String _baseUrl;

  GardenNoteService({required Dio dio, required String baseUrl})
    : _dio = dio,
      _baseUrl = baseUrl;

  // Get all garden notes
  Future<List<GardenNoteDTO>> getAllNotes() async {
    try {
      final response = await _dio.get('$_baseUrl/garden-notes');
      return (response.data as List)
          .map((json) => GardenNoteDTO.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch garden notes: $e');
    }
  }

  // Get a single garden note by ID
  Future<GardenNoteDTO> getNoteById(int id) async {
    try {
      final response = await _dio.get('$_baseUrl/garden-notes/$id');
      return GardenNoteDTO.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to fetch garden note: $e');
    }
  }

  // Create a new garden note
  Future<GardenNoteDTO> createNote(GardenNoteDTO note) async {
    try {
      print('Creating note with data: ${note.toJson()}');
      final response = await _dio.post(
        '$_baseUrl/garden-notes',
        data: note.toJson(),
      );
      print('Response data: ${response.data}');
      return GardenNoteDTO.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      if (e is DioError) {
        print('DioError: ${e.response?.statusCode} - ${e.response?.data}');
        if (e.response?.statusCode == 500) {
          throw Exception(
            'Server error: The note could not be created. Please check your input or try again later.',
          );
        }
      }
      throw Exception('Failed to create garden note: $e');
    }
  }

  // Update an existing garden note
  Future<GardenNoteDTO> updateNote(int id, GardenNoteDTO note) async {
    try {
      print('Updating note with id: $id, data: ${note.toJson()}');
      // Create a copy with the ID explicitly included
      final noteWithId = note.copyWith();
      final dataToSend = {...noteWithId.toJson(), 'id': id};
      print('Data being sent: $dataToSend');

      final response = await _dio.put(
        '$_baseUrl/garden-notes/$id',
        data: dataToSend,
      );
      print('Response data: ${response.data}');
      return GardenNoteDTO.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      if (e is DioError) {
        print('DioError: ${e.response?.statusCode} - ${e.response?.data}');
        if (e.response?.statusCode == 500) {
          throw Exception(
            'Server error: The note could not be updated. Please check your input or try again later.',
          );
        }
      }
      throw Exception('Failed to update garden note: $e');
    }
  }

  // Delete a garden note
  Future<void> deleteNote(int id) async {
    try {
      await _dio.delete('$_baseUrl/garden-notes/$id');
    } catch (e) {
      throw Exception('Failed to delete garden note: $e');
    }
  }
}
