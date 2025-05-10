import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:plantarium/core/config/app_config.dart';
import 'package:plantarium/features/garden_notes/domain/repositories/garden_notes.repository.dart';
import 'package:plantarium/features/garden_notes/data/repositories/garden_notes.repository_impl.dart';
import 'package:plantarium/features/garden_notes/data/datasources/garden_notes_api.datasource.dart';
import 'package:plantarium/features/garden_notes/data/datasources/garden_notes_local.datasource.dart';
import 'package:plantarium/features/garden_notes/domain/usecases/get_all_notes.usecase.dart';
import 'package:plantarium/features/garden_notes/domain/usecases/get_note_by_id.usecase.dart';
import 'package:plantarium/features/garden_notes/domain/usecases/create_note.usecase.dart';
import 'package:plantarium/features/garden_notes/domain/usecases/update_note.usecase.dart';
import 'package:plantarium/features/garden_notes/domain/usecases/delete_note.usecase.dart';
import 'package:plantarium/shared/services/garden_note_service_interface.dart';
import 'package:plantarium/shared/services/garden_note_cache_service_interface.dart';

/// Register Riverpod dependencies in GetIt
void registerRiverpodDependencies(final GetIt sl) {
  // Data Sources
  sl.registerLazySingleton<GardenNotesApiDatasource>(
    () => RetrofitGardenNotesApiDatasource.create(
      dio: sl<Dio>(),
      baseUrl: sl<AppConfig>().apiBaseUrl,
    ),
  );

  sl.registerLazySingleton<GardenNotesLocalDatasource>(
    GardenNotesLocalDatasourceImpl.new,
  );

  // Repositories
  sl.registerLazySingleton<GardenNotesRepository>(
    () => GardenNotesRepositoryImpl(
      apiDatasource: sl<GardenNotesApiDatasource>(),
      localDatasource: sl<GardenNotesLocalDatasource>(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton<GetAllNotesUseCase>(
    () => GetAllNotesUseCase(sl<GardenNotesRepository>()),
  );

  sl.registerLazySingleton<GetNoteByIdUseCase>(
    () => GetNoteByIdUseCase(sl<GardenNotesRepository>()),
  );

  sl.registerLazySingleton<CreateNoteUseCase>(
    () => CreateNoteUseCase(sl<GardenNotesRepository>()),
  );

  sl.registerLazySingleton<UpdateNoteUseCase>(
    () => UpdateNoteUseCase(sl<GardenNotesRepository>()),
  );

  sl.registerLazySingleton<DeleteNoteUseCase>(
    () => DeleteNoteUseCase(sl<GardenNotesRepository>()),
  );
}
