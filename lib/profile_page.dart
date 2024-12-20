import 'package:flutter/material.dart';
import 'package:hedaity_project/controllers/user_controller.dart';

class ProfilePage extends StatefulWidget {
  final String userId;
  final String username;
  final String email;
  final String? imageUrl;

  ProfilePage({
    required this.userId,
    required this.username,
    required this.email,
    this.imageUrl,
    Key? key,
  }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String username;
  late String email;

  @override
  void initState() {
    super.initState();
    username = widget.username;
    email = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue,
                backgroundImage:
                    widget.imageUrl != null && widget.imageUrl!.isNotEmpty
                        ? NetworkImage(widget.imageUrl!)
                        : null,
                child: widget.imageUrl == null || widget.imageUrl!.isEmpty
                    ? Text(
                        username.isNotEmpty ? username[0].toUpperCase() : '',
                        style: TextStyle(fontSize: 40, color: Colors.white),
                      )
                    : null,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Username:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              username,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Email:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              email,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () => _showEditOptions(context),
                child: Text('Edit Profile'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Log Out'),
                      content: Text('Are you sure you want to log out?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            final userController = UserController();
                            await userController.logout();
                            Navigator.pop(context);
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/signin',
                              (route) => false,
                            );
                          },
                          child: Text('Log Out'),
                        ),
                      ],
                    ),
                  );
                },
                child: Text('Log Out'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Edit Profile',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Edit Username'),
                onTap: () => _editField(context, 'Username', username),
              ),
              ListTile(
                leading: Icon(Icons.email),
                title: Text('Edit Email'),
                onTap: () => _editField(context, 'Email', email),
              ),
              ListTile(
                leading: Icon(Icons.lock),
                title: Text('Edit Password'),
                onTap: () => _editPassword(context),
              ),
            ],
          ),
        );
      },
    );
  }

  // Add your existing _editField and _editPassword methods here
  void _editField(BuildContext context, String field, String initialValue) {
    final controller = TextEditingController(text: initialValue);
    final userController = UserController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit $field'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Enter new $field',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final newValue = controller.text.trim();
                if (newValue.isEmpty) {
                  _showErrorDialog(context, '$field cannot be empty!');
                  return;
                }
                if (field == 'Email') {
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(newValue)) {
                    _showErrorDialog(
                        context, 'Please enter a valid email address.');
                    return;
                  }
                  if (await userController.isEmailTaken(newValue)) {
                    _showErrorDialog(context, 'This email is already taken!');
                    return;
                  }
                }
                if (field == 'Username') {
                  if (newValue.length < 3) {
                    _showErrorDialog(context,
                        'Username must be at least 3 characters long.');
                    return;
                  }
                  if (await userController.isUsernameTaken(newValue)) {
                    _showErrorDialog(
                        context, 'This username is already taken!');
                    return;
                  }
                }

                try {
                  await userController.updateUserField(
                      widget.userId, field.toLowerCase(), newValue);

                  setState(() {
                    if (field == 'Username') {
                      username = newValue;
                    } else if (field == 'Email') {
                      email = newValue;
                    }
                  });

                  Navigator.pop(context); // Close the dialog after success
                  _showSuccessDialog(context, '$field updated successfully!');
                } catch (e) {
                  _showErrorDialog(context, 'Failed to update $field. $e');
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _editPassword(BuildContext context) {
    // Existing _editPassword implementation
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Success'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
