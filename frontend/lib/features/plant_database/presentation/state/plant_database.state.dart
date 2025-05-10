import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:plantarium/features/plant_database/data/models/plant.dto.dart';

part 'plant_database.state.freezed.dart';

/// State for plant database
@freezed
class PlantDatabaseState with _$PlantDatabaseState {
  /// Private constructor required by freezed
  const PlantDatabaseState._();

  /// Initial state
  const factory PlantDatabaseState.initial() = _Initial;

  /// Loading state
  const factory PlantDatabaseState.loading() = _Loading;

  /// Success state with loaded plants
  const factory PlantDatabaseState.success({
    required final List<PlantDTO> plants,
    required final String selectedCategory,
    required final String searchQuery,
  }) = _Success;

  /// Error state
  const factory PlantDatabaseState.error({required final String message}) =
      _Error;

  /// Helper to check if the state is in loading state
  bool get isLoading => maybeMap(loading: (_) => true, orElse: () => false);

  /// Helper to check if the state contains an error
  bool get hasError => maybeMap(error: (_) => true, orElse: () => false);

  /// Helper to get all plants
  List<PlantDTO> get allPlants =>
      maybeMap(success: (state) => state.plants, orElse: () => []);

  /// Helper to get the filtered plants based on category and search query
  List<PlantDTO> get filteredPlants => maybeMap(
    success: (state) {
      final query = state.searchQuery.toLowerCase();
      return state.plants.where((plant) {
        // Filter by category
        if (state.selectedCategory != 'All Plants' &&
            state.selectedCategory != 'Favorites' &&
            plant.category != state.selectedCategory) {
          return false;
        }

        // Filter favorites
        if (state.selectedCategory == 'Favorites' && !plant.isFavorite) {
          return false;
        }

        // Filter by search query
        if (query.isNotEmpty) {
          return plant.name.toLowerCase().contains(query) ||
              plant.scientificName.toLowerCase().contains(query);
        }

        return true;
      }).toList();
    },
    orElse: () => [],
  );

  /// Helper to get the selected category
  String get selectedCategory => maybeMap(
    success: (state) => state.selectedCategory,
    orElse: () => 'All Plants',
  );

  /// Helper to get the search query
  String get searchQuery =>
      maybeMap(success: (state) => state.searchQuery, orElse: () => '');

  /// Helper to get the error message
  String? get errorMessage =>
      maybeMap(error: (state) => state.message, orElse: () => null);
}
