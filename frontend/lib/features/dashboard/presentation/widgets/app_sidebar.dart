import 'package:flutter/material.dart';

class AppSidebar extends StatelessWidget {
  final int selectedIndex;

  const AppSidebar({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 240,
      color: const Color(0xFF1E1E1E), // Dark sidebar background
      child: Column(
        children: [
          // App title with close button
          _buildHeader(theme),

          // Navigation menu items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildNavItem(
                  context: context,
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                  isSelected: selectedIndex == 0,
                  onTap: () {
                    if (selectedIndex != 0) {
                      Navigator.pushReplacementNamed(context, '/');
                    }
                  },
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.grid_on,
                  title: 'Garden Layout',
                  isSelected: selectedIndex == 1,
                  onTap: () {
                    if (selectedIndex != 1) {
                      Navigator.pushReplacementNamed(context, '/garden_layout');
                    }
                  },
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.local_florist,
                  title: 'Plant Database',
                  isSelected: selectedIndex == 2,
                  onTap: () {
                    if (selectedIndex != 2) {
                      Navigator.pushReplacementNamed(
                        context,
                        '/plant_database',
                      );
                    }
                  },
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.calendar_today,
                  title: 'Planting Calendar',
                  isSelected: selectedIndex == 3,
                  onTap: () {
                    if (selectedIndex != 3) {
                      Navigator.pushReplacementNamed(
                        context,
                        '/planting_calendar',
                      );
                    }
                  },
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.notifications,
                  title: 'Notifications',
                  isSelected: selectedIndex == 4,
                  onTap: () {
                    // Navigate to notifications
                  },
                  badgeCount: 3,
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.autorenew,
                  title: 'Crop Rotation',
                  isSelected: selectedIndex == 5,
                  onTap: () {
                    // Navigate to crop rotation
                  },
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.wb_sunny,
                  title: 'Weather',
                  isSelected: selectedIndex == 6,
                  onTap: () {
                    // Navigate to weather
                  },
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.note,
                  title: 'Garden Notes',
                  isSelected: selectedIndex == 7,
                  onTap: () {
                    if (selectedIndex != 7) {
                      Navigator.pushReplacementNamed(context, '/garden_notes');
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        border: Border(
          bottom: BorderSide(color: Colors.black.withOpacity(0.2), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Plantarium',
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white54),
            onPressed: () {},
            tooltip: 'Collapse sidebar',
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    int? badgeCount,
  }) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(top: 2.0, bottom: 2.0),
      decoration: BoxDecoration(
        color:
            isSelected
                ? theme.primaryColor.withOpacity(0.15)
                : Colors.transparent,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? theme.primaryColor : Colors.white70,
          size: 20,
        ),
        title: Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isSelected ? theme.primaryColor : Colors.white,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
        trailing:
            badgeCount != null
                ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badgeCount.toString(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
                : null,
        onTap: onTap,
        dense: true,
        visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
        selected: isSelected,
        selectedTileColor: theme.primaryColor.withOpacity(0.15),
      ),
    );
  }
}
