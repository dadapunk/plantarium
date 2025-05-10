import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:plantarium/features/garden_notes/data/models/garden_note.dto.dart';
import 'package:plantarium/core/network/models/api_response.dart';

part 'garden_notes_api_client.g.dart';

/// A Retrofit-based API client for garden notes.
///
/// This client provides typed methods for interacting with the garden notes API.
@RestApi()
abstract class GardenNotesApiClient {
  /// Creates a new instance of the garden notes API client.
  ///
  /// [dio] The Dio HTTP client to use for making requests.
  /// [baseUrl] The base URL for all API requests.
  factory GardenNotesApiClient(final Dio dio, {final String baseUrl}) =
      _GardenNotesApiClient;

  /// Creates a new instance with the specified [dio] client and [baseUrl].
  static GardenNotesApiClient create({
    required final Dio dio,
    required final String baseUrl,
  }) => GardenNotesApiClient(dio, baseUrl: baseUrl);

  /// Gets all garden notes.
  @GET('/garden-notes')
  Future<ApiResponse<List<GardenNoteDTO>>> getAllNotes();

  /// Gets a single garden note by ID.
  @GET('/garden-notes/{id}')
  Future<ApiResponse<GardenNoteDTO>> getNoteById(@Path('id') final int id);

  /// Creates a new garden note.
  @POST('/garden-notes')
  Future<ApiResponse<GardenNoteDTO>> createNote(
    @Body() final GardenNoteDTO note,
  );

  /// Updates an existing garden note.
  @PUT('/garden-notes/{id}')
  Future<ApiResponse<GardenNoteDTO>> updateNote(
    @Path('id') final int id,
    @Body() final GardenNoteDTO note,
  );

  /// Deletes a garden note.
  @DELETE('/garden-notes/{id}')
  Future<ApiResponse<dynamic>> deleteNote(@Path('id') final int id);
}
