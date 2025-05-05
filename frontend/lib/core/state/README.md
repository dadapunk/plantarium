# State Management Architecture

This directory contains the core state management classes used throughout the application. We use a combination of Riverpod and Freezed for type-safe, immutable state management.

## Key Components

### `BaseState<T>`

A generic state class that represents different states for a single entity or value:

- `initial`: Initial state with no data
- `loading`: Loading state with optional previous data
- `success`: Success state with required data
- `error`: Error state with message and optional previous data

### `PaginationState<T>`

A specialized state class for handling paginated lists:

- `initial`: Initial state before any data is loaded
- `loading`: Loading state for the first page
- `loadingMore`: Loading additional pages with existing data
- `success`: Success state with loaded items and pagination metadata
- `error`: Error state with optional existing data

### Base Notifiers

- `BaseStateNotifier<T>`: Base class for notifiers that manage a `BaseState<T>`
- `PaginationStateNotifier<T>`: Base class for notifiers that manage a `PaginationState<T>`

## Usage

### Basic State Management

```dart
// Define a state notifier
class UserNotifier extends BaseStateNotifier<User> {
  final UserRepository repository;
  
  UserNotifier(this.repository);
  
  Future<void> fetchUser(String id) async {
    await runWithState(() async {
      return await repository.getUser(id);
    });
  }
}

// Define a provider
final userProvider = StateNotifierProvider<UserNotifier, BaseState<User>>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return UserNotifier(repository);
});

// Use in a widget
class UserProfileScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userProvider);
    
    return state.maybeMap(
      initial: (_) => const SizedBox(),
      loading: (_) => const CircularProgressIndicator(),
      error: (error) => Text('Error: ${error.message}'),
      success: (success) => UserProfileWidget(user: success.data),
      orElse: () => const SizedBox(),
    );
  }
}
```

### Pagination

```dart
// Define a pagination notifier
class UsersNotifier extends PaginationStateNotifier<User> {
  final UserRepository repository;
  
  UsersNotifier(this.repository);
  
  @override
  Future<void> loadFirstPage() async {
    await runLoadFirstPage(() async {
      final result = await repository.getUsers(page: 1);
      return (
        items: result.users,
        hasReachedMax: result.page >= result.totalPages,
      );
    });
  }
  
  @override
  Future<void> loadNextPage() async {
    await runLoadNextPage(() async {
      final nextPage = state.currentPage + 1;
      final result = await repository.getUsers(page: nextPage);
      return (
        items: result.users,
        hasReachedMax: result.page >= result.totalPages,
      );
    });
  }
}

// Define a provider
final usersProvider = StateNotifierProvider<UsersNotifier, PaginationState<User>>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return UsersNotifier(repository);
});

// Use in a widget
class UsersListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(usersProvider);
    
    return Column(
      children: [
        if (state.isLoading)
          const CircularProgressIndicator(),
        if (state.hasError)
          Text('Error: ${state.errorMessage}'),
        Expanded(
          child: ListView.builder(
            itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == state.items.length) {
                return const CircularProgressIndicator();
              }
              return UserListItem(user: state.items[index]);
            },
            onEndReached: () {
              if (state.canLoadMore) {
                ref.read(usersProvider.notifier).loadNextPage();
              }
            },
          ),
        ),
      ],
    );
  }
}
```

## Code Generation

These state classes use Freezed for immutable state representation. To generate the necessary code, run:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
``` 