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
    required List<T> items,
    required int currentPage,
    required bool hasReachedMax,
  }) = _PaginationLoadingMore<T>;

  /// Success state with loaded items.
  const factory PaginationState.success({
    required List<T> items,
    required int currentPage,
    required bool hasReachedMax,
  }) = _PaginationSuccess<T>;

  /// Error state when loading fails.
  const factory PaginationState.error({
    required String message,
    Object? error,
    StackTrace? stackTrace,
    List<T>? items,
    @Default(0) int currentPage,
    @Default(false) bool hasReachedMax,
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
    success: (state) => state.items,
    loadingMore: (state) => state.items,
    error: (state) => state.items ?? [],
    orElse: () => [],
  );

  /// Helper to check if there are more items to load.
  bool get canLoadMore =>
      maybeMap(
        success: (state) => !state.hasReachedMax,
        loadingMore: (state) => !state.hasReachedMax,
        error: (state) => !state.hasReachedMax,
        orElse: () => false,
      ) &&
      !isLoadingMore;

  /// Helper to get the current page number.
  int get currentPage => maybeMap(
    success: (state) => state.currentPage,
    loadingMore: (state) => state.currentPage,
    error: (state) => state.currentPage,
    orElse: () => 0,
  );

  /// Helper to get the error message if any.
  String? get errorMessage =>
      maybeMap(error: (state) => state.message, orElse: () => null);
}
