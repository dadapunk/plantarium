import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:plantarium/core/state/pagination_state.dart';
import 'package:plantarium/core/presentation/widgets/state/error_state.dart';
import 'package:plantarium/core/presentation/widgets/state/loading_state.dart';

/// A widget that displays a paginated list using [PaginationState].
///
/// This widget handles all the states of paginated data loading:
/// - Initial loading
/// - Success with data
/// - Empty state
/// - Error state
/// - Loading more state
class PaginatedListView<T> extends StatefulWidget {
  /// The pagination state to render.
  final PaginationState<T> state;

  /// Builder function for rendering each item in the list.
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  /// Function to call to load the next page.
  final VoidCallback onLoadMore;

  /// Function to call when the list is refreshed.
  final Future<void> Function() onRefresh;

  /// Function to call when retry is pressed in the error state.
  final VoidCallback onRetry;

  /// The text to display when the list is empty.
  final String emptyText;

  /// The height of the loading indicator at the bottom when loading more.
  final double loadMoreHeight;

  /// The scroll controller for the list.
  final ScrollController? scrollController;

  /// Whether to use a sliver list instead of a normal list.
  final bool useSliver;

  /// Creates a paginated list view.
  const PaginatedListView({
    super.key,
    required this.state,
    required this.itemBuilder,
    required this.onLoadMore,
    required this.onRefresh,
    required this.onRetry,
    this.emptyText = 'No items available',
    this.loadMoreHeight = 80.0,
    this.scrollController,
    this.useSliver = false,
  });

  @override
  State<PaginatedListView<T>> createState() => _PaginatedListViewState<T>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<PaginationState<T>>('state', state));
    properties.add(
      ObjectFlagProperty<
        Widget Function(BuildContext context, T item, int index)
      >.has('itemBuilder', itemBuilder),
    );
    properties.add(
      ObjectFlagProperty<VoidCallback>.has('onLoadMore', onLoadMore),
    );
    properties.add(
      ObjectFlagProperty<Future<void> Function()>.has('onRefresh', onRefresh),
    );
    properties.add(ObjectFlagProperty<VoidCallback>.has('onRetry', onRetry));
    properties.add(StringProperty('emptyText', emptyText));
    properties.add(DoubleProperty('loadMoreHeight', loadMoreHeight));
    properties.add(
      DiagnosticsProperty<ScrollController?>(
        'scrollController',
        scrollController,
      ),
    );
    properties.add(DiagnosticsProperty<bool>('useSliver', useSliver));
  }
}

class _PaginatedListViewState<T> extends State<PaginatedListView<T>> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _scrollController.dispose();
    } else {
      _scrollController.removeListener(_onScroll);
    }
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    // Trigger load more when user scrolls to 75% of the list
    if (maxScroll - currentScroll <= maxScroll * 0.25 &&
        widget.state.canLoadMore) {
      widget.onLoadMore();
    }
  }

  Widget _buildBody() => widget.state.maybeMap(
    initial: (_) => const Center(child: LoadingState()),
    loading: (_) => const Center(child: LoadingState()),
    loadingMore: (loadingMoreState) {
      return _buildListWithItems(loadingMoreState.items, showLoadMore: true);
    },
    success: (successState) {
      if (successState.items.isEmpty) {
        return _buildEmptyState();
      }
      return _buildListWithItems(successState.items, showLoadMore: false);
    },
    error: (errorState) {
      if (errorState.items?.isNotEmpty ?? false) {
        return Column(
          children: [
            Expanded(
              child: _buildListWithItems(
                errorState.items!,
                showLoadMore: false,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Theme.of(
                context,
              ).colorScheme.errorContainer.withOpacity(0.3),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      errorState.message,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: widget.onRetry,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ],
        );
      }
      return Center(
        child: ErrorState(message: errorState.message, onRetry: widget.onRetry),
      );
    },
    orElse: () => const SizedBox(),
  );

  Widget _buildSliverBody() => widget.state.maybeMap(
    initial:
        (_) => const SliverFillRemaining(child: Center(child: LoadingState())),
    loading:
        (_) => const SliverFillRemaining(child: Center(child: LoadingState())),
    loadingMore: (loadingMoreState) {
      return _buildSliverListWithItems(
        loadingMoreState.items,
        showLoadMore: true,
      );
    },
    success: (successState) {
      if (successState.items.isEmpty) {
        return SliverFillRemaining(child: _buildEmptyState());
      }
      return _buildSliverListWithItems(successState.items, showLoadMore: false);
    },
    error: (errorState) {
      if (errorState.items?.isNotEmpty ?? false) {
        return SliverList(
          delegate: SliverChildListDelegate([
            ...errorState.items!.asMap().entries.map((entry) {
              return widget.itemBuilder(context, entry.value, entry.key);
            }).toList(),
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Theme.of(
                context,
              ).colorScheme.errorContainer.withOpacity(0.3),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      errorState.message,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: widget.onRetry,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ]),
        );
      }
      return SliverFillRemaining(
        child: Center(
          child: ErrorState(
            message: errorState.message,
            onRetry: widget.onRetry,
          ),
        ),
      );
    },
    orElse: () => const SliverFillRemaining(),
  );

  Widget _buildListWithItems(
    final List<T> items, {
    required final bool showLoadMore,
  }) => RefreshIndicator(
    onRefresh: widget.onRefresh,
    child: ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: items.length + (showLoadMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == items.length) {
          return SizedBox(
            height: widget.loadMoreHeight,
            child: const Center(
              child: LoadingState(size: 24, showMessage: false),
            ),
          );
        }
        return widget.itemBuilder(context, items[index], index);
      },
    ),
  );

  Widget _buildSliverListWithItems(
    final List<T> items, {
    required final bool showLoadMore,
  }) => SliverList(
    delegate: SliverChildBuilderDelegate((context, index) {
      if (index == items.length) {
        return SizedBox(
          height: widget.loadMoreHeight,
          child: const Center(
            child: LoadingState(size: 24, showMessage: false),
          ),
        );
      }
      return widget.itemBuilder(context, items[index], index);
    }, childCount: items.length + (showLoadMore ? 1 : 0)),
  );

  Widget _buildEmptyState() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.info_outline, size: 64, color: Colors.grey),
        const SizedBox(height: 16),
        Text(
          widget.emptyText,
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: widget.onRefresh,
          icon: const Icon(Icons.refresh),
          label: const Text('Refresh'),
        ),
      ],
    ),
  );

  @override
  Widget build(final BuildContext context) {
    if (widget.useSliver) {
      return _buildSliverBody();
    }
    return _buildBody();
  }
}
