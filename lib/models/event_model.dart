class EventModel {
  final String id;
  final String name;
  final String date;
  final String location;
  final String description;
  final String ownerId;

  EventModel({
    required this.id,
    required this.name,
    required this.date,
    required this.location,
    required this.description,
    required this.ownerId,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'date': date,
      'location': location,
      'description': description,
      'ownerId': ownerId,
    };
  }

  factory EventModel.fromMap(String id, Map<String, dynamic> map) {
    return EventModel(
      id: id,
      name: map['name'] ?? '',
      date: map['date'] ?? '',
      location: map['location'] ?? '',
      description: map['description'] ?? '',
      ownerId: map['ownerId'] ?? '',
    );
  }

  EventModel copyWith({
    String? name,
    String? date,
    String? location,
    String? description,
  }) {
    return EventModel(
      id: id,
      name: name ?? this.name,
      date: date ?? this.date,
      location: location ?? this.location,
      description: description ?? this.description,
      ownerId: ownerId,
    );
  }
}
