import 'package:flutter/material.dart';
import '../controllers/gift_controller.dart';
import '../models/gift_model.dart';

class GiftListPage extends StatefulWidget {
  final String userId; // Current user's ID
  final String eventId; // Event ID for which gifts are displayed
  final String ownerId; // Owner of the event

  GiftListPage({
    required this.userId,
    required this.eventId,
    required this.ownerId,
  });

  @override
  _GiftListPageState createState() => _GiftListPageState();
}

class _GiftListPageState extends State<GiftListPage> {
  final GiftController _giftController = GiftController();
  List<GiftModel> gifts = [];

  @override
  void initState() {
    super.initState();
    _loadGifts();
  }

  Future<void> _loadGifts() async {
    final eventGifts = await _giftController.fetchGiftsForEvent(
        widget.ownerId, widget.eventId);
    setState(() {
      gifts = eventGifts;
    });
  }

  void _pledgeGift(GiftModel gift) async {
    if (gift.status != 'available') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('This gift is already pledged.')),
      );
      return;
    }

    await _giftController.updateGiftStatus(
      widget.ownerId,
      widget.eventId,
      gift.id,
      'pledged',
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('You pledged to buy this gift!')),
    );
    _loadGifts();
  }

  void _deleteGift(String giftId) async {
    if (widget.userId != widget.ownerId) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You cannot delete a friend’s gift.')),
      );
      return;
    }

    await _giftController.deleteGift(widget.ownerId, widget.eventId, giftId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Gift deleted successfully.')),
    );
    _loadGifts();
  }

  void _editGift(GiftModel gift) {
    final nameController = TextEditingController(text: gift.name);
    final categoryController = TextEditingController(text: gift.category);
    final priceController = TextEditingController(text: gift.price.toString());
    final descriptionController = TextEditingController(text: gift.description);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Gift'),
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
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Price'),
                ),
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final updatedGift = gift.copyWith(
                  name: nameController.text,
                  category: categoryController.text,
                  price: double.tryParse(priceController.text) ?? gift.price,
                  description: descriptionController.text,
                );
                await _giftController.updateGift(
                  widget.ownerId,
                  widget.eventId,
                  updatedGift,
                );
                Navigator.pop(context);
                _loadGifts();
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gift List'),
      ),
      body: gifts.isEmpty
          ? Center(
              child: Text('No gifts found. Add your first gift!'),
            )
          : ListView.builder(
              itemCount: gifts.length,
              itemBuilder: (context, index) {
                final gift = gifts[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: ListTile(
                    title: Text(
                      gift.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${gift.category} - \$${gift.price}'),
                        SizedBox(height: 4),
                        Text(
                          'Status: ${gift.status == 'available' ? 'Available' : 'Pledged'}',
                          style: TextStyle(
                            color: gift.status == 'available'
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.userId == widget.ownerId)
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editGift(gift),
                          ),
                        if (widget.userId == widget.ownerId)
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteGift(gift.id),
                          ),
                        if (widget.userId != widget.ownerId)
                          ElevatedButton(
                            onPressed: gift.status == 'available'
                                ? () => _pledgeGift(gift)
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: gift.status == 'pledged'
                                  ? Colors.green
                                  : null,
                            ),
                            child: Text(
                              gift.status == 'pledged' ? 'Pledged' : 'Pledge',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
