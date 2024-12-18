import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/users.dart';

class UsersService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch user by ID
  Future<UserModel?> getUserById(String id) async {
    try {
      final doc = await _firestore.collection('users').doc(id).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception("Error fetching user: $e");
    }
  }

  // Update user data
  Future<void> updateUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).update(user.toMap());
    } catch (e) {
      throw Exception("Error updating user: $e");
    }
  }
}
