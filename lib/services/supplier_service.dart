import '../models/supplier.dart';

/// Mock data source, same pattern as InventoryService — same method names
/// and async signatures a real SQLite-backed version would have, so
/// swapping the implementation later only touches this file.
class SupplierService {
  final List<Supplier> _suppliers = [
    Supplier(
      id: 1,
      name: 'PharmaCorp Ghana',
      contactPerson: 'Kwame Mensah',
      phone: '+233 24 123 4567',
      email: 'orders@pharmacorp.gh',
      address: 'Spintex Road, Accra',
      createdAt: DateTime.now().subtract(const Duration(days: 200)),
    ),
    Supplier(
      id: 2,
      name: 'MedSupply Ltd',
      contactPerson: 'Ama Owusu',
      phone: '+233 20 987 6543',
      email: 'contact@medsupply.com',
      address: 'Kumasi Industrial Area',
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
    ),
    Supplier(
      id: 3,
      name: 'Accra Pharma Distributors',
      contactPerson: 'John Tetteh',
      phone: '+233 26 555 1122',
      address: 'Tema Community 5',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
  ];

  static const _simulatedDelay = Duration(milliseconds: 400);

  Future<List<Supplier>> fetchAll() async {
    await Future.delayed(_simulatedDelay);
    return List.unmodifiable(_suppliers);
  }

  Future<void> add(Supplier supplier) async {
    await Future.delayed(_simulatedDelay);
    final nextId = _suppliers.isEmpty
        ? 1
        : (_suppliers.map((s) => s.id ?? 0).reduce((a, b) => a > b ? a : b) +
            1);
    _suppliers.add(supplier.copyWith(id: supplier.id ?? nextId));
  }

  Future<void> update(Supplier supplier) async {
    await Future.delayed(_simulatedDelay);
    final index = _suppliers.indexWhere((s) => s.id == supplier.id);
    if (index == -1) return;
    _suppliers[index] = supplier;
  }

  Future<void> delete(int? id) async {
    await Future.delayed(_simulatedDelay);
    _suppliers.removeWhere((s) => s.id == id);
  }
}
