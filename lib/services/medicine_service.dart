import '../database/db_helper.dart';
import '../models/medicine.dart';

class MedicineService {
  static const String tableName = 'medicines';

  static Future<int> addMedicine(Medicine medicine) async {
    final db = await DBHelper.database;
    final payload = medicine.toMap()..remove('id');
    return await db.insert(tableName, payload);
  }

  static Future<List<Medicine>> getMedicines() async {
    final db = await DBHelper.database;
    final result = await db.query(tableName, orderBy: 'id DESC');
    return result.map((e) => Medicine.fromMap(e)).toList();
  }

  static Future<int> updateMedicine(Medicine medicine) async {
    if (medicine.id == null) return 0;

    final db = await DBHelper.database;
    return await db.update(
      tableName,
      medicine.toMap(),
      where: 'id = ?',
      whereArgs: [medicine.id],
    );
  }

  static Future<int> deleteMedicine(int? id) async {
    if (id == null) return 0;

    final db = await DBHelper.database;
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
