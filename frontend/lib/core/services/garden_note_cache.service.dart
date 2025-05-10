import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:plantarium/features/garden_notes/data/models/garden_note.dto.dart';
import 'package:plantarium/shared/services/garden_note_cache_service_interface.dart';

class GardenNoteCacheService implements IGardenNoteCacheService {
  static Database? _database;
  static const String _tableName = 'garden_notes';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databaseFactory = databaseFactoryFfi;
    final path = join(
      await databaseFactory.getDatabasesPath(),
      'plantarium.db',
    );
    return databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE $_tableName(
              id INTEGER PRIMARY KEY,
              title TEXT NOT NULL,
              note TEXT NOT NULL,
              date TEXT NOT NULL
            )
          ''');
        },
      ),
    );
  }

  @override
  void log(final String message) {
    if (kDebugMode) {
      print('GardenNoteCacheService: $message');
    }
  }

  @override
  Object handleError(final Object error, final String operation) {
    log('Error $operation: $error');
    return Exception('Failed to $operation: $error');
  }

  @override
  Future<void> cacheNotes(final List<GardenNoteDTO> notes) async {
    log('Caching ${notes.length} garden notes');
    try {
      final db = await database;
      await db.transaction((final txn) async {
        await txn.delete(_tableName);
        for (final note in notes) {
          await txn.insert(_tableName, {
            'id': note.id,
            'title': note.title,
            'note': note.note,
            'date': note.date.toIso8601String(),
          });
        }
      });
      log('Successfully cached ${notes.length} garden notes');
    } catch (e) {
      throw handleError(e, 'cache garden notes');
    }
  }

  @override
  Future<List<GardenNoteDTO>> getCachedNotes() async {
    log('Retrieving cached garden notes');
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(_tableName);
      final notes = List.generate(
        maps.length,
        (final i) => GardenNoteDTO(
          id: maps[i]['id'] as int,
          title: maps[i]['title'] as String,
          note: maps[i]['note'] as String,
          date: DateTime.parse(maps[i]['date'] as String),
        ),
      );
      log('Retrieved ${notes.length} cached garden notes');
      return notes;
    } catch (e) {
      throw handleError(e, 'retrieve cached garden notes');
    }
  }

  @override
  Future<void> clearCache() async {
    log('Clearing garden notes cache');
    try {
      final db = await database;
      await db.delete(_tableName);
      log('Garden notes cache cleared successfully');
    } catch (e) {
      throw handleError(e, 'clear garden notes cache');
    }
  }
}
