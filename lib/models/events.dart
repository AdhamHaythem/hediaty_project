class EventModel {
  final String id;
  final String name;
  final String date; // Format: YYYY-MM-DD
  final String location;
  final String description;

  EventModel({
    required this.id,
    required this.name,
    required this.date,
    required this.location,
    required this.description,
  });

  // Convert EventModel to Map for Firestore/Realtime DB
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date,
      'location': location,
      'description': description,
    };
  }

  // Create an EventModel from Map (retrieved from Firebase)
  factory EventModel.fromMap(String id, Map<String, dynamic> data) {
    return EventModel(
      id: id,
      name: data['name'] ?? '',
      date: data['date'] ?? '',
      location: data['location'] ?? '',
      description: data['description'] ?? '',
    );
  }
}
