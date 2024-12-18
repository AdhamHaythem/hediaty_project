import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign Up Method
  Future<User?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthError(e.code));
    }
  }

  // Sign In Method
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthError(e.code));
    }
  }

  // Sign Out Method
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Error Handling
  String _handleAuthError(String code) {
    switch (code) {
      case 'invalid-email':
        return 'The email format is invalid.';
      case 'user-not-found':
        return 'No user found for this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'weak-password':
        return 'Password must be at least 6 characters long.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}
