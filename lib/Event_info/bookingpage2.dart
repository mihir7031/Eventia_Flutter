import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eventia/LoginPages/login.dart';
import 'package:eventia/main.dart';

class RegistrationPage extends StatefulWidget {
  final String eventId;

  const RegistrationPage({required this.eventId, Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  List<Ticket> tickets = [];
  bool _isFetchingPasses = true;
  bool _isnotified=false;

  @override
  void initState() {
    super.initState();
    fetchPassesFromFirestore();
  }

  Future<void> fetchPassesFromFirestore() async {
    try {
      DocumentSnapshot eventDoc = await FirebaseFirestore.instance
          .collection('eventss')
          .doc(widget.eventId)
          .get();

      if (eventDoc.exists && eventDoc['passes'] != null) {
        List<dynamic> passesArray = eventDoc['passes'];
        List<Ticket> fetchedTickets = passesArray.map((pass) {
          return Ticket(
            type: pass['name'] ?? 'Unknown',
            price: (pass['price'] ?? 0).toDouble(),
            available: int.parse(pass['remainingPasses'].toString()) > 0,
            quantity: 0,
            remainingPasses: int.parse(pass['remainingPasses'].toString()),
          );
        }).toList();

        setState(() {
          tickets = fetchedTickets;
          _isFetchingPasses = false;
        });
      }
    } catch (e) {
      print('Error fetching passes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Registration & Tickets', style: TextStyle(color: primaryColor)),
      ),
      body: _isFetchingPasses
          ? const Center(child: CircularProgressIndicator())
          : tickets.isEmpty
          ? const Center(child: Text('It is free'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Available Tickets',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: tickets.length,
                itemBuilder: (context, index) {
                  final ticket = tickets[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 4,
                    child: ListTile(
                      title: Text(ticket.type, style: const TextStyle(
                          fontWeight: FontWeight.bold)),
                      subtitle: Text('Price: \$${ticket.price}',style: TextStyle(color: textColor),),
                      trailing: ticket.available
                          ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              setState(() {
                                if (ticket.quantity > 0) ticket.quantity--;
                              });
                            },
                          ),
                          Text('${ticket.quantity}',
                              style: const TextStyle(fontSize: 20)),
                          IconButton(
                            icon: const Icon(Icons.add),
                            color: ticket.quantity < ticket.remainingPasses ? primaryColor: Colors.grey,
                            onPressed: () {
                              if (ticket.quantity < ticket.remainingPasses) {
                                setState(() {
                                  ticket.quantity++;
                                });
                              } else {

                                if(_isnotified==false) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'No more passes available for ${ticket
                                              .type}.'),
                                      backgroundColor: Colors.red,
                                    ),

                                  );
                                }
                                _isnotified=true;
                              }
                            },
                          ),
                        ],
                      )
                          : const Text(
                        'Sold Out',
                        style: TextStyle(fontSize: 18, color: Colors.red),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            if (_selectedTickets().isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Selected Tickets:', style: TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
                  ..._selectedTickets().map((ticket) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text('${ticket.type} x${ticket.quantity}',
                          style: const TextStyle(fontSize: 20)),
                    );
                  }).toList(),
                ],
              ),
            const SizedBox(height: 16),
            Text('Total Tickets: ${_calculateTotalTickets()}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Total Price: \$${_calculateTotalPrice().toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: _calculateTotalTickets() > 0 ? () =>
                      _showConfirmationDialog(context) : null,
                  child: const Text(
                      'Checkout', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  int _calculateTotalTickets() {
    return tickets.fold(0, (sum, ticket) => sum + ticket.quantity);
  }

  double _calculateTotalPrice() {
    return tickets.fold(
        0.0, (sum, ticket) => sum + (ticket.quantity * ticket.price));
  }

  List<Ticket> _selectedTickets() {
    return tickets.where((ticket) => ticket.quantity > 0).toList();
  }

  void _showConfirmationDialog(BuildContext context) {
    final totalPrice = _calculateTotalPrice();
    final selectedTickets = _selectedTickets();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Purchase',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...selectedTickets.map((ticket) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${ticket.type} x${ticket.quantity}',
                          style: const TextStyle(fontSize: 16)),
                      Text('\$${(ticket.quantity * ticket.price)
                          .toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                );
              }).toList(),
              const SizedBox(height: 16),
              Divider(color: Colors.black),
              const SizedBox(height: 16),
              Text('Total Price: \$${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () async {
                User? user = FirebaseAuth.instance.currentUser;
                if (user == null) {
                  Navigator.of(context).pop();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LogIn()));
                } else {
                  await _processTicketPurchase(selectedTickets, user.uid);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Tickets successfully purchased!')),
                  );
                  await fetchPassesFromFirestore();
                }
              },
              child: const Text(
                  'Confirm', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple),
            ),
          ],
        );
      },
    );
  }

  Future<void> _processTicketPurchase(List<Ticket> selectedTickets, String userId) async {
    final eventRef = FirebaseFirestore.instance.collection('eventss').doc(widget.eventId);
    DocumentSnapshot eventDoc = await eventRef.get();

    if (!eventDoc.exists) {
      print("Event not found!");
      return;
    }

    List<dynamic> passesArray = eventDoc['passes'];

    for (var selectedTicket in selectedTickets) {
      for (var pass in passesArray) {
        if (pass['name'] == selectedTicket.type) {
          int remainingPasses = int.parse(pass['remainingPasses'].toString());
          if (remainingPasses >= selectedTicket.quantity) {
            pass['remainingPasses'] = remainingPasses - selectedTicket.quantity;
          } else {
            print("Not enough remaining passes for ${selectedTicket.type}");
            return;
          }
        }
      }
    }

    // Update the event document with new pass data
    await eventRef.update({'passes': passesArray});

    final userPurchasesRef = FirebaseFirestore.instance.collection('userPurchasedTickets').doc(userId);
    final userDoc = await userPurchasesRef.get();

    // Retrieve the current list of purchases for this specific event, or initialize as an empty list
    List<dynamic> eventList = userDoc.data()?[widget.eventId] ?? [];

    // Prepare the new purchase entry
    final newPurchaseEntry = {
      'passtype': selectedTickets.map((ticket) => ticket.type).join(', '),
      'price': _calculateTotalPrice().toString(),
      'totalprice': _calculateTotalPrice().toString(),
      'totaltickets': _calculateTotalTickets().toString(),
      'timestamp': DateTime.now().toIso8601String(),
    };

    // Add the new purchase entry to the event list
    eventList.add(newPurchaseEntry);

    // Update user's purchase document with new data, dynamically using widget.eventId as the field key
    await userPurchasesRef.set({
      widget.eventId: eventList
    }, SetOptions(merge: true));

    // Now, also update the EventPurchases collection, using userId as a key inside the event document
    final eventPurchasesRef = FirebaseFirestore.instance.collection('EventPurchases').doc(widget.eventId);
    final eventPurchasesDoc = await eventPurchasesRef.get();

    // Retrieve existing purchases for this user, or initialize as an empty array
    List<dynamic> userPurchases = eventPurchasesDoc.data()?[userId] ?? [];

    // Prepare the new purchase map entry for EventPurchases under the user's userId
    final newEventPurchaseEntry = {
      'type': selectedTickets.map((ticket) => ticket.type).join(', '),
      'price': _calculateTotalPrice().toString(),
      'quantities': _calculateTotalTickets().toString(),
      'totalprice': _calculateTotalPrice().toString(),
      'timestamp': DateTime.now().toIso8601String(),
    };

    // Add the new purchase entry to the array of user purchases
    userPurchases.add(newEventPurchaseEntry);

    // Update the EventPurchases document with new data, using userId as a dynamic field, and merge
    await eventPurchasesRef.set({
      userId: userPurchases
    }, SetOptions(merge: true));
  }

}
class Ticket {
  final String type;
  final double price;
  final bool available;
  int quantity;
  final int remainingPasses;

  Ticket({
    required this.type,
    required this.price,
    required this.available,
    required this.quantity,
    required this.remainingPasses,
  });
}
