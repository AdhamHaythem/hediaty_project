import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  String? username, email, password, confirmPassword;
  String _tempPassword = ''; // Temporary variable for password

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Signup')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a username'
                    : null,
                onSaved: (value) => username = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value == null || !value.contains('@')
                    ? 'Please enter a valid email'
                    : null,
                onSaved: (value) => email = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
                onChanged: (value) {
                  _tempPassword = value; // Temporarily store password
                },
                onSaved: (value) => password = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value != _tempPassword) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                onSaved: (value) => confirmPassword = value,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Signup'),
                onPressed: _handleSignup,
              ),
              TextButton(
                child: Text('Already have an account? Signin'),
                onPressed: () =>
                    Navigator.pop(context), // Go back to SigninPage
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Save the form values

      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email!, password: password!);
        // Success feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signup Successful: ${email}')),
        );
        // Go back to the SigninPage
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        // Display error message in a SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signup failed: ${e.message}')),
        );
      }
    }
  }
}
