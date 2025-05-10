import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plantarium/features/plant_database/presentation/state/plant_database.notifier.dart';
import 'package:plantarium/features/plant_database/presentation/state/plant_database.state.dart';

/// Provider for plant database
final plantDatabaseProvider =
    StateNotifierProvider<PlantDatabaseNotifier, PlantDatabaseState>(
      (ref) => PlantDatabaseNotifier(),
    );
