# Frontend-Backend Integration Approach

This document outlines the integration strategy between the Flutter frontend and NestJS backend for the Plantarium application.

## Table of Contents
1. [Architecture Overview](#architecture-overview)
2. [API Communication](#api-communication)
3. [Data Flow](#data-flow)
4. [Error Handling](#error-handling)
5. [Offline Support](#offline-support)
6. [State Management](#state-management)
7. [Testing Strategy](#testing-strategy)
8. [Environment Configuration](#environment-configuration)

## Architecture Overview

### Backend Services
The NestJS backend provides the following core services:
- Garden Management (Plot controller/service)
- Plant Data Management (Plant controller/service)
- Permapeople API Integration (ApiPermapeopleService)
- Weather Data Service (to be implemented)

### Frontend Integration Points
The Flutter frontend interacts with these services through:
- HTTP API Client (using Dio)
- WebSocket connections (for real-time updates)
- Local storage (using SQLite)
- State management (using Riverpod)

## API Communication

### HTTP Client
```dart
// API client using Dio and Retrofit
@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET('/plots')
  Future<List<Plot>> getPlots();

  @GET('/plots/{id}')
  Future<Plot> getPlot(@Path('id') String id);

  @POST('/plots')
  Future<Plot> createPlot(@Body() Plot plot);

  @PUT('/plots/{id}')
  Future<Plot> updatePlot(
    @Path('id') String id,
    @Body() Plot plot,
  );

  @DELETE('/plots/{id}')
  Future<void> deletePlot(@Path('id') String id);

  // Plant endpoints
  @GET('/plants')
  Future<List<Plant>> getPlants();

  @GET('/plants/{id}')
  Future<Plant> getPlant(@Path('id') String id);
}

// API client provider
final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = ref.watch(dioProvider);
  final config = ref.watch(configProvider);
  
  return ApiClient(dio, baseUrl: config.apiBaseUrl);
});

// Dio configuration
final dioProvider = Provider<Dio>((ref) {
  final config = ref.watch(configProvider);
  final dio = Dio(BaseOptions(
    baseUrl: config.apiBaseUrl,
    connectTimeout: config.timeoutDuration,
    receiveTimeout: config.timeoutDuration,
  ));

  if (config.enableLogging) {
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  return dio;
});
```

### WebSocket Integration
```dart
class WebSocketService {
  final WebSocketChannel _channel;
  final void Function(dynamic)? onError;
  final void Function()? onDone;

  WebSocketService({
    required String url,
    this.onError,
    this.onDone,
  }) : _channel = WebSocketChannel.connect(Uri.parse(url)) {
    _channel.stream.listen(
      _handleMessage,
      onError: onError,
      onDone: onDone,
    );
  }

  void _handleMessage(dynamic message) {
    // Handle different message types
    final data = jsonDecode(message as String);
    switch (data['type']) {
      case 'plot_update':
        _handlePlotUpdate(data['payload']);
        break;
      case 'plant_update':
        _handlePlantUpdate(data['payload']);
        break;
    }
  }

  void sendMessage(String type, dynamic payload) {
    final message = jsonEncode({
      'type': type,
      'payload': payload,
    });
    _channel.sink.add(message);
  }

  void dispose() {
    _channel.sink.close();
  }
}

// WebSocket service provider
final webSocketServiceProvider = Provider<WebSocketService>((ref) {
  final config = ref.watch(configProvider);
  return WebSocketService(
    url: config.wsUrl,
    onError: (error) => ref.read(errorHandlerProvider).handleError(error),
  );
});
```

## Data Flow

### Request Flow
1. UI action triggers a state change in Riverpod
2. State notifier handles the action
3. Repository layer processes the request
4. API client sends request to backend
5. Backend processes request
6. Response flows back through the chain

### Response Flow
```dart
// Example of data flow with Riverpod
final plotsProvider = StateNotifierProvider<PlotsNotifier, AsyncValue<List<Plot>>>((ref) {
  final repository = ref.watch(plotRepositoryProvider);
  return PlotsNotifier(repository);
});

class PlotsNotifier extends StateNotifier<AsyncValue<List<Plot>>> {
  final PlotRepository _repository;

  PlotsNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadPlots();
  }

  Future<void> loadPlots() async {
    state = const AsyncValue.loading();
    try {
      final plots = await _repository.getPlots();
      state = AsyncValue.data(plots);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addPlot(Plot plot) async {
    try {
      final newPlot = await _repository.createPlot(plot);
      state.whenData((plots) {
        state = AsyncValue.data([...plots, newPlot]);
      });
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
```

## Error Handling

### Error Types
```dart
// Base exception for all API errors
abstract class ApiException implements Exception {
  final String message;
  final dynamic error;

  const ApiException(this.message, [this.error]);
}

// Network-related errors
class NetworkException extends ApiException {
  final int? statusCode;

  const NetworkException(
    String message, {
    this.statusCode,
    dynamic error,
  }) : super(message, error);
}

// Data validation errors
class ValidationException extends ApiException {
  final Map<String, List<String>> errors;

  const ValidationException(
    String message,
    this.errors,
  ) : super(message);
}

// Error handler service
class ErrorHandler {
  final BuildContext context;

  ErrorHandler(this.context);

  void handleError(dynamic error) {
    if (error is NetworkException) {
      _showNetworkError(error);
    } else if (error is ValidationException) {
      _showValidationError(error);
    } else {
      _showGenericError(error);
    }
  }

  void _showNetworkError(NetworkException error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Network Error: ${error.message}'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
```

## Offline Support

### Local Storage
```dart
// Local storage using SQLite
@Collection()
class PlotModel {
  Id id = Isar.autoIncrement;
  String remoteId;
  String name;
  double area;
  DateTime lastSync;
  bool needsSync;

  PlotModel({
    required this.remoteId,
    required this.name,
    required this.area,
    required this.lastSync,
    this.needsSync = false,
  });
}

class LocalStorage {
  final Isar _isar;

  LocalStorage(this._isar);

  Future<void> savePlot(PlotModel plot) async {
    await _isar.writeTxn(() async {
      await _isar.plotModels.put(plot);
    });
  }

  Future<List<PlotModel>> getPlots() async {
    return await _isar.plotModels.where().findAll();
  }

  Stream<List<PlotModel>> watchPlots() {
    return _isar.plotModels.where().watch(fireImmediately: true);
  }
}
```

### Data Synchronization
```dart
class SyncService {
  final ApiClient _apiClient;
  final LocalStorage _localStorage;
  final ConnectivityService _connectivity;

  SyncService(this._apiClient, this._localStorage, this._connectivity) {
    _setupConnectivityListener();
  }

  void _setupConnectivityListener() {
    _connectivity.onConnectivityChanged.listen((connected) {
      if (connected) {
        syncPendingChanges();
      }
    });
  }

  Future<void> syncPendingChanges() async {
    final pendingPlots = await _localStorage.getPendingPlots();
    for (final plot in pendingPlots) {
      try {
        final updatedPlot = await _apiClient.updatePlot(
          plot.remoteId,
          plot.toApiModel(),
        );
        await _localStorage.markAsSynced(plot.id, updatedPlot);
      } catch (e) {
        // Handle sync error
      }
    }
  }
}
```

## State Management

### Repository Pattern
```dart
class PlotRepository {
  final ApiClient _apiClient;
  final LocalStorage _localStorage;
  final ConnectivityService _connectivity;

  PlotRepository(
    this._apiClient,
    this._localStorage,
    this._connectivity,
  );

  Future<List<Plot>> getPlots() async {
    try {
      if (await _connectivity.isConnected) {
        final plots = await _apiClient.getPlots();
        await _localStorage.savePlots(
          plots.map((p) => p.toLocalModel()).toList(),
        );
        return plots;
      }
      final localPlots = await _localStorage.getPlots();
      return localPlots.map((p) => p.toApiModel()).toList();
    } catch (e) {
      final localPlots = await _localStorage.getPlots();
      return localPlots.map((p) => p.toApiModel()).toList();
    }
  }
}
```

## Testing Strategy

### Unit Tests
```dart
void main() {
  group('PlotRepository', () {
    late PlotRepository repository;
    late MockApiClient mockApiClient;
    late MockLocalStorage mockLocalStorage;
    late MockConnectivityService mockConnectivity;

    setUp(() {
      mockApiClient = MockApiClient();
      mockLocalStorage = MockLocalStorage();
      mockConnectivity = MockConnectivityService();
      repository = PlotRepository(
        mockApiClient,
        mockLocalStorage,
        mockConnectivity,
      );
    });

    test('getPlots returns remote data when online', () async {
      when(() => mockConnectivity.isConnected).thenAnswer((_) async => true);
      when(() => mockApiClient.getPlots()).thenAnswer(
        (_) async => [Plot(id: '1', name: 'Test Plot')],
      );

      final result = await repository.getPlots();

      expect(result.length, equals(1));
      verify(() => mockApiClient.getPlots()).called(1);
    });
  });
}
```

### Integration Tests
```dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Plot Management Flow', () {
    testWidgets('Create and sync plot when online', (tester) async {
      await tester.pumpWidget(const ProviderScope(child: PlantariumApp()));

      // Test plot creation
      await tester.tap(find.byType(AddPlotButton));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextFormField).first,
        'New Test Plot',
      );
      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();

      // Verify plot was created and synced
      expect(find.text('New Test Plot'), findsOneWidget);
      expect(find.byIcon(Icons.cloud_done), findsOneWidget);
    });
  });
}
```

## Environment Configuration

### Environment Setup
```dart
enum Environment {
  development,
  staging,
  production,
}

class AppConfig {
  final Environment environment;
  final String apiBaseUrl;
  final String wsUrl;
  final bool enableLogging;
  final Duration timeoutDuration;

  const AppConfig({
    required this.environment,
    required this.apiBaseUrl,
    required this.wsUrl,
    required this.enableLogging,
    required this.timeoutDuration,
  });

  factory AppConfig.fromEnvironment() {
    final env = Environment.values.firstWhere(
      (e) => e.name == const String.fromEnvironment(
        'ENVIRONMENT',
        defaultValue: 'development',
      ),
      orElse: () => Environment.development,
    );

    switch (env) {
      case Environment.development:
        return AppConfig(
          environment: env,
          apiBaseUrl: 'http://localhost:3000',
          wsUrl: 'ws://localhost:3000',
          enableLogging: true,
          timeoutDuration: const Duration(seconds: 30),
        );
      case Environment.production:
        return AppConfig(
          environment: env,
          apiBaseUrl: 'https://api.plantarium.app',
          wsUrl: 'wss://api.plantarium.app',
          enableLogging: false,
          timeoutDuration: const Duration(seconds: 20),
        );
      // Add other environments as needed
    }
  }
}

// Configuration provider
final configProvider = Provider<AppConfig>((ref) {
  return AppConfig.fromEnvironment();
});
```

### Build Configuration
The application can be built for different environments using the following commands:

```bash
# Development build
flutter build <platform> --dart-define=ENVIRONMENT=development

# Staging build
flutter build <platform> --dart-define=ENVIRONMENT=staging

# Production build
flutter build <platform> --dart-define=ENVIRONMENT=production
```

## Best Practices

1. **API Versioning**
   - Use versioned API endpoints (e.g., `/api/v1/plots`)
   - Handle version migration gracefully
   - Support backward compatibility

2. **Caching Strategy**
   - Cache API responses appropriately
   - Implement cache invalidation
   - Use appropriate cache duration per endpoint

3. **Security**
   - Use HTTPS for all API calls
   - Implement proper error handling
   - Sanitize data before display
   - Use secure storage for sensitive data

4. **Performance**
   - Implement request batching where appropriate
   - Use pagination for large datasets
   - Optimize network requests
   - Cache resources efficiently

5. **Monitoring**
   - Log important events
   - Track API performance
   - Monitor error rates
   - Implement analytics as needed 