import 'package:flutter/foundation.dart';

import '../models/order.dart';
import '../services/order_service.dart';

class OrderProvider extends ChangeNotifier {
  final OrderService _orderService = OrderService();

  List<Order> _orders = [];
  bool _isLoading = false;
  OrderStatus? _statusFilter; // null = show all

  List<Order> get orders => List.unmodifiable(_orders);
  bool get isLoading => _isLoading;
  OrderStatus? get statusFilter => _statusFilter;

  int get pendingCount =>
      _orders.where((o) => o.status == OrderStatus.pending).length;

  List<Order> get filteredOrders {
    if (_statusFilter == null) return orders;
    return _orders.where((o) => o.status == _statusFilter).toList();
  }

  void setStatusFilter(OrderStatus? status) {
    _statusFilter = status;
    notifyListeners();
  }

  Future<void> loadOrders() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      _orders = await _orderService.fetchAll();
    } catch (error) {
      debugPrint('ORDER LOAD ERROR: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addOrder(Order order) async {
    try {
      await _orderService.add(order);
      await loadOrders();
    } catch (error) {
      debugPrint('ORDER ADD ERROR: $error');
      rethrow;
    }
  }

  Future<void> updateOrderStatus(Order order, OrderStatus status) async {
    try {
      await _orderService.update(order.copyWith(status: status));
      await loadOrders();
    } catch (error) {
      debugPrint('ORDER UPDATE ERROR: $error');
      rethrow;
    }
  }

  Future<void> removeOrder(int? id) async {
    try {
      await _orderService.delete(id);
      await loadOrders();
    } catch (error) {
      debugPrint('ORDER DELETE ERROR: $error');
      rethrow;
    }
  }
}
