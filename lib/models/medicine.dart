class Medicine {
  final int? id;
  final String name;
  final String? barcode;
  final String batchNumber;
  final String manufacturer;
  final String category;
  final int quantity;
  final int minimumStock;
  final DateTime? expiryDate;
  final double purchasePrice;
  final double sellingPrice;
  final int supplierId;
  final String location;
  final String? description;
  final DateTime? createdAt;

  Medicine({
    this.id,
    required this.name,
    this.barcode,
    this.batchNumber = 'N/A',
    this.manufacturer = 'N/A',
    this.category = 'Other',
    this.quantity = 0,
    this.minimumStock = 0,
    this.expiryDate,
    double? purchasePrice,
    double? sellingPrice,
    this.supplierId = 0,
    this.location = 'Main Shelf',
    this.description,
    this.createdAt,
    double? unitPrice,
  })  : purchasePrice = purchasePrice ?? sellingPrice ?? unitPrice ?? 0.0,
        sellingPrice = sellingPrice ?? unitPrice ?? purchasePrice ?? 0.0;

  double get unitPrice => sellingPrice > 0 ? sellingPrice : purchasePrice;
  bool get isLowStock => quantity <= minimumStock;
  int? get daysUntilExpiry {
    if (expiryDate == null) return null;
    final difference = expiryDate!.difference(DateTime.now()).inDays;
    return difference;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'barcode': barcode,
      'batchNumber': batchNumber,
      'manufacturer': manufacturer,
      'category': category,
      'quantity': quantity,
      'minimumStock': minimumStock,
      'expiryDate': expiryDate?.toIso8601String(),
      'purchasePrice': purchasePrice,
      'sellingPrice': sellingPrice,
      'supplierId': supplierId,
      'location': location,
      'description': description,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory Medicine.fromMap(Map<String, dynamic> map) {
    return Medicine(
      id: _toInt(map['id']),
      name: map['name']?.toString() ?? '',
      barcode: map['barcode']?.toString(),
      batchNumber: map['batchNumber']?.toString() ?? 'N/A',
      manufacturer: map['manufacturer']?.toString() ?? 'N/A',
      category: map['category']?.toString() ?? 'Other',
      quantity: _toInt(map['quantity']),
      minimumStock: _toInt(map['minimumStock']),
      expiryDate: _parseDateTime(map['expiryDate']),
      purchasePrice: _toDouble(map['purchasePrice']),
      sellingPrice: _toDouble(map['sellingPrice']),
      supplierId: _toInt(map['supplierId']),
      location: map['location']?.toString() ?? 'Main Shelf',
      description: map['description']?.toString(),
      createdAt: _parseDateTime(map['createdAt']),
    );
  }

  Medicine copyWith({
    int? id,
    String? name,
    String? barcode,
    String? batchNumber,
    String? manufacturer,
    String? category,
    int? quantity,
    int? minimumStock,
    DateTime? expiryDate,
    double? purchasePrice,
    double? sellingPrice,
    int? supplierId,
    String? location,
    String? description,
    DateTime? createdAt,
  }) {
    return Medicine(
      id: id ?? this.id,
      name: name ?? this.name,
      barcode: barcode ?? this.barcode,
      batchNumber: batchNumber ?? this.batchNumber,
      manufacturer: manufacturer ?? this.manufacturer,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      minimumStock: minimumStock ?? this.minimumStock,
      expiryDate: expiryDate ?? this.expiryDate,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      supplierId: supplierId ?? this.supplierId,
      location: location ?? this.location,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }
}
