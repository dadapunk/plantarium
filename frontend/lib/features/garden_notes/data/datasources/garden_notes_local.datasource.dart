import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:plantarium/features/garden_notes/data/models/garden_note.dto.dart';

/// Abstract class defining the local datasource interface for Garden Notes
abstract class GardenNotesLocalDatasource {
  /// Get all cached garden notes
  Future<List<GardenNoteDTO>> getCachedNotes();

  /// Cache a list of garden notes
  Future<void> cacheNotes(List<GardenNoteDTO> notes);

  /// Clear the cache
  Future<void> clearCache();
}

/// Implementation of the Garden Notes local datasource
class GardenNotesLocalDatasourceImpl implements GardenNotesLocalDatasource {
  static Database? _database;
  static const String _tableName = 'garden_notes';

  /// Get the database instance
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
    return await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (Database db, int version) async {
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
  Future<void> cacheNotes(List<GardenNoteDTO> notes) async {
    final db = await database;
    await db.transaction((txn) async {
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
  }

  @override
  Future<List<GardenNoteDTO>> getCachedNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) {
      return GardenNoteDTO(
        id: maps[i]['id'] as int,
        title: maps[i]['title'] as String,
        note: maps[i]['note'] as String,
        date: DateTime.parse(maps[i]['date'] as String),
      );
    });
  }

  @override
  Future<void> clearCache() async {
    final db = await database;
    await db.delete(_tableName);
  }
}
