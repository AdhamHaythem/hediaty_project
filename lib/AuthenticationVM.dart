import 'package:firebase_auth/firebase_auth.dart';
import 'auth.dart';
import '../controllers/users.dart';
import '../models/users.dart';

class AuthenticationViewModel {
  final Auth _auth = Auth();
  final UsersController _usersController = UsersController();

  // Sign Up with Firebase Authentication and Firestore
  Future<void> signUp({
    required String email,
    required String password,
    required String username,
    required String phone,
  }) async {
    User? user = await _auth.signUp(email: email, password: password);
    if (user != null) {
      UserModel newUser = UserModel(
        id: user.uid,
        username: username,
        email: email,
        phone: phone,
      );

      await _usersController.createUser(newUser);
    } else {
      throw Exception("Failed to create user in Firebase Authentication.");
    }
  }

  // Sign In User
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    return await _auth.signIn(email: email, password: password);
  }
}
