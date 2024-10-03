import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookedTicketsScreen extends StatefulWidget {
  final String eventId;
  final String userId; // Pass the user ID as well

  BookedTicketsScreen({required this.eventId, required this.userId});

  @override
  _BookedTicketsScreenState createState() => _BookedTicketsScreenState();
}

class _BookedTicketsScreenState extends State<BookedTicketsScreen> {
  bool _loading = false;
  List<Map<String, dynamic>> _bookedTickets = [];

  @override
  void initState() {
    super.initState();
    // Automatically fetch tickets when the screen is loaded
    _fetchBookedTickets();
  }

  // Function to fetch booked tickets from Firebase
  Future<void> _fetchBookedTickets() async {
    setState(() {
      _loading = true;
    });

    try {
      // Query for purchases under the userPurchases collection
      var purchasesSnapshot = await FirebaseFirestore.instance
          .collection('userPurchases')
          .doc(widget.userId) // Get purchases for the specific user
          .collection('purchases')
          .get();

      List<Map<String, dynamic>> bookedTickets = [];

      for (var purchaseDoc in purchasesSnapshot.docs) {
        // Check if the eventId matches the provided eventId
        if (purchaseDoc.data()['eventId'] == widget.eventId) {
          // Extract the tickets array from the purchase document
          var tickets = List<Map<String, dynamic>>.from(purchaseDoc.data()['tickets']);

          // Extract timestamp and totalPrice directly from the purchase document
          var timestamp = purchaseDoc.data()['timestamp'].toDate().toString();
          var totalPrice = purchaseDoc.data()['totalPrice'];

          // Add each ticket's details to the list
          for (var ticket in tickets) {
            bookedTickets.add({
              'price': ticket['price'],
              'quantity': ticket['quantity'],
              'type': ticket['type'],
              'timestamp': timestamp, // Use the purchase document timestamp
              'totalPrice': totalPrice, // Use the purchase document totalPrice
            });
          }
        }
      }

      setState(() {
        _bookedTickets = bookedTickets;
      });
    } catch (e) {
      print("Error fetching booked tickets: $e");
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booked Tickets'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            _loading
                ? CircularProgressIndicator()
                : _bookedTickets.isEmpty
                ? Text('No tickets booked for this event.')
                : Expanded(
              child: ListView.builder(
                itemCount: _bookedTickets.length,
                itemBuilder: (context, index) {
                  var ticket = _bookedTickets[index];
                  return Card(
                    child: ListTile(
                      title: Text('Ticket Type: ${ticket['type']}'),
                      subtitle: Text(
                        'Price: ₹${ticket['price']} \nQuantity: ${ticket['quantity']} \nTotal Price: ₹${ticket['totalPrice']} \nBooked On: ${ticket['timestamp']}',
                        style: TextStyle(color: Colors.black.withOpacity(0.7)),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
