import 'order_item.dart';

enum OrderStatus { pending, completed, cancelled }

class Order {
  final int? id;
  final int? supplierId;
  final String supplierName; // denormalized for easy display without a join
  final List<OrderItem> items;
  final OrderStatus status;
  final DateTime orderDate;
  final String? notes;

  Order({
    this.id,
    this.supplierId,
    required this.supplierName,
    required this.items,
    this.status = OrderStatus.pending,
    DateTime? orderDate,
    this.notes,
  }) : orderDate = orderDate ?? DateTime.now();

  double get totalAmount => items.fold(0.0, (sum, item) => sum + item.subtotal);

  int get totalUnits => items.fold(0, (sum, item) => sum + item.quantity);

  int get medicineCount => items.length;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'supplierId': supplierId,
      'supplierName': supplierName,
      'status': status.name,
      'orderDate': orderDate.toIso8601String(),
      'notes': notes,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map, {List<OrderItem>? items}) {
    return Order(
      id: map['id'] is int ? map['id'] : int.tryParse('${map['id']}'),
      supplierId: map['supplierId'] is int
          ? map['supplierId']
          : int.tryParse('${map['supplierId']}'),
      supplierName: map['supplierName']?.toString() ?? '',
      items: items ?? const [],
      status: OrderStatus.values.firstWhere(
        (s) => s.name == map['status'],
        orElse: () => OrderStatus.pending,
      ),
      orderDate: DateTime.tryParse('${map['orderDate']}') ?? DateTime.now(),
      notes: map['notes']?.toString(),
    );
  }

  Order copyWith({
    int? id,
    int? supplierId,
    String? supplierName,
    List<OrderItem>? items,
    OrderStatus? status,
    DateTime? orderDate,
    String? notes,
  }) {
    return Order(
      id: id ?? this.id,
      supplierId: supplierId ?? this.supplierId,
      supplierName: supplierName ?? this.supplierName,
      items: items ?? this.items,
      status: status ?? this.status,
      orderDate: orderDate ?? this.orderDate,
      notes: notes ?? this.notes,
    );
  }
}
