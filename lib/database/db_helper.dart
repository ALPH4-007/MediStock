import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'db_constants.dart';
import 'db_init.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  static Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), DBConstants.dbName);

    return openDatabase(
      path,
      version: DBConstants.dbVersion,
      onCreate: (db, version) async {
        await DBInit.createTables(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await _migrateToV2(db);
        }
      },
      onOpen: (db) async {
        await DBInit.createTables(db);
      },
    );
  }

  static Future<void> _migrateToV2(Database db) async {
    final tableInfo =
        await db.rawQuery('PRAGMA table_info(${DBConstants.medicinesTable})');
    final existingColumns = tableInfo
        .map((row) => row['name']?.toString())
        .whereType<String>()
        .toSet();

    if (!existingColumns.contains(DBConstants.colDescription)) {
      await db.execute(
        'ALTER TABLE ${DBConstants.medicinesTable} ADD COLUMN ${DBConstants.colDescription} TEXT',
      );
    }

    if (!existingColumns.contains(DBConstants.colCreatedAt)) {
      await db.execute(
        'ALTER TABLE ${DBConstants.medicinesTable} ADD COLUMN ${DBConstants.colCreatedAt} TEXT',
      );
    }
  }
}
