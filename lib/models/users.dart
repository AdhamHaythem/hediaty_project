class UserModel {
  final String id;
  final String username;
  final String email;
  final String phone;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
  });

  // Convert UserModel to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'phone': phone,
    };
  }

  // Create UserModel from Map
  factory UserModel.fromMap(String id, Map<String, dynamic> data) {
    return UserModel(
      id: id,
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
    );
  }
}
