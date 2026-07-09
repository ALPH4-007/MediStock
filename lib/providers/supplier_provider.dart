import 'package:flutter/foundation.dart';

import '../models/supplier.dart';
import '../services/supplier_service.dart';

class SupplierProvider extends ChangeNotifier {
  final SupplierService _supplierService = SupplierService();

  List<Supplier> _suppliers = [];
  bool _isLoading = false;
  String _searchQuery = '';

  List<Supplier> get suppliers => List.unmodifiable(_suppliers);
  bool get isLoading => _isLoading;
  int get itemCount => _suppliers.length;
  String get searchQuery => _searchQuery;

  List<Supplier> get filteredSuppliers {
    if (_searchQuery.isEmpty) return suppliers;

    final q = _searchQuery.toLowerCase();
    return _suppliers.where((s) {
      return s.name.toLowerCase().contains(q) ||
          s.contactPerson.toLowerCase().contains(q);
    }).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> loadSuppliers() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      _suppliers = await _supplierService.fetchAll();
    } catch (error) {
      debugPrint('SUPPLIER LOAD ERROR: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addSupplier(Supplier supplier) async {
    try {
      await _supplierService.add(supplier);
      await loadSuppliers();
    } catch (error) {
      debugPrint('SUPPLIER ADD ERROR: $error');
      rethrow;
    }
  }

  Future<void> updateSupplier(Supplier supplier) async {
    try {
      await _supplierService.update(supplier);
      await loadSuppliers();
    } catch (error) {
      debugPrint('SUPPLIER UPDATE ERROR: $error');
      rethrow;
    }
  }

  Future<void> removeSupplier(int? id) async {
    try {
      await _supplierService.delete(id);
      await loadSuppliers();
    } catch (error) {
      debugPrint('SUPPLIER DELETE ERROR: $error');
      rethrow;
    }
  }

  Supplier? findById(int? id) {
    try {
      return _suppliers.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }
}
