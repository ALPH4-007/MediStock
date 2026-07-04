import 'package:flutter/foundation.dart';
import '../models/medicine.dart';

class InventoryProvider extends ChangeNotifier {
  final List<Medicine> _medicines = [];

  List<Medicine> get medicines => List.unmodifiable(_medicines);

  int get itemCount => _medicines.length;

  void addMedicine(Medicine medicine) {
    _medicines.add(medicine);
    notifyListeners();
  }

  void removeMedicine(String id) {
    _medicines.removeWhere((m) => m.id == id);
    notifyListeners();
  }

  void updateQuantity(String id, int newQuantity) {
    final index = _medicines.indexWhere((m) => m.id == id);
    if (index == -1) return;

    _medicines[index] = _medicines[index].copyWith(quantity: newQuantity);
    notifyListeners();
  }

  Medicine? findById(String id) {
    try {
      return _medicines.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }
}
