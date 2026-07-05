import 'package:sqflite/sqflite.dart';

import 'db_constants.dart';

class DBInit {
  static Future<void> createTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${DBConstants.medicinesTable} (
        ${DBConstants.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DBConstants.colName} TEXT NOT NULL,
        ${DBConstants.colBarcode} TEXT,
        ${DBConstants.colBatchNumber} TEXT,
        ${DBConstants.colManufacturer} TEXT,
        ${DBConstants.colCategory} TEXT,
        ${DBConstants.colQuantity} INTEGER,
        ${DBConstants.colMinimumStock} INTEGER,
        ${DBConstants.colExpiryDate} TEXT,
        ${DBConstants.colPurchasePrice} REAL,
        ${DBConstants.colSellingPrice} REAL,
        ${DBConstants.colSupplierId} INTEGER,
        ${DBConstants.colLocation} TEXT,
        ${DBConstants.colDescription} TEXT,
        ${DBConstants.colCreatedAt} TEXT
      )
    ''');
  }
}
