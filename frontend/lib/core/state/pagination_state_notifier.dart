import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plantarium/core/state/pagination_state.dart';

/// A base class for StateNotifiers that use [PaginationState] for paginated data.
///
/// [T] is the type of items in the list.
abstract class PaginationStateNotifier<T>
    extends StateNotifier<PaginationState<T>> {
  /// Creates a new PaginationStateNotifier with an initial state.
  PaginationStateNotifier() : super(const PaginationState.initial());

  /// Sets the state to loading (for initial page).
  void setLoading() {
    state = const PaginationState.loading();
  }

  /// Sets the state to loading more (for subsequent pages).
  void setLoadingMore() {
    if (state.items.isEmpty) {
      state = const PaginationState.loading();
    } else {
      state = PaginationState.loadingMore(
        items: state.items,
        currentPage: state.currentPage,
        hasReachedMax: state.canLoadMore,
      );
    }
  }

  /// Sets the state to success with the provided items.
  void setSuccess({
    required final List<T> items,
    required final int currentPage,
    required final bool hasReachedMax,
  }) {
    state = PaginationState.success(
      items: items,
      currentPage: currentPage,
      hasReachedMax: hasReachedMax,
    );
  }

  /// Appends new items to the existing list and updates the state.
  void appendItems({
    required final List<T> newItems,
    required final int currentPage,
    required final bool hasReachedMax,
  }) {
    final currentItems = state.items;
    final allItems = [...currentItems, ...newItems];

    state = PaginationState.success(
      items: allItems,
      currentPage: currentPage,
      hasReachedMax: hasReachedMax,
    );
  }

  /// Sets the state to error with the provided message.
  void setError(
    final String message, {
    final Object? error,
    final StackTrace? stackTrace,
  }) {
    state = PaginationState.error(
      message: message,
      error: error,
      stackTrace: stackTrace,
      items: state.items,
      currentPage: state.currentPage,
    );
  }

  /// Loads the first page of items.
  ///
  /// Implement this method in your subclass to fetch the first page.
  Future<void> loadFirstPage();

  /// Loads the next page of items.
  ///
  /// Implement this method in your subclass to fetch the next page.
  Future<void> loadNextPage();

  /// A utility method to run an operation for the first page with proper state handling.
  Future<void> runLoadFirstPage(
    final Future<({List<T> items, bool hasReachedMax})> Function() callback,
  ) async {
    try {
      setLoading();
      final result = await callback();
      setSuccess(
        items: result.items,
        currentPage: 1,
        hasReachedMax: result.hasReachedMax,
      );
    } catch (e, stackTrace) {
      setError(e.toString(), error: e, stackTrace: stackTrace);
    }
  }

  /// A utility method to run an operation for the next page with proper state handling.
  Future<void> runLoadNextPage(
    final Future<({List<T> items, bool hasReachedMax})> Function() callback,
  ) async {
    if (state.isLoadingMore || !state.canLoadMore) {
      return;
    }

    try {
      setLoadingMore();
      final result = await callback();
      appendItems(
        newItems: result.items,
        currentPage: state.currentPage + 1,
        hasReachedMax: result.hasReachedMax,
      );
    } catch (e, stackTrace) {
      setError(e.toString(), error: e, stackTrace: stackTrace);
    }
  }

  /// Refreshes the list by loading the first page again.
  Future<void> refresh() => loadFirstPage();
}
