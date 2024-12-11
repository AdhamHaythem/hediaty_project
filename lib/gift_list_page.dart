import 'package:flutter/material.dart';

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
    },
    {
      'name': 'Chocolate Box',
      'category': 'Food',
      'pledged': true,
    },
    {
      'name': 'Flowers',
      'category': 'Decoration',
      'pledged': false,
    },
  ];

  String selectedSort = 'name';

  @override
  Widget build(BuildContext context) {
    final sortedGifts = List<Map<String, dynamic>>.from(gifts);
    sortedGifts.sort((a, b) {
      if (selectedSort == 'pledged') {
        return a['pledged'].toString().compareTo(b['pledged'].toString());
      } else {
        return a[selectedSort].compareTo(b[selectedSort]);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Gifts for ${widget.eventName}'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                selectedSort = value;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'name', child: Text('Sort by Name')),
              PopupMenuItem(value: 'category', child: Text('Sort by Category')),
              PopupMenuItem(
                  value: 'pledged', child: Text('Sort by Pledged Status')),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: sortedGifts.length,
        itemBuilder: (context, index) {
          final gift = sortedGifts[index];
          return Container(
            color: gift['pledged'] ? Colors.green[100] : null,
            child: ListTile(
              title: Text(gift['name']),
              subtitle: Text(gift['category']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!gift['pledged'])
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        _editGift(gift);
                      },
                    ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      if (!gift['pledged']) {
                        setState(() {
                          gifts.remove(gift);
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Cannot delete pledged gifts.')),
                        );
                      }
                    },
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  gift['pledged'] = !gift['pledged'];
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addGift,
        child: Icon(Icons.add),
      ),
    );
  }

  void _addGift() {
    _showGiftDialog(isEdit: false);
  }

  void _editGift(Map<String, dynamic> gift) {
    _showGiftDialog(isEdit: true, currentGift: gift);
  }

  void _showGiftDialog(
      {required bool isEdit, Map<String, dynamic>? currentGift}) {
    final nameController =
        TextEditingController(text: currentGift?['name'] ?? '');
    final categoryController =
        TextEditingController(text: currentGift?['category'] ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEdit ? 'Edit Gift' : 'Add Gift'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Gift Name'),
                ),
                TextField(
                  controller: categoryController,
                  decoration: InputDecoration(labelText: 'Category'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text(isEdit ? 'Save' : 'Add'),
              onPressed: () {
                setState(() {
                  if (isEdit && currentGift != null) {
                    if (!currentGift['pledged']) {
                      currentGift['name'] = nameController.text;
                      currentGift['category'] = categoryController.text;
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Cannot edit pledged gifts.')),
                      );
                    }
                  } else {
                    gifts.add({
                      'name': nameController.text,
                      'category': categoryController.text,
                      'pledged': false,
                    });
                  }
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: Navigator.of(context).pop,
            ),
          ],
        );
      },
    );
  }
}
