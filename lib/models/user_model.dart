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
      'gifts': gifts,
      'events': events,
      'friends': friends,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      username: map['username'] ?? '',
      gifts: List<String>.from(map['gifts'] ?? []),
      events: List<String>.from(map['events'] ?? []),
      friends: List<String>.from(map['friends'] ?? []),
    );
  }
}
