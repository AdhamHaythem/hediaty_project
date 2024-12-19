import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new user
  Future<void> addUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set(user.toMap());
    } catch (e) {
      print('Error adding user: $e');
    }
  }

  // Fetch a user's data
  Future<UserModel?> getUser(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        return UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print('Error fetching user: $e');
    }
    return null;
  }

  // Add a friend to the user's friends list
  Future<void> addFriend(String userId, String friendUsername) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'friends': FieldValue.arrayUnion([friendUsername]),
      });
    } catch (e) {
      print('Error adding friend: $e');
    }
  }
}
