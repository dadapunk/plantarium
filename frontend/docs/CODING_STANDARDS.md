# Plantarium Frontend Coding Standards

This document outlines the coding standards and best practices for the Plantarium Flutter frontend application.

## Table of Contents
1. [Project Structure](#project-structure)
2. [Code Style](#code-style)
3. [State Management](#state-management)
4. [Error Handling](#error-handling)
5. [Testing](#testing)
6. [Documentation](#documentation)
7. [Performance](#performance)
8. [Security](#security)
9. [Git Workflow](#git-workflow)
10. [CI/CD Practices](#ci-cd-practices)
11. [Environment Management](#environment-management)

## Project Structure

### Directory Organization
```
lib/
├── core/                 # Core functionality and utilities
│   ├── constants/        # Application-wide constants
│   ├── errors/          # Error handling and custom exceptions
│   ├── network/         # Network related code (API client, interceptors)
│   ├── theme/           # Theme configuration
│   └── utils/           # Utility functions and extensions
├── features/            # Feature modules
│   ├── garden/          # Garden management feature
│   │   ├── data/        # Data layer
│   │   │   ├── datasources/
│   │   │   ├── models/  # Data models and DTOs
│   │   │   └── repositories/
│   │   ├── domain/      # Business logic layer
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/ # UI layer
│   │       ├── bloc/    # State management
│   │       ├── pages/   # Screen widgets
│   │       └── widgets/ # Reusable widgets
│   └── plant/           # Plant management feature
│       ├── data/
│       ├── domain/
│       └── presentation/
├── shared/              # Shared components
│   ├── widgets/         # Common widgets
│   └── services/        # Shared services
└── main.dart            # Application entry point
```

### File Organization
Each feature module should follow the Clean Architecture pattern:
- **Data Layer**: API integration, local storage, and data models
- **Domain Layer**: Business logic and use cases
- **Presentation Layer**: UI components and state management

### Naming Conventions
- **Files**: Use snake_case
  - Feature pages: `garden_list_page.dart`
  - Widgets: `plant_card_widget.dart`
  - Models: `garden_model.dart`
  - BLoCs: `garden_bloc.dart`

- **Classes**: Use PascalCase
  - Pages: `GardenListPage`
  - Widgets: `PlantCardWidget`
  - Models: `GardenModel`
  - BLoCs: `GardenBloc`

- **Variables and Methods**: Use camelCase
  - Variables: `final gardenList`
  - Methods: `void updatePlot()`
  - Private members: `final _repository`

- **Constants**: Use SCREAMING_SNAKE_CASE
  ```dart
  const String API_BASE_URL = 'https://api.plantarium.app';
  const int MAX_RETRY_ATTEMPTS = 3;
  ```

## Code Style

### General Rules
1. Use Dart 3.7.0 features and syntax
2. Follow Flutter's official style guide
3. Use meaningful names that describe purpose
4. Keep methods focused and under 20 lines
5. Use early returns to reduce nesting
6. Avoid abbreviations unless widely known

### Formatting
```dart
// GOOD
class GardenService {
  final PlotRepository _repository;
  final LocalStorage _storage;

  GardenService({
    required PlotRepository repository,
    required LocalStorage storage,
  })  : _repository = repository,
        _storage = storage;

  Future<void> updatePlot(Plot plot) async {
    try {
      await _repository.updatePlot(plot);
      await _storage.savePlot(plot);
    } catch (e) {
      throw GardenError('Failed to update plot: $e');
    }
  }
}

// BAD - Poor formatting and readability
class GardenService{final PlotRepository _repository;final LocalStorage _storage;
GardenService({required PlotRepository repository,required LocalStorage storage,}):_repository=repository,_storage=storage;
Future<void> updatePlot(Plot plot) async{try{await _repository.updatePlot(plot);await _storage.savePlot(plot);}catch(e){throw GardenError('Failed to update plot: $e');}}}
```

### Comments and Documentation
```dart
/// A service that manages garden-related operations.
///
/// This service coordinates between the repository and local storage
/// to ensure data consistency for garden operations.
class GardenService {
  // Private repository instance for data operations
  final PlotRepository _repository;
  
  /// Updates a plot in both remote and local storage.
  ///
  /// Throws a [GardenError] if the update fails.
  /// Parameters:
  ///   - plot: The [Plot] to update
  Future<void> updatePlot(Plot plot) async {
    // Implementation
  }
}
```

## State Management

### Riverpod Usage
```dart
// Provider definition
final gardenProvider = StateNotifierProvider<GardenNotifier, GardenState>((ref) {
  final repository = ref.watch(gardenRepositoryProvider);
  return GardenNotifier(repository);
});

// State notifier
class GardenNotifier extends StateNotifier<GardenState> {
  final GardenRepository _repository;

  GardenNotifier(this._repository) : super(const GardenState.initial());

  Future<void> loadGardens() async {
    state = const GardenState.loading();
    try {
      final gardens = await _repository.getGardens();
      state = GardenState.loaded(gardens);
    } catch (e) {
      state = GardenState.error(e.toString());
    }
  }
}

// Usage in widget
class GardenList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gardenState = ref.watch(gardenProvider);
    
    return gardenState.when(
      initial: () => const SizedBox.shrink(),
      loading: () => const CircularProgressIndicator(),
      loaded: (gardens) => ListView.builder(
        itemCount: gardens.length,
        itemBuilder: (context, index) => GardenCard(garden: gardens[index]),
      ),
      error: (message) => ErrorDisplay(message: message),
    );
  }
}
```

### State Organization
- Use freezed for immutable state classes
- Keep state classes simple and focused
- Use sealed classes for state variants
- Handle loading and error states consistently

## Error Handling

### Exception Hierarchy
```dart
/// Base exception class for the application
abstract class AppException implements Exception {
  final String message;
  final dynamic error;

  const AppException(this.message, [this.error]);
}

/// Network-related exceptions
class NetworkException extends AppException {
  final int? statusCode;

  const NetworkException(
    String message, {
    this.statusCode,
    dynamic error,
  }) : super(message, error);
}

/// Data-related exceptions
class DataException extends AppException {
  const DataException(String message, [dynamic error]) : super(message, error);
}
```

### Error Handling Strategy
1. Use typed exceptions for different error cases
2. Handle errors at appropriate levels
3. Provide user-friendly error messages
4. Log errors appropriately
5. Implement proper error recovery

## Testing

### Unit Tests
```dart
void main() {
  group('GardenRepository', () {
    late GardenRepository repository;
    late MockApiClient mockApiClient;
    late MockLocalStorage mockLocalStorage;

    setUp(() {
      mockApiClient = MockApiClient();
      mockLocalStorage = MockLocalStorage();
      repository = GardenRepository(mockApiClient, mockLocalStorage);
    });

    test('getGardens returns cached data when offline', () async {
      when(mockApiClient.getGardens()).thenThrow(NetworkException('Offline'));
      when(mockLocalStorage.getGardens())
          .thenAnswer((_) async => [Garden(id: '1', name: 'Test')]);

      final result = await repository.getGardens();

      expect(result.length, equals(1));
      verify(mockLocalStorage.getGardens()).called(1);
    });
  });
}
```

### Widget Tests
```dart
void main() {
  group('GardenList', () {
    testWidgets('shows error message on failure', (tester) async {
      final container = ProviderContainer(
        overrides: [
          gardenProvider.overrideWith(
            (ref) => GardenNotifier(MockRepository())..loadGardens(),
          ),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: GardenList()),
        ),
      );

      expect(find.byType(ErrorDisplay), findsOneWidget);
    });
  });
}
```

### Integration Tests
```dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-end test', () {
    testWidgets('Create and view garden flow', (tester) async {
      await tester.pumpWidget(const PlantariumApp());

      // Test user flow
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextFormField).first,
        'Test Garden',
      );
      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();

      expect(find.text('Test Garden'), findsOneWidget);
    });
  });
}
```

## Performance

### Best Practices
1. Use const constructors where possible
2. Implement proper list view optimization
3. Cache network resources appropriately
4. Minimize rebuilds using selective updates
5. Use appropriate image formats and sizes

### Memory Management
```dart
class _GardenListState extends State<GardenList> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.gardens.length,
      itemBuilder: (context, index) {
        final garden = widget.gardens[index];
        return GardenCard(
          key: ValueKey(garden.id),
          garden: garden,
        );
      },
    );
  }
}
```

## Security

### Best Practices
1. Use HTTPS for all network calls
2. Implement proper input validation
3. Sanitize data before display
4. Use secure storage for sensitive data
5. Follow platform security guidelines

### Input Validation
```dart
class GardenForm {
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Garden name is required';
    }
    if (value.length < 3) {
      return 'Name must be at least 3 characters';
    }
    if (value.length > 50) {
      return 'Name must be less than 50 characters';
    }
    return null;
  }

  String? validateArea(String? value) {
    if (value == null || value.isEmpty) {
      return 'Area is required';
    }
    final number = double.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number';
    }
    if (number <= 0) {
      return 'Area must be greater than 0';
    }
    return null;
  }
}
```

## Git Workflow

### Branch Naming
- Feature branches: `feature/add-garden-form`
- Bug fixes: `fix/garden-list-crash`
- Releases: `release/1.0.0`
- Hotfixes: `hotfix/critical-auth-fix`

### Commit Messages
```
feat(garden): add garden creation form
^    ^        ^
|    |        |
|    |        +-> Summary in present tense
|    +----------> Scope
+---------------> Type: feat, fix, docs, style, refactor, test, chore
```

### Pull Request Guidelines
1. Keep PRs focused and small
2. Include clear descriptions
3. Add relevant tests
4. Update documentation
5. Link related issues

## CI/CD Practices

### Build Process
- Use environment-specific configurations
- Run tests before builds
- Generate build artifacts
- Create deployment packages

### Deployment Strategy
- Use staged deployments (dev → staging → prod)
- Implement feature flags
- Monitor deployment health
- Plan rollback procedures

## Environment Management

### Configuration
```dart
/// Environment-specific configuration
class AppConfig {
  final String apiBaseUrl;
  final bool enableLogging;
  final Duration timeoutDuration;

  const AppConfig({
    required this.apiBaseUrl,
    required this.enableLogging,
    required this.timeoutDuration,
  });

  /// Development configuration
  factory AppConfig.development() => const AppConfig(
        apiBaseUrl: 'http://localhost:3000',
        enableLogging: true,
        timeoutDuration: Duration(seconds: 30),
      );

  /// Production configuration
  factory AppConfig.production() => const AppConfig(
        apiBaseUrl: 'https://api.plantarium.app',
        enableLogging: false,
        timeoutDuration: Duration(seconds: 20),
      );
}
```

### Environment Setup
1. Use `.env` files for environment variables
2. Keep sensitive data out of version control
3. Document environment setup requirements
4. Provide example configuration files 