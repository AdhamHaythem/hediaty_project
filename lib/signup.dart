import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  String? username, email, password, confirmPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              'Create an Account',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField('Username', Icons.person, false, (value) {
                    return value == null || value.isEmpty
                        ? 'Enter a username'
                        : null;
                  }),
                  _buildTextField('Email', Icons.email, false, (value) {
                    return value == null || !value.contains('@')
                        ? 'Enter a valid email'
                        : null;
                  }),
                  _buildTextField('Password', Icons.lock, true, (value) {
                    return value == null || value.length < 6
                        ? 'Password must be at least 6 characters'
                        : null;
                  }),
                  _buildTextField('Confirm Password', Icons.lock_outline, true,
                      (value) {
                    return value != password ? 'Passwords do not match' : null;
                  }),
                  SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Sign-up Successful!')),
                        );
                      }
                    },
                    child: Text('Sign Up', style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signin');
              },
              child: Text('Already have an account? Sign in'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, bool obscure,
      String? Function(String?) validator) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: validator,
        onChanged: (value) {
          if (label == 'Password') password = value;
        },
      ),
    );
  }
}
