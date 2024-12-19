class GiftModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final String status; // e.g., "available", "pledged", "purchased"
  final double price;

  GiftModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.status,
    required this.price,
  });

  // Convert GiftModel to Map for Firestore/Realtime DB
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'status': status,
      'price': price,
    };
  }

  // Create a GiftModel from Map (retrieved from Firebase)
  factory GiftModel.fromMap(String id, Map<String, dynamic> data) {
    return GiftModel(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      status: data['status'] ?? 'available',
      price: (data['price'] ?? 0).toDouble(),
    );
  }
}
