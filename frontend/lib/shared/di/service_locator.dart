import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:plantarium/core/config/app_config.dart';
import 'package:plantarium/core/services/garden_note.service.dart';
import 'package:plantarium/core/services/garden_note_cache.service.dart';
import 'package:plantarium/shared/services/garden_note_cache_service_interface.dart';
import 'package:plantarium/shared/services/garden_note_service_interface.dart';
import 'package:plantarium/shared/di/riverpod_providers.dart';

/// Global ServiceLocator instance
final sl = GetIt.instance;

/// Access the GetIt instance
GetIt get getIt => sl;

/// Initialize the dependency injection container
Future<void> initializeDependencies() async {
  // Register App Config
  sl.registerSingleton<AppConfig>(AppConfig.current);

  // Register Dio
  sl.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: sl<AppConfig>().apiBaseUrl,
        connectTimeout: sl<AppConfig>().timeoutDuration,
        receiveTimeout: sl<AppConfig>().timeoutDuration,
      ),
    ),
  );

  // Register Services
  sl.registerLazySingleton<IGardenNoteService>(
    () =>
        GardenNoteService(dio: sl<Dio>(), baseUrl: sl<AppConfig>().apiBaseUrl),
  );

  sl.registerLazySingleton<IGardenNoteCacheService>(GardenNoteCacheService.new);

  // Register Riverpod dependencies
  registerRiverpodDependencies(sl);
}
