import 'package:flutter/material.dart';

class GiftDetailsPage extends StatelessWidget {
  final Map gift;

  GiftDetailsPage({required this.gift});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gift Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${gift['name']}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Status: ${gift['status']}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}
