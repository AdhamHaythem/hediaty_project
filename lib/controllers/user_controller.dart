import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Signin Method
  Future<UserModel?> signin(String email, String password) async {
    try {
      // Authenticate user with Firebase
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Query Firestore for the user's details
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          final data = userDoc.data() as Map<String, dynamic>;
          return UserModel(
            uid: user.uid,
            email: user.email ?? '',
            username: data['username'] ?? 'Unknown',
          );
        }
      }
    } catch (e) {
      print('Signin Error: $e');
    }
    return null;
  }

  // Signup Method
  Future<UserModel?> signup(
      String email, String password, String username) async {
    try {
      // Create user with Firebase Authentication
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Save user details to Firestore
        final userData = {
          'username': username,
          'email': email,
        };

        await _firestore.collection('users').doc(user.uid).set(userData);

        return UserModel(
          uid: user.uid,
          email: email,
          username: username,
        );
      }
    } catch (e) {
      print('Signup Error: $e');
    }
    return null;
  }

  // Logout Method
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Logout Error: $e');
    }
  }
}
