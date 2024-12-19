class GiftModel {
  final String id;
  final String name;
  final String category;
  final double price;
  final String status; // e.g., "available", "pledged", "purchased"
  final String description;

  GiftModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.status,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'price': price,
      'status': status,
      'description': description,
    };
  }

  factory GiftModel.fromMap(String id, Map<String, dynamic> data) {
    return GiftModel(
      id: id,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      status: data['status'] ?? 'available',
      description: data['description'] ?? '',
    );
  }
}
