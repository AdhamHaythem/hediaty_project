import 'event_model.dart';

class UserModel {
  final String uid;
  final String username;
  final String email;
  final List<String> friends; // Friends' usernames
  final List<EventModel> events; // List of events for the user

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    this.friends = const [],
    this.events = const [],
  });

  // Convert UserModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'friends': friends,
      'events': events.map((e) => e.toMap()).toList(),
    };
  }

  // Create UserModel from Firestore Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      friends: List<String>.from(map['friends'] ?? []),
      events: List<EventModel>.from(
          map['events']?.map((e) => EventModel.fromMap(e)) ?? []),
    );
  }
}
