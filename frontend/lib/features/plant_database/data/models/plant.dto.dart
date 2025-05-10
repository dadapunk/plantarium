class PlantDTO {
  PlantDTO({
    required this.id,
    required this.name,
    required this.scientificName,
    required this.category,
    required this.growthDifficulty,
    required this.tags,
    required this.description,
    required this.imagePath,
    required this.growingSeason,
    this.isFavorite = false,
  });
  final String id;
  final String name;
  final String scientificName;
  final String category;
  final String growthDifficulty;
  final List<String> tags;
  final String description;
  final String imagePath;
  final String growingSeason;
  final bool isFavorite;

  // Create a copy of the current plant with modified properties
  PlantDTO copyWith({
    final String? id,
    final String? name,
    final String? scientificName,
    final String? category,
    final String? growthDifficulty,
    final List<String>? tags,
    final String? description,
    final String? imagePath,
    final String? growingSeason,
    final bool? isFavorite,
  }) => PlantDTO(
    id: id ?? this.id,
    name: name ?? this.name,
    scientificName: scientificName ?? this.scientificName,
    category: category ?? this.category,
    growthDifficulty: growthDifficulty ?? this.growthDifficulty,
    tags: tags ?? this.tags,
    description: description ?? this.description,
    imagePath: imagePath ?? this.imagePath,
    growingSeason: growingSeason ?? this.growingSeason,
    isFavorite: isFavorite ?? this.isFavorite,
  );
}
