import '../models/medicine.dart';

class InventoryService {
  static const List<String> categories = [
    'Painkillers',
    'Antibiotics',
    'Supplements',
    'Diabetes Care',
    'Cardiovascular',
    'Respiratory',
    'First Aid',
    'Other',
  ];

  final List<Medicine> _medicines = [
    Medicine(
      id: '1',
      name: 'Paracetamol 500mg',
      barcode: '6001234567890',
      category: 'Painkillers',
      supplierId: 'sup-1',
      quantity: 120,
      minimumStock: 30,
      expiryDate: DateTime.now().add(const Duration(days: 240)),
      unitPrice: 2.50,
      description: 'Pain and fever relief tablets.',
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
    ),
    Medicine(
      id: '2',
      name: 'Amoxicillin 250mg',
      barcode: '6009876543210',
      category: 'Antibiotics',
      supplierId: 'sup-2',
      quantity: 18,
      minimumStock: 25,
      expiryDate: DateTime.now().add(const Duration(days: 15)),
      unitPrice: 8.75,
      description: 'Broad-spectrum antibiotic capsules.',
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
    ),
    Medicine(
      id: '3',
      name: 'Vitamin C 1000mg',
      barcode: '6005556667778',
      category: 'Supplements',
      supplierId: 'sup-1',
      quantity: 200,
      minimumStock: 40,
      expiryDate: DateTime.now().add(const Duration(days: 400)),
      unitPrice: 3.20,
      description: 'Immune support effervescent tablets.',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    Medicine(
      id: '4',
      name: 'Insulin Glargine',
      barcode: '6001112223334',
      category: 'Diabetes Care',
      supplierId: 'sup-3',
      quantity: 5,
      minimumStock: 10,
      expiryDate: DateTime.now().subtract(const Duration(days: 2)),
      unitPrice: 45.00,
      description: 'Long-acting insulin injection pen.',
      createdAt: DateTime.now().subtract(const Duration(days: 120)),
    ),
  ];

  static const _simulatedDelay = Duration(milliseconds: 400);

  Future<List<Medicine>> fetchAll() async {
    await Future.delayed(_simulatedDelay);
    return List.unmodifiable(_medicines);
  }

  Future<void> add(Medicine medicine) async {
    await Future.delayed(_simulatedDelay);
    _medicines.add(medicine);
  }

  Future<void> update(Medicine medicine) async {
    await Future.delayed(_simulatedDelay);
    final index = _medicines.indexWhere((m) => m.id == medicine.id);
    if (index == -1) return;
    _medicines[index] = medicine;
  }

  Future<void> delete(String id) async {
    await Future.delayed(_simulatedDelay);
    _medicines.removeWhere((m) => m.id == id);
  }
}
