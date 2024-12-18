import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Signup a user and save to Firestore
  Future<UserModel?> signup(
      String email, String password, String username) async {
    try {
      // Create user with FirebaseAuth
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Create a UserModel
        UserModel newUser = UserModel(
          uid: user.uid,
          email: email,
          username: username,
        );

        // Debugging logs
        print('Attempting to add user to Firestore with UID: ${user.uid}');

        // Save to Firestore using set
        await _firestore.collection('users').doc(user.uid).set(newUser.toMap());

        print('User successfully added to Firestore');
        return newUser;
      }
    } catch (e) {
      print('Signup Error: $e'); // Debugging log
    }
    return null;
  }

  // Signin user and fetch data from Firestore
  Future<UserModel?> signin(String email, String password) async {
    try {
      // Sign in with FirebaseAuth
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Fetch user data from Firestore
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          print('User data retrieved from Firestore for UID: ${user.uid}');
          return UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
        } else {
          print('No user data found in Firestore for UID: ${user.uid}');
        }
      }
    } catch (e) {
      print('Signin Error: $e');
    }
    return null;
  }
}
