
class Medicine {
  final String id;
  final String name;
  final int quantity;
  final DateTime? expiryDate;

  const Medicine({
    required this.id,
    required this.name,
    required this.quantity,
    this.expiryDate,
  });

  Medicine copyWith({
    String? id,
    String? name,
    int? quantity,
    DateTime? expiryDate,
  }) {
    return Medicine(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      expiryDate: expiryDate ?? this.expiryDate,
    );
  }
}
