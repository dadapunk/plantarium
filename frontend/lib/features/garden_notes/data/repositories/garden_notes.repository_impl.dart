import 'package:plantarium/features/garden_notes/data/datasources/garden_notes_api.datasource.dart';
import 'package:plantarium/features/garden_notes/data/datasources/garden_notes_local.datasource.dart';
import 'package:plantarium/features/garden_notes/data/models/garden_note_mapper.dart';
import 'package:plantarium/features/garden_notes/domain/entities/garden_note.entity.dart';
import 'package:plantarium/features/garden_notes/domain/repositories/garden_notes.repository.dart';

/// Implementation of the garden notes repository
class GardenNotesRepositoryImpl implements GardenNotesRepository {
  final GardenNotesApiDatasource _apiDatasource;
  final GardenNotesLocalDatasource _localDatasource;

  /// Creates a new repository implementation with the given datasources
  GardenNotesRepositoryImpl({
    required GardenNotesApiDatasource apiDatasource,
    required GardenNotesLocalDatasource localDatasource,
  }) : _apiDatasource = apiDatasource,
       _localDatasource = localDatasource;

  @override
  Future<List<GardenNote>> getAllNotes() async {
    try {
      // Try to get notes from API
      final dtoList = await _apiDatasource.getAllNotes();

      // Cache the notes
      await _localDatasource.cacheNotes(dtoList);

      // Convert and return as entities
      return GardenNoteMapper.toEntityList(dtoList);
    } catch (e) {
      // If API call fails, try to get from cache
      final cachedDtoList = await _localDatasource.getCachedNotes();
      return GardenNoteMapper.toEntityList(cachedDtoList);
    }
  }

  @override
  Future<GardenNote> getNoteById(int id) async {
    try {
      // Try to get note from API
      final dto = await _apiDatasource.getNoteById(id);
      return GardenNoteMapper.toEntity(dto);
    } catch (e) {
      // If API call fails, try to get from cache
      final cachedDtoList = await _localDatasource.getCachedNotes();
      final cachedDto = cachedDtoList.firstWhere(
        (note) => note.id == id,
        orElse: () => throw Exception('Note not found'),
      );
      return GardenNoteMapper.toEntity(cachedDto);
    }
  }

  @override
  Future<GardenNote> createNote(GardenNote note) async {
    // Convert entity to DTO
    final dto = GardenNoteMapper.fromEntity(note);

    // Create note via API
    final createdDto = await _apiDatasource.createNote(dto);

    // Update cache
    final cachedDtoList = await _localDatasource.getCachedNotes();
    await _localDatasource.cacheNotes([...cachedDtoList, createdDto]);

    // Convert and return as entity
    return GardenNoteMapper.toEntity(createdDto);
  }

  @override
  Future<GardenNote> updateNote(GardenNote note) async {
    if (note.id == null) {
      throw ArgumentError('Note ID cannot be null for update operation');
    }

    // Convert entity to DTO
    final dto = GardenNoteMapper.fromEntity(note);

    // Update note via API
    final updatedDto = await _apiDatasource.updateNote(note.id!, dto);

    // Update cache
    final cachedDtoList = await _localDatasource.getCachedNotes();
    final updatedList =
        cachedDtoList
            .map(
              (cachedDto) =>
                  cachedDto.id == updatedDto.id ? updatedDto : cachedDto,
            )
            .toList();
    await _localDatasource.cacheNotes(updatedList);

    // Convert and return as entity
    return GardenNoteMapper.toEntity(updatedDto);
  }

  @override
  Future<void> deleteNote(int id) async {
    // Delete note via API
    await _apiDatasource.deleteNote(id);

    // Update cache
    final cachedDtoList = await _localDatasource.getCachedNotes();
    final updatedList = cachedDtoList.where((note) => note.id != id).toList();
    await _localDatasource.cacheNotes(updatedList);
  }
}
