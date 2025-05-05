import 'package:flutter/material.dart';
import 'package:plantarium/features/plant_database/data/models/plant.dto.dart';

class PlantCard extends StatelessWidget {
  final PlantDTO plant;
  final Function(String) onToggleFavorite;
  final VoidCallback? onTap;

  const PlantCard({
    Key? key,
    required this.plant,
    required this.onToggleFavorite,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Plant image with favorite button
            Stack(
              children: [
                // Plant image (placeholder for now)
                AspectRatio(
                  aspectRatio: 1.5,
                  child: Container(
                    color: Colors.grey[800],
                    child: const Center(
                      child: Icon(Icons.image, size: 40, color: Colors.white54),
                    ),
                  ),
                ),

                // Favorite button
                Positioned(
                  top: 8,
                  right: 8,
                  child: InkWell(
                    onTap: () => onToggleFavorite(plant.id),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        plant.isFavorite ? Icons.star : Icons.star_border,
                        color: plant.isFavorite ? Colors.amber : Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),

                // Difficulty label
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getDifficultyColor(plant.growthDifficulty),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.eco, color: Colors.white, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          plant.growthDifficulty,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Plant info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Plant name
                  Text(
                    plant.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Scientific name
                  Text(
                    plant.scientificName,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Tags
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children:
                        plant.tags.map((tag) => _buildTag(tag, theme)).toList(),
                  ),

                  const SizedBox(height: 8),

                  // Season
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Season: ${plant.growingSeason}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String tag, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.cardColor.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Text(tag, style: theme.textTheme.bodySmall),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Easy':
        return Colors.green;
      case 'Moderate':
        return Colors.orange;
      case 'Difficult':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}
