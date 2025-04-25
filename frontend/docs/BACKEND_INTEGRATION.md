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

## Architecture Overview

### Backend Services
The NestJS backend provides the following core services:
- Garden Management (Plot controller/service)
- Plant Data Management (Plant controller/service)
- Permapeople API Integration (ApiPermapeopleService)
- Weather Data Service (to be implemented)

### Frontend Integration Points
The Flutter frontend will interact with these services through:
- HTTP API Client
- WebSocket connections (for real-time updates)
- Local storage for offline support
- State management for data synchronization

## API Communication

### HTTP Client
```dart
// Example API client structure
class ApiClient {
  final Dio _dio;
  final String _baseUrl;

  ApiClient({
    required String baseUrl,
  }) : _baseUrl = baseUrl,
       _dio = Dio(BaseOptions(
         baseUrl: baseUrl,
       ));

  // Garden endpoints
  Future<List<Plot>> getPlots() async {
    final response = await _dio.get('/plots');
    return (response.data as List).map((json) => Plot.fromJson(json)).toList();
  }

  // Plant endpoints
  Future<List<Plant>> getPlants() async {
    final response = await _dio.get('/plants');
    return (response.data as List).map((json) => Plant.fromJson(json)).toList();
  }
}
```

### WebSocket Integration
```dart
// Example WebSocket client
class WebSocketClient {
  final WebSocketChannel _channel;

  WebSocketClient(String url) : _channel = WebSocketChannel.connect(Uri.parse(url));

  Stream<dynamic> get updates => _channel.stream;

  void sendMessage(dynamic message) {
    _channel.sink.add(message);
  }

  void dispose() {
    _channel.sink.close();
  }
}
```

## Data Flow

### Request Flow
1. UI triggers action
2. State management handles the action
3. Repository makes API call
4. API client sends request to backend
5. Backend processes request
6. Response flows back through the chain

### Response Flow
1. Backend sends response
2. API client receives response
3. Repository processes response
4. State management updates state
5. UI reflects changes

## Error Handling

### Error Types
1. **Network Errors**
   - Connection timeout
   - No internet connection
   - Server unavailable

2. **API Errors**
   - Invalid request
   - Resource not found
   - Server error

3. **Data Validation Errors**
   - Invalid input
   - Missing required fields
   - Type mismatch

### Error Handling Strategy
```dart
// Example error handling
class ApiError implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiError(this.message, {this.statusCode, this.data});

  @override
  String toString() => 'ApiError: $message (Status: $statusCode)';
}

class ErrorHandler {
  static ApiError handleError(dynamic error) {
    if (error is DioError) {
      switch (error.type) {
        case DioErrorType.connectionTimeout:
          return ApiError('Connection timeout');
        case DioErrorType.badResponse:
          return ApiError(
            error.response?.data['message'] ?? 'Bad response',
            statusCode: error.response?.statusCode,
            data: error.response?.data,
          );
        // Handle other error types
      }
    }
    return ApiError('Unknown error occurred');
  }
}
```

## Offline Support

### Local Storage
```dart
// Example local storage
class LocalStorage {
  final Isar _isar;

  LocalStorage(this._isar);

  Future<void> savePlot(Plot plot) async {
    await _isar.writeTxn(() async {
      await _isar.plots.put(plot);
    });
  }

  Future<List<Plot>> getPlots() async {
    return await _isar.plots.where().findAll();
  }
}
```

### Data Synchronization
1. Store changes locally
2. Queue sync operations
3. Sync when online
4. Handle conflicts
5. Update UI accordingly

## State Management

### Repository Pattern
```dart
// Example repository
class PlotRepository {
  final ApiClient _apiClient;
  final LocalStorage _localStorage;

  PlotRepository(this._apiClient, this._localStorage);

  Future<List<Plot>> getPlots() async {
    try {
      final plots = await _apiClient.getPlots();
      await _localStorage.savePlots(plots);
      return plots;
    } catch (e) {
      return await _localStorage.getPlots();
    }
  }
}
```

### State Management with Bloc
```dart
// Example Bloc
class PlotBloc extends Bloc<PlotEvent, PlotState> {
  final PlotRepository _repository;

  PlotBloc(this._repository) : super(PlotInitial()) {
    on<LoadPlots>(_onLoadPlots);
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

## Testing Strategy

### Unit Tests
- Test API client
- Test repositories
- Test state management
- Test data models

### Integration Tests
- Test API integration
- Test offline functionality
- Test data synchronization
- Test error handling

### E2E Tests
- Test complete user flows
- Test data persistence
- Test error scenarios

## Best Practices

1. **API Versioning**
   - Use versioned API endpoints
   - Handle version migration
   - Support backward compatibility

2. **Caching**
   - Implement proper caching strategies
   - Handle cache invalidation
   - Use appropriate cache duration

3. **Security**
   - HTTPS communication
   - Input validation
   - Error message sanitization

4. **Performance**
   - Optimize network requests
   - Implement request batching
   - Use appropriate compression
   - Handle large datasets efficiently

5. **Monitoring**
   - Track API performance
   - Monitor error rates
   - Log important events
   - Track user behavior 