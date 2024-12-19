import 'package:flutter/material.dart';
import '../controllers/gift_controller.dart';
import '../models/gift_model.dart';

class GiftListPage extends StatefulWidget {
  final String eventId;

  GiftListPage({required this.eventId});

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
    final eventGifts = await _giftController.fetchGiftsForEvent(widget.eventId);
    setState(() {
      gifts = eventGifts;
    });
  }

  void _addGift() {
    // Example gift creation logic
    final newGift = GiftModel(
      id: '',
      name: 'New Gift',
      description: 'Default description',
      category: 'General',
      status: 'available',
      price: 0.0,
    );
    _giftController.addGift(newGift).then((_) => _loadGifts());
  }

  void _editGift(GiftModel gift) {
    // Add logic for editing gifts
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gifts'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addGift,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: gifts.length,
        itemBuilder: (context, index) {
          final gift = gifts[index];
          return ListTile(
            title: Text(gift.name),
            subtitle: Text('${gift.category} - ${gift.status}'),
            trailing: Icon(Icons.edit),
            onTap: () => _editGift(gift),
          );
        },
      ),
    );
  }
}
