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
        if (oldVersion < 3) {
          await _migrateToV3(db);
        }
        if (oldVersion < 4) {
          await _migrateToV4(db);
        }
        if (oldVersion < 5) {
          await _migrateToV5(db);
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

  static Future<void> _migrateToV3(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${DBConstants.activityLogTable} (
        ${DBConstants.colActivityId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DBConstants.colActivityType} TEXT NOT NULL,
        ${DBConstants.colActivityTitle} TEXT NOT NULL,
        ${DBConstants.colActivitySubtitle} TEXT,
        ${DBConstants.colActivityTimestamp} TEXT NOT NULL
      )
    ''');
  }

  static Future<void> _migrateToV4(Database db) async {
    final tableInfo =
        await db.rawQuery('PRAGMA table_info(${DBConstants.medicinesTable})');
    final existingColumns = tableInfo
        .map((row) => row['name']?.toString())
        .whereType<String>()
        .toSet();

    if (!existingColumns.contains(DBConstants.colPhotoPath)) {
      await db.execute(
        'ALTER TABLE ${DBConstants.medicinesTable} ADD COLUMN ${DBConstants.colPhotoPath} TEXT',
      );
    }
  }

  static Future<void> _migrateToV5(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${DBConstants.ordersTable} (
        ${DBConstants.colOrderId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DBConstants.colOrderSupplierId} INTEGER,
        ${DBConstants.colOrderSupplierName} TEXT NOT NULL,
        ${DBConstants.colOrderStatus} TEXT NOT NULL,
        ${DBConstants.colOrderDate} TEXT NOT NULL,
        ${DBConstants.colOrderNotes} TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${DBConstants.orderItemsTable} (
        ${DBConstants.colOrderItemId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DBConstants.colOrderItemOrderId} INTEGER NOT NULL,
        ${DBConstants.colOrderItemMedicineId} INTEGER,
        ${DBConstants.colOrderItemMedicineName} TEXT NOT NULL,
        ${DBConstants.colOrderItemQuantity} INTEGER NOT NULL,
        ${DBConstants.colOrderItemUnitPrice} REAL NOT NULL,
        FOREIGN KEY (${DBConstants.colOrderItemOrderId})
          REFERENCES ${DBConstants.ordersTable} (${DBConstants.colOrderId})
          ON DELETE CASCADE
      )
    ''');
  }
}
