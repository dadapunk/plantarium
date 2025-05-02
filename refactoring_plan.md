# Plantarium Refactoring Plan

This document outlines a comprehensive plan to refactor the Plantarium application to align with the architectural patterns and best practices specified in the project documentation.

## 1. Project Structure Refactoring

### 1.1 Feature Module Restructuring

- [x] 1.1.1 Move `/core/models/garden/garden_note.dto.dart` to `/features/garden_notes/data/models/garden_note.dto.dart`
- [x] 1.1.2 Create `/features/garden_notes/data/datasources/garden_notes_api.datasource.dart` and `garden_notes_local.datasource.dart`
- [x] 1.1.3 Implement `/features/garden_notes/domain/entities/garden_note.entity.dart` separating entity from DTO
- [x] 1.1.4 Define `/features/garden_notes/domain/repositories/garden_notes.repository.dart` interface
- [x] 1.1.5 Create repository implementation in `/features/garden_notes/data/repositories/garden_notes.repository_impl.dart`
- [x] 1.1.6 Frontend fix for duplicate markdown headers in garden notes

### 1.2 Core Module Organization

- [x] 1.2.1 Establish `/core/network/api_client.dart` interface with base API functionality
- [x] 1.2.2 Implement Retrofit-based API client and generator configurations
- [x] 1.2.3 Create HTTP interceptors for logging, caching, and error handling (authentication not needed)
- [x] 1.2.4 Set up base exception hierarchy in `/core/errors/app_exception.dart`
- [x] 1.2.5 Implement environment-specific configuration using `.env` files

### 1.3 Shared Components

- [x] 1.3.1 Create shared widget library for common UI patterns
- [x] 1.3.2 Implement reusable loading indicators and error displays
- [x] 1.3.3 Extract service interfaces to `/shared/services/`
- [x] 1.3.4 Set up dependency injection for shared services

## 2. State Management Refactoring

### 2.1 Riverpod Implementation

- [ ] 2.1.1 Add Riverpod dependencies to `pubspec.yaml`
- [ ] 2.1.2 Configure ProviderScope in main.dart application wrapper
- [ ] 2.1.3 Create provider container for testing environments
- [ ] 2.1.4 Implement base state classes using freezed package
- [ ] 2.1.5 Design error, loading, and success state representations

### 2.2 Garden Notes State Management

- [ ] 2.2.1 Create `garden_notes.state.dart` with freezed union types
- [ ] 2.2.2 Implement `garden_notes.notifier.dart` extending StateNotifier
- [ ] 2.2.3 Set up provider definitions in `garden_notes.provider.dart`
- [ ] 2.2.4 Create use case classes for each garden note operation
- [ ] 2.2.5 Implement dependency injection for state management

## 3. API and Data Layer

### 3.1 API Client Enhancement

- [ ] 3.1.1 Define API interfaces with Retrofit annotations
- [ ] 3.1.2 Implement typed error handling for network failures
- [ ] 3.1.3 Create request/response interceptors for logging
- [ ] 3.1.4 Implement proper error mapping from HTTP to domain exceptions
- [ ] 3.1.5 Add support for configurable request timeouts and retry policies

### 3.2 Caching Strategy

- [ ] 3.2.1 Implement time-based cache expiration
- [ ] 3.2.2 Create cache invalidation triggers for relevant actions
- [ ] 3.2.3 Add cache headers support for HTTP requests
- [ ] 3.2.4 Implement offline-first data access patterns
- [ ] 3.2.5 Create database migration mechanism for schema upgrades

### 3.3 Garden Notes Repository

- [ ] 3.3.1 Implement `GardenNotesRepository` interface
- [ ] 3.3.2 Create concrete implementation with API and local data sources
- [ ] 3.3.3 Add proper error handling and mapping
- [ ] 3.3.4 Implement caching strategy for garden notes
- [ ] 3.3.5 Add synchronization of offline changes

## 4. User Interface Improvements

### 4.1 Garden Notes List Screen

- [ ] 4.1.1 Refactor to use Riverpod state management
- [ ] 4.1.2 Implement proper loading states with shimmer effect
- [ ] 4.1.3 Add error handling with recovery options
- [ ] 4.1.4 Improve UI with better typography and spacing
- [ ] 4.1.5 Add search and filtering functionality

### 4.2 Note Editor Screen

- [ ] 4.2.1 Enhance markdown editor with syntax highlighting
- [ ] 4.2.2 Add toolbar for common markdown functions
- [ ] 4.2.3 Implement proper auto-save with visual indicators
- [ ] 4.2.4 Add support for linking to plants and plots
- [ ] 4.2.5 Implement tag selection interface

### 4.3 Responsive Design

- [ ] 4.3.1 Create adaptive layouts for different screen sizes
- [ ] 4.3.2 Implement responsive grids for content
- [ ] 4.3.3 Add keyboard shortcuts for desktop platforms
- [ ] 4.3.4 Optimize touch targets for better usability

## 5. Testing Implementation

### 5.1 Unit Tests

- [ ] 5.1.1 Set up mocking framework with mocktail
- [ ] 5.1.2 Write tests for domain entities and use cases
- [ ] 5.1.3 Create repository tests with mock data sources
- [ ] 5.1.4 Implement state management tests
- [ ] 5.1.5 Set up automated test runner in CI/CD

### 5.2 Widget Tests

- [ ] 5.2.1 Implement tests for shared widgets
- [ ] 5.2.2 Create tests for garden notes list screen
- [ ] 5.2.3 Test note editor screen functionality
- [ ] 5.2.4 Implement golden tests for UI consistency
- [ ] 5.2.5 Set up widget testing utilities and helpers

### 5.3 Integration Tests

- [ ] 5.3.1 Create end-to-end tests for main user flows
- [ ] 5.3.2 Test offline functionality and synchronization
- [ ] 5.3.3 Implement performance tests for critical screens
- [ ] 5.3.4 Set up integration with backend API tests

## 6. Documentation & Standards

### 6.1 Code Documentation

- [ ] 6.1.1 Add dartdoc comments to all public APIs
- [ ] 6.1.2 Document architecture decisions and patterns
- [ ] 6.1.3 Create diagrams for key flows and structures
- [ ] 6.1.4 Document state management approach

### 6.2 User Documentation

- [ ] 6.2.1 Update garden notes feature documentation
- [ ] 6.2.2 Create user guides for new functionality
- [ ] 6.2.3 Document offline capabilities and limitations
- [ ] 6.2.4 Add troubleshooting guides for common issues

### 6.3 Developer Guides

- [ ] 6.3.1 Create onboarding documentation for new developers
- [ ] 6.3.2 Document testing strategy and best practices
- [ ] 6.3.3 Update contribution guidelines
- [ ] 6.3.4 Document release process and versioning

## 7. Continuous Integration & Deployment

### 7.1 CI Pipeline

- [ ] 7.1.1 Set up automated testing on pull requests
- [ ] 7.1.2 Implement static code analysis with dart analyze
- [ ] 7.1.3 Configure code coverage reporting
- [ ] 7.1.4 Set up build verification for all platforms

### 7.2 CD Pipeline

- [ ] 7.2.1 Configure automated builds for each platform
- [ ] 7.2.2 Set up versioning and release tagging
- [ ] 7.2.3 Implement automated deployment to test environments
- [ ] 7.2.4 Create release notes generation

## Acceptance Criteria

- Application structure follows Clean Architecture principles
- State management uses Riverpod with proper separation of concerns
- API communication handles errors gracefully with typed exceptions
- Offline support works seamlessly with proper synchronization
- UI is responsive and follows design system guidelines
- Test coverage meets or exceeds 80% for domain and data layers
- Documentation is comprehensive and up-to-date
- CI/CD pipeline automates testing and deployment
- Performance metrics show improvement over current implementation

**Progress Tracking**: Mark tasks as [x] when completed 