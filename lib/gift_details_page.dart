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
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[300],
                      backgroundImage:
                          imagePath != null ? AssetImage(imagePath!) : null,
                      child: imagePath == null
                          ? Icon(Icons.image, size: 50, color: Colors.grey)
                          : null,
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: canEdit
                        ? () {
                            setState(() {
                              imagePath = 'assets/sample_gift_image.png';
                            });
                          }
                        : null,
                    icon: Icon(Icons.upload),
                    label: Text('Upload Image'),
                  ),
                  _buildTextField('Gift Name', nameController, canEdit,
                      Icons.card_giftcard),
                  _buildTextField('Description', descController, canEdit,
                      Icons.description),
                  _buildTextField(
                      'Category', categoryController, canEdit, Icons.category),
                  _buildTextField(
                      'Price', priceController, canEdit, Icons.money,
                      isNumeric: true),
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
                    child: Text('Save Details'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      bool enabled, IconData icon,
      {bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        validator: (val) {
          if (label == 'Price' &&
              (val == null || double.tryParse(val) == null)) {
            return 'Enter a valid number';
          }
          if (val == null || val.isEmpty) return 'Please enter $label';
          return null;
        },
      ),
    );
  }
}
