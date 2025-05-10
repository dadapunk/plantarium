import 'package:plantarium/features/garden_notes/data/models/garden_note.dto.dart';
import 'package:plantarium/shared/services/base_service.dart';

/// Interface defining the contract for garden note caching operations
abstract class IGardenNoteCacheService extends BaseService {
  /// Caches a list of garden notes locally
  Future<void> cacheNotes(final List<GardenNoteDTO> notes);

  /// Retrieves all cached garden notes
  Future<List<GardenNoteDTO>> getCachedNotes();

  /// Clears all cached garden notes
  Future<void> clearCache();
}
