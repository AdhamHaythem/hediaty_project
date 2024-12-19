class EventModel {
  final String id;
  final String name;
  final String date;
  final String location;
  final String description;

  EventModel({
    required this.id,
    required this.name,
    required this.date,
    required this.location,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'date': date,
      'location': location,
      'description': description,
    };
  }

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
