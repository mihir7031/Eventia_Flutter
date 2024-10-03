import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:eventia/LoginPages/login.dart';

class RegistrationPage extends StatefulWidget {
  final String eventId; // Event ID to fetch the specific event passes

  RegistrationPage({required this.eventId}); // Pass eventId to the page

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  List<Ticket> tickets = []; // This will hold the passes (tickets) fetched from Firestore

  @override
  void initState() {
    super.initState();
    fetchPassesFromFirestore(); // Fetch passes (tickets) from Firestore
  }

  // Fetch passes (tickets) from Firestore
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
            available: int.parse(pass['remainingPasses'].toString()) > 0, // Check remaining passes
            quantity: 0, // Track the quantity selected by the user
            remainingPasses: int.parse(pass['remainingPasses'].toString()), // Add remaining passes
          );
        }).toList();

        setState(() {
          tickets = fetchedTickets;
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
        title: Text('Registration & Tickets', style: TextStyle(fontSize: 24)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Available Tickets',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: tickets.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: tickets.length,
                itemBuilder: (context, index) {
                  final ticket = tickets[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 12),
                    elevation: 4,
                    child: ListTile(
                      title: Text(ticket.type, style: TextStyle(fontSize: 22)),
                      subtitle: Text('Price: \$${ticket.price}', style: TextStyle(fontSize: 20)),
                      trailing: ticket.available
                          ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove, size: 28),
                            color: Colors.red,
                            onPressed: () {
                              setState(() {
                                if (ticket.quantity > 0) {
                                  ticket.quantity--;
                                }
                              });
                            },
                          ),
                          Text('${ticket.quantity}', style: TextStyle(fontSize: 20)),
                          IconButton(
                            icon: Icon(Icons.add, size: 28),
                            color: ticket.quantity < ticket.remainingPasses ? Colors.green : Colors.grey,
                            onPressed: () {
                              if (ticket.quantity < ticket.remainingPasses) {
                                setState(() {
                                  ticket.quantity++;
                                });
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('No more passes available for ${ticket.type}.'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      )
                          : Text(
                        'Sold Out',
                        style: TextStyle(color: Colors.red, fontSize: 20),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            if (_selectedTickets().isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selected Tickets:',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  ..._selectedTickets().map((ticket) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        '${ticket.type} x${ticket.quantity}',
                        style: TextStyle(fontSize: 20),
                      ),
                    );
                  }).toList(),
                ],
              ),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Tickets: ${_calculateTotalTickets()}',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Total Price: \$${_calculateTotalPrice().toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: _calculateTotalTickets() > 0
                      ? () {
                    _showConfirmationDialog(context);
                  }
                      : null,
                  child: Text(
                    'Checkout',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Calculate total tickets selected
  int _calculateTotalTickets() {
    return tickets.fold(0, (sum, ticket) => sum + ticket.quantity);
  }

  // Calculate total price
  double _calculateTotalPrice() {
    return tickets.fold(0.0, (sum, ticket) => sum + (ticket.quantity * ticket.price));
  }

  // Get the selected tickets
  List<Ticket> _selectedTickets() {
    return tickets.where((ticket) => ticket.quantity > 0).toList();
  }

  // Show confirmation dialog when proceeding to checkout
  void _showConfirmationDialog(BuildContext context) {
    final totalPrice = _calculateTotalPrice();
    final selectedTickets = _selectedTickets();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Confirm Purchase',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          content: Container(
            width: double.maxFinite, // Ensures the dialog is wide enough
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'You have selected the following tickets:',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 16),
                ...selectedTickets.map((ticket) {
                  final ticketTotal = ticket.quantity * ticket.price; // Calculate total for this ticket
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${ticket.type} x${ticket.quantity}',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          '\$${ticketTotal.toStringAsFixed(2)}', // Display total for this ticket
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                SizedBox(height: 16),
                Divider(color: Colors.black, thickness: 1),
                SizedBox(height: 16),
                Text(
                  'Total Price:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                User? user = FirebaseAuth.instance.currentUser;

                if (user == null) {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LogIn()), // Replace with your actual login page
                  );
                } else {
                  await _processTicketPurchase(selectedTickets ,  user.uid);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Tickets successfully purchased!')),
                  );
                  await fetchPassesFromFirestore(); // Refresh the ticket data
                }
              },
              child: Text('Confirm', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple, // Button background color
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        );
      },
    );
  }

  // Process ticket purchase and update Firestore
  Future<void> _processTicketPurchase(List<Ticket> selectedTickets, String userId) async {
    final eventRef = FirebaseFirestore.instance.collection('eventss').doc(widget.eventId);

    DocumentSnapshot eventDoc = await eventRef.get();
    List<dynamic> passesArray = eventDoc['passes'];

    // Update remaining passes in the passes array
    for (var selectedTicket in selectedTickets) {
      for (var pass in passesArray) {
        if (pass['name'] == selectedTicket.type) {
          int remainingPasses = int.parse(pass['remainingPasses'].toString());
          if (remainingPasses >= selectedTicket.quantity) {
            pass['remainingPasses'] = remainingPasses - selectedTicket.quantity;
          }
        }
      }
    }

    // Update remaining passes in Firestore
    await eventRef.update({'passes': passesArray});

    // Store the purchase in the eventPurchases collection
    final purchaseData = {
      'userId': userId,
      'tickets': selectedTickets.map((ticket) {
        return {
          'type': ticket.type,
          'quantity': ticket.quantity,
          'price': ticket.price,
        };
      }).toList(),
      'totalPrice': _calculateTotalPrice(),
      'timestamp': FieldValue.serverTimestamp(),
    };

    // Add purchase to eventPurchases collection
    final purchaseRef = FirebaseFirestore.instance.collection('eventPurchases').doc(widget.eventId);
    await purchaseRef.collection('purchases').add(purchaseData);

    // Store the purchase in userPurchases collection
    final userPurchasesRef = FirebaseFirestore.instance.collection('userPurchases').doc(userId);
    await userPurchasesRef.collection('purchases').add({
      'eventId': widget.eventId,
      'tickets': selectedTickets.map((ticket) {
        return {
          'type': ticket.type,
          'quantity': ticket.quantity,
          'price': ticket.price,
        };
      }).toList(),
      'totalPrice': _calculateTotalPrice(),
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}

// Ticket model class to hold ticket data
class Ticket {
  final String type;
  final double price;
  final bool available;
  int quantity; // Track the number of tickets selected
  final int remainingPasses; // Total remaining passes

  Ticket({
    required this.type,
    required this.price,
    required this.available,
    this.quantity = 0,
    required this.remainingPasses,
  });
}

// Dummy LoginPage for redirection if the user is not logged in
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Text('Login Page Placeholder'),
      ),
    );
  }
}