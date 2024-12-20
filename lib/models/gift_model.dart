class GiftModel {
  final String id;
  final String name;
  final String category;
  final double price;
  final String status;
  final String description;
  final String? pledgedBy;
  final String? pledgedByName;

  GiftModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.status,
    required this.description,
    this.pledgedBy,
    this.pledgedByName,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'price': price,
      'status': status,
      'description': description,
      'pledgedBy': pledgedBy,
      'pledgedByName': pledgedByName,
    };
  }

  factory GiftModel.fromMap(String id, Map<String, dynamic> map) {
    return GiftModel(
      id: id,
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      status: map['status'] ?? 'available',
      description: map['description'] ?? '',
      pledgedBy: map['pledgedBy'],
      pledgedByName: map['pledgedByName'],
    );
  }

  GiftModel copyWith({
    String? name,
    String? category,
    double? price,
    String? status,
    String? description,
    String? pledgedBy,
    String? pledgedByName,
  }) {
    return GiftModel(
      id: id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      status: status ?? this.status,
      description: description ?? this.description,
      pledgedBy: pledgedBy ?? this.pledgedBy,
      pledgedByName: pledgedByName ?? this.pledgedByName,
    );
  }
}
