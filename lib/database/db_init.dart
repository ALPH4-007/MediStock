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
        ${DBConstants.colCreatedAt} TEXT,
        ${DBConstants.colPhotoPath} TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${DBConstants.activityLogTable} (
        ${DBConstants.colActivityId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DBConstants.colActivityType} TEXT NOT NULL,
        ${DBConstants.colActivityTitle} TEXT NOT NULL,
        ${DBConstants.colActivitySubtitle} TEXT,
        ${DBConstants.colActivityTimestamp} TEXT NOT NULL
      )
    ''');

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
