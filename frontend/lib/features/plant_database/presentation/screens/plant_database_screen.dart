import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plantarium/features/dashboard/presentation/widgets/app_sidebar.dart';
import 'package:plantarium/features/plant_database/data/models/plant.dto.dart';
import 'package:plantarium/features/plant_database/presentation/providers/plant_database_provider.dart';
import 'package:plantarium/features/plant_database/presentation/widgets/plant_card.dart';
import 'package:plantarium/shared/widgets/app_widgets.dart';

class PlantDatabaseScreen extends StatelessWidget {
  const PlantDatabaseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the provider from context and load plants
    final provider = Provider.of<PlantDatabaseProvider>(context, listen: false);

    // Initialize loading plants
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.loadPlants();
    });

    return const _PlantDatabaseContent();
  }
}

class _PlantDatabaseContent extends StatefulWidget {
  const _PlantDatabaseContent({Key? key}) : super(key: key);

  @override
  State<_PlantDatabaseContent> createState() => _PlantDatabaseContentState();
}

class _PlantDatabaseContentState extends State<_PlantDatabaseContent> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PlantDatabaseProvider>();
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
                Expanded(child: _buildBody(context, provider, theme)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(ThemeData theme) {
    return Container(
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
  }

  Widget _buildBody(
    BuildContext context,
    PlantDatabaseProvider provider,
    ThemeData theme,
  ) {
    if (provider.isLoading) {
      return AppLoadingIndicators.standard(
        message: 'Loading plant database...',
      );
    }

    if (provider.error != null) {
      return AppErrorDisplays.standard(
        errorMessage: provider.error ?? 'Unknown error',
        onRetry: provider.loadPlants,
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Search and filter row
          _buildSearchAndFilterRow(context, provider, theme),
          const SizedBox(height: 16),

          // Category tabs
          _buildCategoryTabs(context, provider, theme),
          const SizedBox(height: 16),

          // Plant grid
          Expanded(
            child:
                provider.plants.isEmpty
                    ? _buildEmptyState(theme)
                    : _buildPlantGrid(context, provider, theme),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilterRow(
    BuildContext context,
    PlantDatabaseProvider provider,
    ThemeData theme,
  ) {
    return Row(
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
                            provider.setSearchQuery('');
                          },
                        )
                        : null,
              ),
              onChanged: (value) {
                provider.setSearchQuery(value);
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
  }

  Widget _buildCategoryTabs(
    BuildContext context,
    PlantDatabaseProvider provider,
    ThemeData theme,
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
            categories.map((category) {
              final isSelected = provider.selectedCategory == category;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      provider.setSelectedCategory(category);
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
                        isSelected ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
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
  }

  Widget _buildPlantGrid(
    BuildContext context,
    PlantDatabaseProvider provider,
    ThemeData theme,
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
      itemCount: provider.plants.length,
      itemBuilder: (context, index) {
        final plant = provider.plants[index];
        return PlantCard(
          plant: plant,
          onToggleFavorite: provider.toggleFavorite,
          onTap: () => _viewPlantDetails(context, plant),
        );
      },
    );
  }

  void _viewPlantDetails(BuildContext context, PlantDTO plant) {
    // This would navigate to a plant details screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing details for ${plant.name}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
