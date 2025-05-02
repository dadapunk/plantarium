# Garden Notes Feature Documentation

## Overview

The Garden Notes feature provides a flexible and powerful way to document gardening activities, observations, and plans. It implements a dual-storage system:
- **SQLite Database**: For fast querying and app integration
- **Markdown Files**: For user accessibility and external editing

This approach combines the benefits of structured data storage with the flexibility of markdown files, allowing users to edit their notes both within the app and using external tools like Obsidian.

## Table of Contents

1. [Architecture](#architecture)
2. [Data Model](#data-model)
3. [API Endpoints](#api-endpoints)
4. [Service Interfaces](#service-interfaces)
5. [Dependency Injection](#dependency-injection)
6. [UI Components](#ui-components)
7. [File System Integration](#file-system-integration)
8. [Synchronization](#synchronization)
9. [Usage Examples](#usage-examples)
10. [Future Enhancements](#future-enhancements)

## Architecture

### Module Structure
```
frontend/lib/features/garden_notes/
├── data/
│   ├── models/
│   │   └── garden_note.dto.dart
│   ├── datasources/
│   │   ├── garden_notes_api.datasource.dart
│   │   └── garden_notes_local.datasource.dart
│   └── repositories/
│       └── garden_notes.repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── garden_note.entity.dart
│   └── repositories/
│       └── garden_notes.repository.dart
└── presentation/
    ├── providers/
    │   └── garden_notes_provider.dart
    └── screens/
        ├── garden_notes_list_screen.dart
        └── garden_note_detail_screen.dart
```

### Current Implementation
- **Database**: SQLite for structured storage via `sqflite_common_ffi`
- **State Management**: Provider pattern with `ChangeNotifier`
- **Service Architecture**: Interface-based with dependency injection
- **UI Components**: Reusable shared widgets

## Data Model

### Current Entity
```dart
class GardenNoteDTO {
  final int id;
  final String title;
  final String note;
  final DateTime date;
  
  GardenNoteDTO({
    required this.id,
    required this.title,
    required this.note,
    required this.date,
  });
  
  // Serialization methods...
}
```

### Planned Enhancements
```dart
class GardenNoteDTO {
  // ... existing fields ...
  
  final int? plantId;
  final int? plotId;
  final List<String>? tags;
  final String? weather;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // Constructor and serialization methods...
}
```

## API Endpoints

### Current Endpoints
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST   | `/garden-notes` | Create a new note |
| GET    | `/garden-notes` | List all notes |
| GET    | `/garden-notes/:id` | Get a specific note |
| PUT    | `/garden-notes/:id` | Update a note |
| DELETE | `/garden-notes/:id` | Delete a note |

### Planned Endpoints
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET    | `/garden-notes/search` | Search notes with filters |
| GET    | `/garden-notes/by-plant/:plantId` | Get notes for a specific plant |
| GET    | `/garden-notes/by-plot/:plotId` | Get notes for a specific plot |
| GET    | `/garden-notes/by-date-range` | Get notes within a date range |

## Service Interfaces

The Garden Notes feature uses a well-defined set of interfaces for service operations, following SOLID principles.

### Base Service
```dart
/// Base service interface that defines common functionality for all services
abstract class BaseService {
  /// Logs a message for debugging purposes
  void log(String message);

  /// Handles errors in a consistent way across services
  Object handleError(Object error, String operation);
}
```

### Garden Note Service Interface
```dart
/// Interface defining the contract for garden note operations
abstract class IGardenNoteService extends BaseService {
  /// Retrieves all garden notes
  Future<List<GardenNoteDTO>> getAllNotes();

  /// Retrieves a garden note by its ID
  Future<GardenNoteDTO> getNoteById(int id);

  /// Creates a new garden note
  Future<GardenNoteDTO> createNote(GardenNoteDTO note);

  /// Updates an existing garden note
  Future<GardenNoteDTO> updateNote(int id, GardenNoteDTO note);

  /// Deletes a garden note by its ID
  Future<void> deleteNote(int id);
}
```

### Garden Note Cache Service Interface
```dart
/// Interface defining the contract for garden note caching operations
abstract class IGardenNoteCacheService extends BaseService {
  /// Caches a list of garden notes locally
  Future<void> cacheNotes(List<GardenNoteDTO> notes);

  /// Retrieves all cached garden notes
  Future<List<GardenNoteDTO>> getCachedNotes();

  /// Clears all cached garden notes
  Future<void> clearCache();
}
```

### Generic Service Interfaces
These generic interfaces can be used for any entity type:

```dart
/// A generic interface for data services that handle CRUD operations
abstract class IDataService<T, ID> extends BaseService {
  /// Retrieves all entities
  Future<List<T>> getAll();

  /// Retrieves an entity by its ID
  Future<T> getById(ID id);

  /// Creates a new entity
  Future<T> create(T entity);

  /// Updates an existing entity
  Future<T> update(ID id, T entity);

  /// Deletes an entity by its ID
  Future<void> delete(ID id);
}

/// A generic interface for cache services
abstract class ICacheService<T> extends BaseService {
  /// Caches a list of entities
  Future<void> cacheItems(List<T> items);

  /// Retrieves all cached entities
  Future<List<T>> getCachedItems();

  /// Clears the cache
  Future<void> clearCache();

  /// Gets a single item from cache by ID
  Future<T?> getCachedItemById(dynamic id);

  /// Caches a single item
  Future<void> cacheItem(T item);

  /// Removes a single item from cache
  Future<void> removeCachedItem(dynamic id);
}
```

## Dependency Injection

The Garden Notes feature uses the `get_it` package for dependency injection, allowing for better testability and loose coupling.

### Service Locator
```dart
/// Global ServiceLocator instance
final sl = GetIt.instance;

/// Initialize the dependency injection container
Future<void> initializeDependencies() async {
  // Register App Config
  sl.registerSingleton<AppConfig>(AppConfig.current);

  // Register Dio
  sl.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: sl<AppConfig>().apiBaseUrl,
        connectTimeout: sl<AppConfig>().timeoutDuration,
        receiveTimeout: sl<AppConfig>().timeoutDuration,
      ),
    ),
  );

  // Register Services
  sl.registerLazySingleton<IGardenNoteService>(
    () => GardenNoteService(
        dio: sl<Dio>(), 
        baseUrl: sl<AppConfig>().apiBaseUrl
    ),
  );

  sl.registerLazySingleton<IGardenNoteCacheService>(
    () => GardenNoteCacheService(),
  );
}
```

### Provider Factory
```dart
/// Factory to create providers with dependencies injected
class ProvidersFactory {
  /// Create GardenNotesProvider with dependencies injected
  static GardenNotesProvider createGardenNotesProvider() {
    return GardenNotesProvider(
      sl<IGardenNoteService>(),
      sl<IGardenNoteCacheService>(),
    );
  }
}
```

## UI Components

The Garden Notes feature utilizes the shared widget library for consistent UI patterns.

### Loading Indicators
The feature uses standardized loading indicators from `AppLoadingIndicators`:

- **Standard Loading**: Used on the main notes list screen during data fetching
- **Inline Loading**: Used during specific operations like saving a note
- **Overlay Loading**: Used for potentially long operations
- **Shimmer Loading**: Used as placeholders during initial data loading

### Error Displays
Standardized error handling with `AppErrorDisplays`:

- **Standard Error**: Displayed on the main screen if loading fails
- **Inline Error**: Used for field-specific validation errors
- **Banner Error**: Shown for system-wide or connectivity issues

### Empty States
Various empty state displays using `AppEmptyStates`:

- **Standard Empty State**: Shown when there are no notes yet
- **Search Empty State**: Displayed when search returns no results

### Reusable Card Component
Notes are displayed using the standardized `AppCard` component:

```dart
AppCard(
  onTap: () => _navigateToEditScreen(context, note),
  title: note.title,
  actions: [
    DateDisplay(
      date: note.date,
      style: theme.textTheme.bodySmall?.copyWith(
        color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
      ),
    ),
  ],
  child: Text(
    note.note,
    style: theme.textTheme.bodyMedium,
    maxLines: 3,
    overflow: TextOverflow.ellipsis,
  ),
)
```

## File System Integration

### Current Implementation
- **Location**: `garden notes` directory
- **File Naming**: `<title>.md`
- **Content Format**:
  ```markdown
  # Title
  
  Note content
  ```

### Planned Enhancement
```markdown
---
date: 2024-05-01
tags: [planting, tomato]
plantId: 12
plotId: 3
weather: sunny
---

# Title

Note content
```

## Synchronization

### Current Implementation
- Uses `chokidar` for file system watching
- Automatic sync between files and database
- Basic error handling and logging

### Key Features
1. **File to Database Sync**
   - Watches for file changes
   - Updates corresponding database entries
   - Handles concurrent modifications

2. **Database to File Sync**
   - Creates/updates markdown files
   - Maintains consistent formatting
   - Preserves metadata

## Usage Examples

### Creating a Note via Provider
```dart
final provider = Provider.of<GardenNotesProvider>(context, listen: false);
final newNote = GardenNoteDTO(
  id: 0, // Will be replaced with actual ID after creation
  title: "First Tomato Planting",
  note: "Planted tomatoes in Bed 2. Weather was sunny.",
  date: DateTime.now(),
);
await provider.createNote(newNote);
```

### Loading Notes with Caching
```dart
@override
void initState() {
  super.initState();
  // The provider will load from cache first, then from network
  Provider.of<GardenNotesProvider>(context, listen: false).loadNotes();
}
```

### External Editing
1. Open the `garden notes` directory in your preferred markdown editor
2. Edit or create `.md` files
3. Changes are automatically synced to the database

## Environment Configuration

The Garden Notes feature uses environment-specific configuration from `.env` files loaded with `flutter_dotenv`:

```dart
// .env.development
API_BASE_URL=http://localhost:3002
ENABLE_LOGGING=true
TIMEOUT_DURATION=30
MAX_RETRIES=3

// .env.production
API_BASE_URL=https://api.plantarium.app
ENABLE_LOGGING=false
TIMEOUT_DURATION=20
MAX_RETRIES=1
```

This is accessed through the `AppConfig` class:

```dart
final apiUrl = AppConfig.current.apiBaseUrl;
final timeout = AppConfig.current.timeoutDuration;
```

## Future Enhancements

1. **Version Control**
   - Git integration for note history
   - Branch support for different garden seasons

2. **Advanced Search**
   - Full-text search in markdown content
   - Semantic search for plant-related content

3. **Media Support**
   - Image attachments
   - Plant growth progress photos

4. **Export/Import**
   - Bulk export to markdown
   - Import from other garden apps

5. **Collaboration**
   - Shared notes between users
   - Comment system

## Technical Considerations

### Performance
- Efficient file watching with `chokidar`
- Indexed database queries
- Caching for frequently accessed notes

### Security
- Input validation via DTOs
- File path sanitization
- Rate limiting for API endpoints

### Error Handling
- Graceful handling of file system errors
- Database transaction management
- Conflict resolution for concurrent edits

## Contributing

When contributing to the Garden Notes feature:
1. Follow the existing interface-based architecture
2. Use the dependency injection system for services
3. Utilize the shared widget library for UI components
4. Maintain backward compatibility
5. Add appropriate tests
6. Update documentation

## Support

For issues or questions:
1. Check the error logs in the application
2. Verify file system permissions
3. Ensure the database is properly initialized
4. Contact the development team for assistance 