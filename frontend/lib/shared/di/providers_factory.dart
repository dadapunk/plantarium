import 'package:plantarium/features/garden_notes/presentation/providers/garden_notes_provider.dart';
import 'package:plantarium/shared/di/service_locator.dart';
import 'package:plantarium/shared/services/garden_note_service_interface.dart';
import 'package:plantarium/shared/services/garden_note_cache_service_interface.dart';

/// Factory to create providers with dependencies injected
class ProvidersFactory {
  /// Create GardenNotesProvider with dependencies injected
  static GardenNotesProvider createGardenNotesProvider() => GardenNotesProvider(
    sl<IGardenNoteService>(),
    sl<IGardenNoteCacheService>(),
  );
}
