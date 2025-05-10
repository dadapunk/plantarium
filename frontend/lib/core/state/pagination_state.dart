import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_state.freezed.dart';

/// A pagination state that can be used to handle paginated data.
///
/// [T] is the type of items in the list.
@freezed
class PaginationState<T> with _$PaginationState<T> {
  /// Private constructor required by freezed
  const PaginationState._();

  /// Initial state before any data is loaded.
  const factory PaginationState.initial() = _PaginationInitial<T>;

  /// Loading state for the first page.
  const factory PaginationState.loading() = _PaginationLoading<T>;

  /// Loading more state when loading additional pages.
  ///
  /// The [items] parameter contains the items that have been loaded so far.
  const factory PaginationState.loadingMore({
    required final List<T> items,
    required final int currentPage,
    required final bool hasReachedMax,
  }) = _PaginationLoadingMore<T>;

  /// Success state with loaded items.
  const factory PaginationState.success({
    required final List<T> items,
    required final int currentPage,
    required final bool hasReachedMax,
  }) = _PaginationSuccess<T>;

  /// Error state when loading fails.
  const factory PaginationState.error({
    required final String message,
    final Object? error,
    final StackTrace? stackTrace,
    final List<T>? items,
    @Default(0) final int currentPage,
    @Default(false) final bool hasReachedMax,
  }) = _PaginationError<T>;

  /// Helper to check if the state is in loading state (initial load).
  bool get isLoading => maybeMap(loading: (_) => true, orElse: () => false);

  /// Helper to check if the state is loading more items.
  bool get isLoadingMore =>
      maybeMap(loadingMore: (_) => true, orElse: () => false);

  /// Helper to check if an error occurred.
  bool get hasError => maybeMap(error: (_) => true, orElse: () => false);

  /// Helper to get all items from states that might contain them.
  List<T> get items => maybeMap(
    success: (final state) => state.items,
    loadingMore: (final state) => state.items,
    error: (final state) => state.items ?? [],
    orElse: () => [],
  );

  /// Helper to check if there are more items to load.
  bool get canLoadMore =>
      maybeMap(
        success: (final state) => !state.hasReachedMax,
        loadingMore: (final state) => !state.hasReachedMax,
        error: (final state) => !state.hasReachedMax,
        orElse: () => false,
      ) &&
      !isLoadingMore;

  /// Helper to get the current page number.
  int get currentPage => maybeMap(
    success: (final state) => state.currentPage,
    loadingMore: (final state) => state.currentPage,
    error: (final state) => state.currentPage,
    orElse: () => 0,
  );

  /// Helper to get the error message if any.
  String? get errorMessage =>
      maybeMap(error: (final state) => state.message, orElse: () => null);
}
