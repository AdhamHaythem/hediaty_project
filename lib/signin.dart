import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SigninPage extends StatefulWidget {
  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final _formKey = GlobalKey<FormState>();
  String? email, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Signin')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a password'
                    : null,
                onSaved: (value) => password = value,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Signin'),
                onPressed: _handleSignin,
              ),
              TextButton(
                child: Text('Don’t have an account? Signup'),
                onPressed: _navigateToSignup,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSignin() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email!,
          password: password!,
        );
        Navigator.pushReplacementNamed(context, '/friends');
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signin failed: ${e.message}')),
        );
      }
    }
  }

  void _navigateToSignup() {
    Navigator.pushNamed(context, '/signup');
  }
}
