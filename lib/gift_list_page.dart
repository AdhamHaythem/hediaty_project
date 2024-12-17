import 'package:flutter/material.dart';
import 'gift_details_page.dart';

class GiftListPage extends StatefulWidget {
  final String eventName;

  GiftListPage({required this.eventName});

  @override
  _GiftListPageState createState() => _GiftListPageState();
}

class _GiftListPageState extends State<GiftListPage> {
  List<Map<String, dynamic>> gifts = [
    {
      'name': 'Watch',
      'category': 'Accessory',
      'pledged': false,
      'image': 'assets/watch.png'
    },
    {
      'name': 'Chocolate Box',
      'category': 'Food',
      'pledged': true,
      'image': 'assets/chocolates.png'
    },
    {
      'name': 'Flowers',
      'category': 'Decoration',
      'pledged': false,
      'image': 'assets/flowers.png'
    },
  ];

  void _addGift() {
    final nameController = TextEditingController();
    final categoryController = TextEditingController();
    bool isPledged = false;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Gift'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(
                    'Gift Name', nameController, Icons.card_giftcard),
                SizedBox(height: 10),
                _buildTextField('Category', categoryController, Icons.category),
                SizedBox(height: 10),
                CheckboxListTile(
                  title: Text('Pledged'),
                  value: isPledged,
                  onChanged: (value) {
                    setState(() {
                      isPledged = value ?? false;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    categoryController.text.isNotEmpty) {
                  setState(() {
                    gifts.add({
                      'name': nameController.text,
                      'category': categoryController.text,
                      'pledged': isPledged,
                      'image': 'assets/default.png', // Default image
                    });
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gift added successfully!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill all fields')),
                  );
                }
              },
              child: Text('Add Gift'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gifts for ${widget.eventName}'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: gifts.length,
        itemBuilder: (context, index) {
          final gift = gifts[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GiftDetailsPage(
                      isPledged: gift['pledged'] ?? false,
                      gift: gift,
                    ),
                  ),
                );
              },
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(gift['image']),
                ),
                title: Text(
                  gift['name'],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(gift['category']),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addGift,
        icon: Icon(Icons.add),
        label: Text('Add Gift'),
      ),
    );
  }
}
