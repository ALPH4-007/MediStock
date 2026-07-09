class Supplier {
  final int? id;
  final String name;
  final String contactPerson;
  final String phone;
  final String? email;
  final String? address;
  final String? notes;
  final DateTime? createdAt;

  Supplier({
    this.id,
    required this.name,
    required this.contactPerson,
    required this.phone,
    this.email,
    this.address,
    this.notes,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'contactPerson': contactPerson,
      'phone': phone,
      'email': email,
      'address': address,
      'notes': notes,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory Supplier.fromMap(Map<String, dynamic> map) {
    return Supplier(
      id: map['id'] is int ? map['id'] : int.tryParse('${map['id']}'),
      name: map['name']?.toString() ?? '',
      contactPerson: map['contactPerson']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      email: map['email']?.toString(),
      address: map['address']?.toString(),
      notes: map['notes']?.toString(),
      createdAt: map['createdAt'] == null
          ? null
          : DateTime.tryParse(map['createdAt'].toString()),
    );
  }

  Supplier copyWith({
    int? id,
    String? name,
    String? contactPerson,
    String? phone,
    String? email,
    String? address,
    String? notes,
    DateTime? createdAt,
  }) {
    return Supplier(
      id: id ?? this.id,
      name: name ?? this.name,
      contactPerson: contactPerson ?? this.contactPerson,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
