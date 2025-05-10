import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plantarium/features/dashboard/presentation/widgets/app_sidebar.dart';
import 'package:plantarium/features/plant_database/data/models/plant.dto.dart';
import 'package:plantarium/features/plant_database/presentation/providers/plant_database.provider.dart';
import 'package:plantarium/features/plant_database/presentation/widgets/plant_card.dart';
import 'package:plantarium/shared/widgets/app_widgets.dart';

class PlantDatabaseScreen extends ConsumerWidget {
  const PlantDatabaseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the provider using Riverpod's ref
    final plantDatabaseState = ref.watch(plantDatabaseProvider);
    final plantDatabaseNotifier = ref.read(plantDatabaseProvider.notifier);

    // Initialize loading plants
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (plantDatabaseState.allPlants.isEmpty &&
          !plantDatabaseState.isLoading) {
        plantDatabaseNotifier.loadPlants();
      }
    });

    return const _PlantDatabaseContent();
  }
}

class _PlantDatabaseContent extends ConsumerStatefulWidget {
  const _PlantDatabaseContent({super.key});

  @override
  ConsumerState<_PlantDatabaseContent> createState() =>
      _PlantDatabaseContentState();
}

class _PlantDatabaseContentState extends ConsumerState<_PlantDatabaseContent> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final state = ref.watch(plantDatabaseProvider);
    final notifier = ref.read(plantDatabaseProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      body: Row(
        children: [
          // Sidebar navigation
          const AppSidebar(selectedIndex: 2),

          // Main content
          Expanded(
            child: Column(
              children: [
                // App bar
                _buildAppBar(theme),

                // Content area
                Expanded(child: _buildBody(context, state, notifier, theme)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(final ThemeData theme) => Container(
    height: 60,
    padding: const EdgeInsets.symmetric(horizontal: 24.0),
    decoration: BoxDecoration(
      color: theme.scaffoldBackgroundColor,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Plant Database',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Browse and search for plants to add to your garden',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _buildBody(
    final BuildContext context,
    final plantDatabaseState,
    final plantDatabaseNotifier,
    final ThemeData theme,
  ) {
    if (plantDatabaseState.isLoading) {
      return AppLoadingIndicators.standard(
        message: 'Loading plant database...',
      );
    }

    if (plantDatabaseState.hasError) {
      return AppErrorDisplays.standard(
        errorMessage: plantDatabaseState.errorMessage ?? 'Unknown error',
        onRetry: plantDatabaseNotifier.loadPlants,
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Search and filter row
          _buildSearchAndFilterRow(context, plantDatabaseNotifier, theme),
          const SizedBox(height: 16),

          // Category tabs
          _buildCategoryTabs(
            context,
            plantDatabaseState,
            plantDatabaseNotifier,
            theme,
          ),
          const SizedBox(height: 16),

          // Plant grid
          Expanded(
            child:
                plantDatabaseState.filteredPlants.isEmpty
                    ? _buildEmptyState(theme)
                    : _buildPlantGrid(
                      context,
                      plantDatabaseState,
                      plantDatabaseNotifier,
                      theme,
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilterRow(
    final BuildContext context,
    final plantDatabaseNotifier,
    final ThemeData theme,
  ) => Row(
    children: [
      // Search field
      Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: theme.dividerColor),
          ),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search plants...',
              border: InputBorder.none,
              prefixIcon: const Icon(Icons.search),
              prefixIconConstraints: const BoxConstraints(minWidth: 40),
              suffixIcon:
                  _searchController.text.isNotEmpty
                      ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          plantDatabaseNotifier.setSearchQuery('');
                        },
                      )
                      : null,
            ),
            onChanged: (value) {
              plantDatabaseNotifier.setSearchQuery(value);
            },
          ),
        ),
      ),
      const SizedBox(width: 16),

      // Filter button
      ElevatedButton.icon(
        onPressed: () {
          // Filter functionality would go here
        },
        icon: const Icon(Icons.filter_list),
        label: const Text('Filter'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      const SizedBox(width: 8),

      // Sort button
      ElevatedButton.icon(
        onPressed: () {
          // Sort functionality would go here
        },
        icon: const Icon(Icons.sort),
        label: const Text('Sort'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    ],
  );

  Widget _buildCategoryTabs(
    final BuildContext context,
    final plantDatabaseState,
    final plantDatabaseNotifier,
    final ThemeData theme,
  ) {
    final categories = [
      'All Plants',
      'Vegetables',
      'Fruits',
      'Herbs',
      'Flowers',
      'Favorites',
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            categories.map((final category) {
              final isSelected =
                  plantDatabaseState.selectedCategory == category;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (final selected) {
                    if (selected) {
                      plantDatabaseNotifier.setSelectedCategory(category);
                    }
                  },
                  backgroundColor: theme.cardColor,
                  selectedColor: theme.colorScheme.primary.withOpacity(0.2),
                  labelStyle: TextStyle(
                    color:
                        isSelected
                            ? theme.colorScheme.primary
                            : theme.textTheme.bodyMedium?.color,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildEmptyState(final ThemeData theme) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.local_florist,
          size: 64,
          color: theme.colorScheme.primary.withOpacity(0.5),
        ),
        const SizedBox(height: 16),
        Text(
          'No plants found',
          style: theme.textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Try adjusting your search or filters',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );

  Widget _buildPlantGrid(
    final BuildContext context,
    final plantDatabaseState,
    final plantDatabaseNotifier,
    final ThemeData theme,
  ) {
    // Calculate crossAxisCount based on screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = (screenWidth / 350).floor();

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount > 0 ? crossAxisCount : 1,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: plantDatabaseState.filteredPlants.length,
      itemBuilder: (final context, final index) {
        final plant = plantDatabaseState.filteredPlants[index];
        return PlantCard(
          plant: plant,
          onToggleFavorite: plantDatabaseNotifier.toggleFavorite,
          onTap: () => _viewPlantDetails(context, plant),
        );
      },
    );
  }

  void _viewPlantDetails(final BuildContext context, final PlantDTO plant) {
    // This would navigate to a plant details screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing details for ${plant.name}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
