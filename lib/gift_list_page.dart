import 'package:flutter/material.dart';
import '../controllers/event_controller.dart';
import '../models/gift_model.dart';

class GiftListPage extends StatefulWidget {
  final String userId; // Current user's ID
  final String eventId;
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
  final EventController _eventController = EventController();
  List<GiftModel> gifts = [];

  @override
  void initState() {
    super.initState();
    _loadGifts();
  }

  Future<void> _loadGifts() async {
    final eventGifts =
        await _eventController.fetchEventGifts(widget.ownerId, widget.eventId);
    setState(() {
      gifts = eventGifts;
    });
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
                  price: double.parse(priceController.text),
                  description: descriptionController.text,
                );
                await _eventController.updateGift(
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

  void _pledgeGift(GiftModel gift) async {
    if (gift.status != 'available') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('This gift is already pledged or purchased.')),
      );
      return;
    }

    final updatedGift = gift.copyWith(status: 'pledged');
    await _eventController.updateGift(
        widget.ownerId, widget.eventId, updatedGift);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('You pledged to buy this gift!')),
    );
    _loadGifts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gift List'),
        actions: [
          if (widget.userId == widget.ownerId)
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                // Logic to add a new gift
              },
            ),
        ],
      ),
      body: gifts.isEmpty
          ? Center(
              child: Text(
                'No gifts found. Add some gifts!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: gifts.length,
              itemBuilder: (context, index) {
                final gift = gifts[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      gift.name,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        '${gift.category} - \$${gift.price.toStringAsFixed(2)}'),
                    trailing: widget.userId == widget.ownerId
                        ? IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editGift(gift),
                          )
                        : ElevatedButton(
                            child: Text('Pledge'),
                            onPressed: () => _pledgeGift(gift),
                          ),
                  ),
                );
              },
            ),
    );
  }
}
