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

## Project Structure

### Directory Organization
```
lib/
├── core/
│   ├── constants/
│   ├── errors/
│   ├── network/
│   ├── theme/
│   └── utils/
├── features/
│   ├── garden/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── bloc/
│   │       ├── pages/
│   │       └── widgets/
│   └── plant/
│       ├── data/
│       ├── domain/
│       └── presentation/
├── shared/
│   ├── widgets/
│   └── services/
└── main.dart
```

### Naming Conventions
- **Files**: Use snake_case for file names
  - `garden_list_page.dart`
  - `plant_details_widget.dart`
  - `plot_repository_impl.dart`

- **Directories**: Use snake_case for directory names
  - `data_sources`
  - `use_cases`
  - `presentation`

- **Classes**: Use PascalCase for class names
  - `GardenListPage`
  - `PlantDetailsWidget`
  - `PlotRepositoryImpl`

- **Variables and Methods**: Use camelCase
  - `final gardenList`
  - `void updatePlot()`

## Code Style

### General Rules
1. Use Dart 3.7.0 features and syntax
2. Follow Flutter's official style guide
3. Use meaningful names for variables and methods
4. Keep methods short and focused (max 20 lines)
5. Use comments to explain complex logic
6. Avoid magic numbers and strings

### Formatting
```dart
// Good
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

// Bad
class GardenService{final PlotRepository _repository;final LocalStorage _storage;
GardenService({required PlotRepository repository,required LocalStorage storage,}):_repository=repository,_storage=storage;
Future<void> updatePlot(Plot plot) async{try{await _repository.updatePlot(plot);await _storage.savePlot(plot);}catch(e){throw GardenError('Failed to update plot: $e');}}}
```

## State Management

### Bloc Pattern
```dart
// Events
abstract class PlotEvent {}
class LoadPlots extends PlotEvent {}
class UpdatePlot extends PlotEvent {
  final Plot plot;
  UpdatePlot(this.plot);
}

// States
abstract class PlotState {}
class PlotInitial extends PlotState {}
class PlotLoading extends PlotState {}
class PlotLoaded extends PlotState {
  final List<Plot> plots;
  PlotLoaded(this.plots);
}
class PlotError extends PlotState {
  final String message;
  PlotError(this.message);
}

// Bloc
class PlotBloc extends Bloc<PlotEvent, PlotState> {
  final PlotRepository _repository;

  PlotBloc(this._repository) : super(PlotInitial()) {
    on<LoadPlots>(_onLoadPlots);
    on<UpdatePlot>(_onUpdatePlot);
  }

  Future<void> _onLoadPlots(LoadPlots event, Emitter<PlotState> emit) async {
    emit(PlotLoading());
    try {
      final plots = await _repository.getPlots();
      emit(PlotLoaded(plots));
    } catch (e) {
      emit(PlotError(e.toString()));
    }
  }
}
```

## Error Handling

### Custom Exceptions
```dart
class GardenError implements Exception {
  final String message;
  final dynamic error;

  GardenError(this.message, [this.error]);

  @override
  String toString() => 'GardenError: $message${error != null ? '\n$error' : ''}';
}
```

### Error Handling in UI
```dart
class GardenListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlotBloc, PlotState>(
      builder: (context, state) {
        if (state is PlotLoading) {
          return const CircularProgressIndicator();
        }
        if (state is PlotError) {
          return ErrorWidget(message: state.message);
        }
        if (state is PlotLoaded) {
          return PlotList(plots: state.plots);
        }
        return const SizedBox.shrink();
      },
    );
  }
}
```

## Testing

### Unit Tests
```dart
void main() {
  group('PlotRepository', () {
    late PlotRepository repository;
    late MockApiClient mockApiClient;
    late MockLocalStorage mockLocalStorage;

    setUp(() {
      mockApiClient = MockApiClient();
      mockLocalStorage = MockLocalStorage();
      repository = PlotRepository(mockApiClient, mockLocalStorage);
    });

    test('getPlots returns list of plots', () async {
      final plots = [Plot(id: 1, name: 'Test Plot')];
      when(mockApiClient.getPlots()).thenAnswer((_) async => plots);

      final result = await repository.getPlots();

      expect(result, equals(plots));
      verify(mockApiClient.getPlots()).called(1);
    });
  });
}
```

### Widget Tests
```dart
void main() {
  group('GardenListPage', () {
    late MockPlotBloc mockPlotBloc;

    setUp(() {
      mockPlotBloc = MockPlotBloc();
    });

    testWidgets('shows loading indicator when loading', (tester) async {
      when(mockPlotBloc.state).thenReturn(PlotLoading());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: mockPlotBloc,
            child: const GardenListPage(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
```

## Documentation

### Code Comments
```dart
/// A service that handles garden-related operations.
///
/// This service provides methods for managing garden plots,
/// including creating, updating, and retrieving plot data.
/// It coordinates between the repository and local storage
/// to ensure data consistency.
class GardenService {
  /// Updates an existing plot in the garden.
  ///
  /// Throws a [GardenError] if the update fails.
  /// The error message will contain details about the failure.
  Future<void> updatePlot(Plot plot) async {
    // Implementation
  }
}
```

### Documentation Files
- Keep README.md up to date
- Document API changes
- Update architecture decisions
- Maintain changelog

## Performance

### Best Practices
1. Use const constructors
2. Implement proper widget keys
3. Optimize rebuilds
4. Use appropriate widgets
5. Implement proper caching
6. Handle large lists efficiently

### Memory Management
```dart
class GardenListPage extends StatefulWidget {
  @override
  _GardenListPageState createState() => _GardenListPageState();
}

class _GardenListPageState extends State<GardenListPage> {
  @override
  void dispose() {
    // Clean up resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: plots.length,
      itemBuilder: (context, index) {
        return PlotListItem(plot: plots[index]);
      },
    );
  }
}
```

## Security

### Best Practices
1. Use HTTPS for all API calls
2. Validate all user input
3. Sanitize error messages
4. Implement proper error handling
5. Use secure storage for sensitive data
6. Follow Flutter security guidelines

### Input Validation
```dart
class Plot {
  final String name;
  final double area;

  Plot({
    required this.name,
    required this.area,
  }) {
    if (name.isEmpty) {
      throw ArgumentError('Plot name cannot be empty');
    }
    if (area <= 0) {
      throw ArgumentError('Plot area must be positive');
    }
  }
}
``` 