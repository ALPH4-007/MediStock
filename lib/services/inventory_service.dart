import '../models/medicine.dart';
import 'medicine_service.dart';

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

  Future<List<Medicine>> fetchAll() async {
    return MedicineService.getMedicines();
  }

  Future<void> add(Medicine medicine) async {
    await MedicineService.addMedicine(medicine);
  }

  Future<void> update(Medicine medicine) async {
    await MedicineService.updateMedicine(medicine);
  }

  Future<void> delete(int? id) async {
    await MedicineService.deleteMedicine(id);
  }
}
