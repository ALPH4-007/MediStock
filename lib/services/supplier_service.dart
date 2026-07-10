import '../database/db_helper.dart';
import '../database/db_constants.dart';
import '../models/supplier.dart';

class SupplierService {
  Future<List<Supplier>> fetchAll() async {
    final db = await DBHelper.database;
    final result = await db.query(DBConstants.suppliersTable, orderBy: 'id DESC');
    
    if (result.isEmpty) {
      await _seedInitialData();
      return fetchAll();
    }
    
    return result.map((e) => Supplier.fromMap(e)).toList();
  }

  Future<void> _seedInitialData() async {
    final db = await DBHelper.database;
    final initialSuppliers = [
      Supplier(
        name: 'PharmaCorp Ghana',
        contactPerson: 'Kwame Mensah',
        phone: '+233 24 123 4567',
        email: 'orders@pharmacorp.gh',
        address: 'Spintex Road, Accra',
        createdAt: DateTime.now().subtract(const Duration(days: 200)),
      ),
      Supplier(
        name: 'MedSupply Ltd',
        contactPerson: 'Ama Owusu',
        phone: '+233 20 987 6543',
        email: 'contact@medsupply.com',
        address: 'Kumasi Industrial Area',
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
      ),
      Supplier(
        name: 'Accra Pharma Distributors',
        contactPerson: 'John Tetteh',
        phone: '+233 26 555 1122',
        address: 'Tema Community 5',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
    ];

    for (var supplier in initialSuppliers) {
      await add(supplier);
    }
  }

  Future<void> add(Supplier supplier) async {
    final db = await DBHelper.database;
    final payload = supplier.toMap()..remove('id');
    await db.insert(DBConstants.suppliersTable, payload);
  }

  Future<void> update(Supplier supplier) async {
    if (supplier.id == null) return;
    final db = await DBHelper.database;
    await db.update(
      DBConstants.suppliersTable,
      supplier.toMap(),
      where: 'id = ?',
      whereArgs: [supplier.id],
    );
  }

  Future<void> delete(int? id) async {
    if (id == null) return;
    final db = await DBHelper.database;
    await db.delete(
      DBConstants.suppliersTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
