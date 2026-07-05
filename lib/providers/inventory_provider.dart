import 'package:flutter/foundation.dart';

import '../models/medicine.dart';
import '../services/inventory_service.dart';

class InventoryProvider extends ChangeNotifier {
  final InventoryService _inventoryService = InventoryService();

  List<Medicine> _medicines = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String? _selectedCategory;

  List<Medicine> get medicines => List.unmodifiable(_medicines);
  bool get isLoading => _isLoading;
  int get itemCount => _medicines.length;
  String get searchQuery => _searchQuery;
  String? get selectedCategory => _selectedCategory;

  List<Medicine> get filteredMedicines {
    return _medicines.where((medicine) {
      final matchesSearch = _searchQuery.isEmpty ||
          medicine.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedCategory == null || medicine.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategoryFilter(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = null;
    notifyListeners();
  }

  Future<void> loadMedicines() async {
    _isLoading = true;
    notifyListeners();

    _medicines = await _inventoryService.fetchAll();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addMedicine(Medicine medicine) async {
    await _inventoryService.add(medicine);
    await loadMedicines();
  }

  Future<void> updateMedicine(Medicine medicine) async {
    await _inventoryService.update(medicine);
    await loadMedicines();
  }

  Future<void> removeMedicine(String id) async {
    await _inventoryService.delete(id);
    await loadMedicines();
  }

  Medicine? findById(String id) {
    try {
      return _medicines.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }
}
