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
  bool isSortedByCategory = false;

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
      if (isSortedByCategory) {
        gifts.sort((a, b) => a.category.compareTo(b.category));
      }
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
      widget.userId, // Add user ID who pledged
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('You pledged to buy this gift!')),
    );
    _loadGifts();
  }

  void _unpledgeGift(GiftModel gift) async {
    if (gift.status != 'pledged' || gift.pledgedBy != widget.userId) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You cannot unpledge this gift.')),
      );
      return;
    }

    await _giftController.updateGiftStatus(
      widget.ownerId,
      widget.eventId,
      gift.id,
      'available',
      null, // Reset pledgedBy
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('You have unpledged this gift.')),
    );
    _loadGifts();
  }

  void _editGift(GiftModel gift) {
    if (widget.userId != widget.ownerId) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Only the event owner can edit gifts.')),
      );
      return;
    }

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
                SizedBox(height: 8),
                TextField(
                  controller: categoryController,
                  decoration: InputDecoration(labelText: 'Category'),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Price'),
                ),
                SizedBox(height: 8),
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
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final updatedGift = gift.copyWith(
                  name: nameController.text,
                  category: categoryController.text,
                  price: double.parse(priceController.text),
                  description: descriptionController.text,
                );

                await _giftController.updateGift(
                    widget.ownerId, widget.eventId, updatedGift);
                Navigator.pop(context);
                _loadGifts();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteGift(String giftId) async {
    if (widget.userId != widget.ownerId) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Only the event owner can delete gifts.')),
      );
      return;
    }

    await _giftController.deleteGift(widget.ownerId, widget.eventId, giftId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Gift deleted successfully.')),
    );
    _loadGifts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gift List'),
        actions: [
          IconButton(
            icon: Icon(Icons.sort_by_alpha),
            tooltip: 'Sort by Category',
            onPressed: () {
              setState(() {
                isSortedByCategory = true;
                gifts.sort((a, b) => a.category.compareTo(b.category));
              });
            },
          ),
          if (widget.userId == widget.ownerId)
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                // Add Gift functionality
              },
            ),
        ],
      ),
      body: gifts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.card_giftcard, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No gifts found. Add your first gift!',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: gifts.length,
              itemBuilder: (context, index) {
                final gift = gifts[index];
                return Card(
                  color: gift.status == 'available'
                      ? Colors.green.shade50
                      : Colors.red.shade50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  child: ListTile(
                    leading: Icon(Icons.card_giftcard,
                        color: gift.status == 'available'
                            ? Colors.green
                            : Colors.red,
                        size: 40),
                    title: Text(
                      gift.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: gift.status == 'available'
                            ? Colors.green.shade800
                            : Colors.red.shade800,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${gift.category} - \$${gift.price.toString()}'),
                        Text(
                          'Status: ${gift.status}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: gift.status == 'available'
                                  ? Colors.green
                                  : Colors.red),
                        ),
                        if (gift.status == 'pledged' &&
                            gift.pledgedByName != null)
                          Text(
                            'Pledged by: ${gift.pledgedByName}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue,
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
                                : () => _unpledgeGift(gift),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: gift.status == 'pledged'
                                  ? Colors.red
                                  : Colors.green,
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                            ),
                            child: Text(
                              gift.status == 'pledged' ? 'Unpledge' : 'Pledge',
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
