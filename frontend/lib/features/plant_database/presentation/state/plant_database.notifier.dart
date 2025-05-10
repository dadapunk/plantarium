import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plantarium/features/plant_database/data/models/plant.dto.dart';
import 'package:plantarium/features/plant_database/presentation/state/plant_database.state.dart';

/// Notifier for plant database
class PlantDatabaseNotifier extends StateNotifier<PlantDatabaseState> {
  /// Constructor
  PlantDatabaseNotifier() : super(const PlantDatabaseState.initial());

  /// Load plants
  Future<void> loadPlants() async {
    state = const PlantDatabaseState.loading();

    try {
      // In a real app, this would call a repository or use case
      await Future.delayed(const Duration(milliseconds: 800));
      final plants = _getMockPlants();

      state = PlantDatabaseState.success(
        plants: plants,
        selectedCategory: 'All Plants',
        searchQuery: '',
      );
    } catch (e) {
      state = PlantDatabaseState.error(message: e.toString());
    }
  }

  /// Set search query
  void setSearchQuery(final String query) {
    state.maybeMap(
      success: (success) {
        state = PlantDatabaseState.success(
          plants: success.plants,
          selectedCategory: success.selectedCategory,
          searchQuery: query,
        );
      },
      orElse: () {},
    );
  }

  /// Set selected category
  void setSelectedCategory(final String category) {
    state.maybeMap(
      success: (success) {
        state = PlantDatabaseState.success(
          plants: success.plants,
          selectedCategory: category,
          searchQuery: success.searchQuery,
        );
      },
      orElse: () {},
    );
  }

  /// Toggle favorite status for a plant
  void toggleFavorite(final String plantId) {
    state.maybeMap(
      success: (success) {
        final updatedPlants =
            success.plants.map((plant) {
              if (plant.id == plantId) {
                return plant.copyWith(isFavorite: !plant.isFavorite);
              }
              return plant;
            }).toList();

        state = PlantDatabaseState.success(
          plants: updatedPlants,
          selectedCategory: success.selectedCategory,
          searchQuery: success.searchQuery,
        );
      },
      orElse: () {},
    );
  }

  /// Clear any error state
  void clearError() {
    state.maybeMap(
      error: (_) {
        state = const PlantDatabaseState.initial();
      },
      orElse: () {},
    );
  }

  // Mock data for initial development
  List<PlantDTO> _getMockPlants() => [
    PlantDTO(
      id: '1',
      name: 'Tomato',
      scientificName: 'Solanum lycopersicum',
      category: 'Vegetables',
      growthDifficulty: 'Easy',
      tags: ['Vegetable', 'Annual', 'Fruit-bearing'],
      description:
          'Tomatoes are the most popular garden vegetable crop. They are warm-season plants that grow best in full sun and well-drained soil.',
      imagePath: 'assets/images/plants/tomato.jpg',
      growingSeason: 'Spring to Fall',
    ),
    PlantDTO(
      id: '2',
      name: 'Basil',
      scientificName: 'Ocimum basilicum',
      category: 'Herbs',
      growthDifficulty: 'Easy',
      tags: ['Herb', 'Annual', 'Aromatic'],
      description:
          'Basil is a tender herb with a sweet, aromatic flavor. It\'s a popular culinary herb used in many cuisines, especially Italian dishes.',
      imagePath: 'assets/images/plants/basil.jpg',
      growingSeason: 'Spring to Summer',
    ),
    PlantDTO(
      id: '3',
      name: 'Carrot',
      scientificName: 'Daucus carota',
      category: 'Vegetables',
      growthDifficulty: 'Moderate',
      tags: ['Vegetable', 'Root', 'Biennial'],
      description:
          'Carrots are root vegetables that are easy to grow in loose, sandy soil. They\'re rich in beta-carotene and other nutrients.',
      imagePath: 'assets/images/plants/carrot.jpg',
      growingSeason: 'Spring to Fall',
    ),
    PlantDTO(
      id: '4',
      name: 'Lettuce',
      scientificName: 'Lactuca sativa',
      category: 'Vegetables',
      growthDifficulty: 'Easy',
      tags: ['Vegetable', 'Leafy', 'Annual'],
      description:
          'Lettuce is a cool-season crop that grows quickly and is perfect for beginners. It prefers cooler temperatures and partial shade in hot climates.',
      imagePath: 'assets/images/plants/lettuce.jpg',
      growingSeason: 'Spring to Fall',
    ),
    PlantDTO(
      id: '5',
      name: 'Lavender',
      scientificName: 'Lavandula',
      category: 'Herbs',
      growthDifficulty: 'Moderate',
      tags: ['Herb', 'Perennial', 'Aromatic'],
      description:
          'Lavender is a popular herb known for its fragrant flowers and gray-green foliage. It prefers well-drained soil and full sun.',
      imagePath: 'assets/images/plants/lavender.jpg',
      growingSeason: 'Spring to Summer',
    ),
    PlantDTO(
      id: '6',
      name: 'Sunflower',
      scientificName: 'Helianthus annuus',
      category: 'Flowers',
      growthDifficulty: 'Easy',
      tags: ['Flower', 'Annual', 'Tall'],
      description:
          'Sunflowers are tall, bright flowers that follow the sun. They\'re easy to grow and attract beneficial insects and birds.',
      imagePath: 'assets/images/plants/sunflower.jpg',
      growingSeason: 'Summer',
    ),
    PlantDTO(
      id: '7',
      name: 'Cucumber',
      scientificName: 'Cucumis sativus',
      category: 'Vegetables',
      growthDifficulty: 'Moderate',
      tags: ['Vegetable', 'Annual', 'Vine'],
      description:
          'Cucumbers are vine crops that produce well in warm weather. They need consistent moisture and plenty of space to grow.',
      imagePath: 'assets/images/plants/cucumber.jpg',
      growingSeason: 'Summer',
    ),
    PlantDTO(
      id: '8',
      name: 'Rosemary',
      scientificName: 'Salvia rosmarinus',
      category: 'Herbs',
      growthDifficulty: 'Moderate',
      tags: ['Herb', 'Perennial', 'Evergreen'],
      description:
          'Rosemary is a woody herb with fragrant, evergreen, needle-like leaves. It is drought-tolerant once established.',
      imagePath: 'assets/images/plants/rosemary.jpg',
      growingSeason: 'Year-round',
    ),
    PlantDTO(
      id: '9',
      name: 'Marigold',
      scientificName: 'Tagetes',
      category: 'Flowers',
      growthDifficulty: 'Easy',
      tags: ['Flower', 'Annual', 'Pest-repellent'],
      description:
          'Marigolds are easy-to-grow annual flowers with distinctive blooms in gold, copper, and brass. They help repel garden pests.',
      imagePath: 'assets/images/plants/marigold.jpg',
      growingSeason: 'Spring to Fall',
    ),
  ];
}
