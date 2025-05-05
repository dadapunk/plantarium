import 'package:flutter/material.dart';
import 'package:plantarium/features/garden_layout/presentation/widgets/plant_plot.dart';

class GardenGrid extends StatelessWidget {
  const GardenGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Mock data for garden layout - would come from a provider in a real app
    // 0 = empty, 1 = tomato, 2 = lettuce, 3 = pepper
    final gardenGrid = [
      [1, 0, 0, 2, 0, 0],
      [2, 1, 0, 0, 0, 3],
      [2, 0, 0, 1, 0, 0],
      [2, 0, 3, 0, 0, 0],
      [2, 0, 0, 3, 0, 0],
      [0, 0, 0, 0, 0, 2],
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final gridSize = gardenGrid.length;
                final cellWidth = constraints.maxWidth / gridSize;
                final cellHeight = constraints.maxHeight / gridSize;

                return Stack(
                  children: [
                    // Background grid
                    Container(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        border: Border.all(color: theme.dividerColor, width: 1),
                      ),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: gridSize,
                        ),
                        itemCount: gridSize * gridSize,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: theme.dividerColor,
                                width: 0.5,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Plant plots
                    ...List.generate(gardenGrid.length, (row) {
                      return List.generate(gardenGrid[row].length, (col) {
                        final plantType = gardenGrid[row][col];
                        if (plantType == 0) {
                          return const SizedBox.shrink(); // Empty plot
                        }

                        String plantName;
                        Color color;

                        switch (plantType) {
                          case 1: // Tomato
                            plantName = 'Tomato';
                            color = const Color(0xFF1F5324);
                            break;
                          case 2: // Lettuce
                            plantName = 'Lettuce';
                            color = const Color(0xFF5F6D13);
                            break;
                          case 3: // Pepper
                            plantName = 'Pepper';
                            color = const Color(0xFF80303A);
                            break;
                          default:
                            plantName = 'Unknown';
                            color = Colors.grey;
                        }

                        return Positioned(
                          left: col * cellWidth,
                          top: row * cellHeight,
                          width: cellWidth,
                          height: cellHeight,
                          child: PlantPlot(name: plantName, color: color),
                        );
                      });
                    }).expand((list) => list).toList(),
                  ],
                );
              },
            ),
          ),

          // Plant legend at the bottom
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem('Tomato', const Color(0xFF1F5324), theme),
                const SizedBox(width: 24),
                _buildLegendItem('Lettuce', const Color(0xFF5F6D13), theme),
                const SizedBox(width: 24),
                _buildLegendItem('Pepper', const Color(0xFF80303A), theme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String name, Color color, ThemeData theme) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(name, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}
