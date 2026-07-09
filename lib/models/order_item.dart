/// A single line item within an Order — one medicine, its quantity, and
/// the unit price at the time of ordering (captured here rather than
/// looked up live, so historical orders stay accurate even if a
/// medicine's price changes later).
class OrderItem {
  final int? id;
  final int? orderId;
  final int? medicineId;
  final String medicineName;
  final int quantity;
  final double unitPrice;

  OrderItem({
    this.id,
    this.orderId,
    this.medicineId,
    required this.medicineName,
    required this.quantity,
    required this.unitPrice,
  });

  double get subtotal => quantity * unitPrice;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderId': orderId,
      'medicineId': medicineId,
      'medicineName': medicineName,
      'quantity': quantity,
      'unitPrice': unitPrice,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      id: map['id'] is int ? map['id'] : int.tryParse('${map['id']}'),
      orderId: map['orderId'] is int
          ? map['orderId']
          : int.tryParse('${map['orderId']}'),
      medicineId: map['medicineId'] is int
          ? map['medicineId']
          : int.tryParse('${map['medicineId']}'),
      medicineName: map['medicineName']?.toString() ?? '',
      quantity: map['quantity'] is int
          ? map['quantity']
          : int.tryParse('${map['quantity']}') ?? 0,
      unitPrice: map['unitPrice'] is num
          ? (map['unitPrice'] as num).toDouble()
          : double.tryParse('${map['unitPrice']}') ?? 0.0,
    );
  }

  OrderItem copyWith({
    int? id,
    int? orderId,
    int? medicineId,
    String? medicineName,
    int? quantity,
    double? unitPrice,
  }) {
    return OrderItem(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      medicineId: medicineId ?? this.medicineId,
      medicineName: medicineName ?? this.medicineName,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
    );
  }
}
