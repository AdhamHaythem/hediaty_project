import 'dart:convert';

class UserModel {
  final String uid;
  final String email;
  final String username;
  final List<String> gifts;
  final List<String> events;
  final List<String> friends;

  UserModel({
    required this.uid,
    required this.email,
    required this.username,
    this.gifts = const [],
    this.events = const [],
    this.friends = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'gifts': jsonEncode(gifts),
      'events': jsonEncode(events),
      'friends': jsonEncode(friends),
    };
  }

  // Create a UserModel instance from a map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      username: map['username'] ?? '',
      gifts: map['gifts'] != null
          ? List<String>.from(jsonDecode(map['gifts']))
          : [],
      events: map['events'] != null
          ? List<String>.from(jsonDecode(map['events']))
          : [],
      friends: map['friends'] != null
          ? List<String>.from(jsonDecode(map['friends']))
          : [],
    );
  }
}
