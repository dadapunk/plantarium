import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plantarium/core/config/app_config.dart';
import 'package:plantarium/core/config/app_theme.dart';
import 'package:plantarium/features/garden_notes/presentation/screens/garden_notes_list_screen.dart';
import 'package:plantarium/features/garden_notes/presentation/providers/garden_notes_provider.dart';
import 'package:plantarium/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:plantarium/features/garden_layout/presentation/screens/garden_layout_screen.dart';
import 'package:plantarium/features/plant_database/presentation/screens/plant_database_screen.dart';
import 'package:plantarium/features/plant_database/presentation/providers/plant_database_provider.dart';
import 'package:plantarium/features/planting_calendar/presentation/screens/planting_calendar_screen.dart';
import 'package:plantarium/features/planting_calendar/presentation/providers/planting_calendar_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:plantarium/shared/di/service_locator.dart';
import 'package:plantarium/shared/di/providers_factory.dart';
import 'package:plantarium/shared/services/garden_note_service_interface.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SQLite for desktop platforms
  if (!kIsWeb) {
    // Initialize FFI loader
    sqfliteFfiInit();
    // Change the default factory for desktop
    databaseFactory = databaseFactoryFfi;
  }

  // Initialize environment configuration
  const String envName = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );

  final env = Environment.values.firstWhere(
    (final e) => e.name == envName,
    orElse: () => Environment.development,
  );

  // Initialize configuration asynchronously
  await AppConfig.init(env);

  // Initialize dependency injection
  await initializeDependencies();

  // Run the app with Riverpod
  runApp(const ProviderScope(child: PlantariumApp()));
}

class PlantariumApp extends StatelessWidget {
  const PlantariumApp({super.key});

  @override
  Widget build(final BuildContext context) => MaterialApp(
    title: 'Plantarium',
    themeMode: ThemeMode.dark, // Default to dark theme
    theme: AppTheme.lightTheme(),
    darkTheme: AppTheme.darkTheme(),
    home: const DashboardScreen(),
    routes: {
      '/garden_notes': (context) => const GardenNotesListScreen(),
      '/garden_layout': (context) => const GardenLayoutScreen(),
      '/plant_database': (context) => const PlantDatabaseScreen(),
      '/planting_calendar': (context) => const PlantingCalendarScreen(),
    },
  );
}
