class Medicine {
  final String id;
  final String name;
  final String? barcode;
  final String category;
  final String? supplierId;
  final int quantity;
  final int minimumStock;
  final DateTime? expiryDate;
  final double unitPrice;
  final String? description;
  final DateTime createdAt;

  const Medicine({
    required this.id,
    required this.name,
    this.barcode,
    required this.category,
    this.supplierId,
    required this.quantity,
    required this.minimumStock,
    this.expiryDate,
    required this.unitPrice,
    this.description,
    required this.createdAt,
  });

  bool get isLowStock => quantity <= minimumStock;

  bool get isExpired {
    if (expiryDate == null) return false;
    return expiryDate!.isBefore(DateTime.now());
  }

  int? get daysUntilExpiry {
    if (expiryDate == null) return null;
    return expiryDate!.difference(DateTime.now()).inDays;
  }

  Medicine copyWith({
    String? id,
    String? name,
    String? barcode,
    String? category,
    String? supplierId,
    int? quantity,
    int? minimumStock,
    DateTime? expiryDate,
    double? unitPrice,
    String? description,
    DateTime? createdAt,
  }) {
    return Medicine(
      id: id ?? this.id,
      name: name ?? this.name,
      barcode: barcode ?? this.barcode,
      category: category ?? this.category,
      supplierId: supplierId ?? this.supplierId,
      quantity: quantity ?? this.quantity,
      minimumStock: minimumStock ?? this.minimumStock,
      expiryDate: expiryDate ?? this.expiryDate,
      unitPrice: unitPrice ?? this.unitPrice,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
