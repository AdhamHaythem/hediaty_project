import 'package:flutter/material.dart';

class GiftDetailsPage extends StatefulWidget {
  final bool isPledged;
  final Map<String, dynamic>? gift;

  GiftDetailsPage({this.isPledged = false, this.gift});

  @override
  _GiftDetailsPageState createState() => _GiftDetailsPageState();
}

class _GiftDetailsPageState extends State<GiftDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  bool isPledged = false;
  String? imagePath;

  @override
  void initState() {
    super.initState();
    if (widget.gift != null) {
      nameController.text = widget.gift!['name'] ?? '';
      descController.text = widget.gift!['description'] ?? '';
      categoryController.text = widget.gift!['category'] ?? '';
      priceController.text = widget.gift!['price']?.toString() ?? '';
      isPledged = widget.gift!['pledged'] ?? false;
    } else {
      isPledged = widget.isPledged;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool canEdit = !isPledged;
    return Scaffold(
      appBar: AppBar(
        title: Text('Gift Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (imagePath != null)
                Image.asset(imagePath!)
              else
                Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[300],
                  child: Center(child: Text('No image')),
                ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: canEdit
                    ? () {
                        setState(() {
                          imagePath = 'assets/sample_gift_image.png';
                        });
                      }
                    : null,
                child: Text('Upload Image'),
              ),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Gift Name'),
                enabled: canEdit,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter a gift name' : null,
              ),
              TextFormField(
                controller: descController,
                decoration: InputDecoration(labelText: 'Description'),
                enabled: canEdit,
              ),
              TextFormField(
                controller: categoryController,
                decoration: InputDecoration(labelText: 'Category'),
                enabled: canEdit,
              ),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price'),
                enabled: canEdit,
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Enter a price';
                  if (double.tryParse(val) == null)
                    return 'Enter a valid number';
                  return null;
                },
              ),
              SwitchListTile(
                title: Text('Pledged'),
                value: isPledged,
                onChanged: canEdit
                    ? (val) {
                        setState(() {
                          isPledged = val;
                        });
                      }
                    : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: canEdit
                    ? () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Gift details saved')),
                          );
                          Navigator.pop(context);
                        }
                      }
                    : null,
                child: Text('Save'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
