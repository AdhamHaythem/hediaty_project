import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/users.dart';

class UsersController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save user to Firestore
  Future<void> createUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toMap());
    } catch (e) {
      print("Error saving user: $e");
      throw Exception("Failed to save user data.");
    }
  }
}
