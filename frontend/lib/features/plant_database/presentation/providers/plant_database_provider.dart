import 'package:flutter/material.dart';
import 'package:plantarium/features/plant_database/data/models/plant.dto.dart';

class PlantDatabaseProvider extends ChangeNotifier {
  List<PlantDTO> _plants = [];
  String _searchQuery = '';
  String _selectedCategory = 'All Plants';
  bool _isLoading = false;
  String? _error;

  // Getters
  List<PlantDTO> get plants => _filterPlants();
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Filter plants based on search query and selected category
  List<PlantDTO> _filterPlants() {
    return _plants.where((plant) {
      // Filter by category
      if (_selectedCategory != 'All Plants' &&
          _selectedCategory != 'Favorites' &&
          plant.category != _selectedCategory) {
        return false;
      }

      // Filter favorites
      if (_selectedCategory == 'Favorites' && !plant.isFavorite) {
        return false;
      }

      // Filter by search query
      if (_searchQuery.isNotEmpty) {
        return plant.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            plant.scientificName.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            );
      }

      return true;
    }).toList();
  }

  // Set search query
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Set selected category
  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Toggle favorite status for a plant
  void toggleFavorite(String plantId) {
    final index = _plants.indexWhere((plant) => plant.id == plantId);
    if (index != -1) {
      _plants[index] = _plants[index].copyWith(
        isFavorite: !_plants[index].isFavorite,
      );
      notifyListeners();
    }
  }

  // Load plants from mock data
  Future<void> loadPlants() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // In a real app, this would be an API call or database query
      await Future.delayed(const Duration(milliseconds: 800));
      _plants = _getMockPlants();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  // Mock data for initial development
  List<PlantDTO> _getMockPlants() {
    return [
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
}
