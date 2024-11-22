import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_plus/share_plus.dart';
import 'package:eventia/Favorite/FavoriteButton .dart';
import 'package:eventia/Event_info/Event_info.dart';
import 'package:intl/intl.dart';
import 'package:eventia/LoginPages/LogIn.dart';
import 'package:eventia/main.dart';

class JoinedEventsScreen extends StatefulWidget {
  @override
  _JoinedEventsScreenState createState() => _JoinedEventsScreenState();
}

class _JoinedEventsScreenState extends State<JoinedEventsScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<String> favoriteEventIds = [];
  User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    _loadFavoriteEvents();
  }

  Future<List<DocumentSnapshot>> fetchJoinedEvents() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    String userId = user.uid;
    Set<String> eventIdSet = {}; // Use a set to store unique event IDs
    List<DocumentSnapshot> joinedEvents = [];

    try {
      // Fetch the document for the current user under 'userPurchasedTickets'
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('userPurchasedTickets')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        // Extract event IDs from the user document
        Map<String, dynamic>? purchasedEvents = userDoc.data() as Map<String, dynamic>?;

        // Loop through the event IDs (each eventId is a key in the map)
        if (purchasedEvents != null) {
          for (String eventId in purchasedEvents.keys) {
            if (!eventIdSet.contains(eventId)) {
              eventIdSet.add(eventId); // Add to set if not already present

              // Fetch the event document from 'eventss' collection
              DocumentSnapshot eventDoc = await FirebaseFirestore.instance
                  .collection('eventss')
                  .doc(eventId)
                  .get();

              if (eventDoc.exists) {
                joinedEvents.add(eventDoc); // Add the DocumentSnapshot to the list
              }
            }
          }
        }
      } else {
        print('No purchases found for the user.');
      }
    } catch (e) {
      print('Error fetching joined events: $e');
    }

    return joinedEvents;
  }

  Future<void> _loadFavoriteEvents() async {
    final userDoc = await firestore
        .collection('favourite')
        .doc(auth.currentUser?.uid)
        .get();
    if (userDoc.exists) {
      final favoriteData = userDoc.data() as Map<String, dynamic>?;
      setState(() {
        favoriteEventIds = List<String>.from(favoriteData?['events'] ?? []);
      });
    }
  }

  bool _isEventFavorited(String eventId) {
    return favoriteEventIds.contains(eventId);
  }

  Future<List<Map<String, dynamic>>> _fetchBookedTickets(String eventId) async {
    // Fetching the current user's booked tickets for the given event
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }
    String userId = user.uid;

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('userPurchasedTickets')
        .doc(userId)
        .get();

    List<Map<String, dynamic>> bookedTickets = [];

    if (userDoc.exists) {
      Map<String, dynamic>? purchasedEvents = userDoc.data() as Map<String, dynamic>?;
      if (purchasedEvents != null && purchasedEvents[eventId] != null) {
        List<dynamic> ticketList = purchasedEvents[eventId];
        for (var ticket in ticketList) {
          bookedTickets.add({
            'type': ticket['passtype'],
            'price': ticket['price'],
            'quantity': ticket['totaltickets'],
            'totalPrice': ticket['totalprice'],
            'timestamp': ticket['timestamp'],
          });
        }
      }
    }
    return bookedTickets;
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Joined Events", style: TextStyle(color: primaryColor)),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Please log in to view your joined events.',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LogIn()), // Navigate to login screen
                  );
                },
                child: Text('Go to Login'),
              ),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Joined Events", style: TextStyle(color: primaryColor)),
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: fetchJoinedEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No joined events found.'));
          }

          List<DocumentSnapshot> events = snapshot.data!;

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              DocumentSnapshot event = events[index];
              return EventCard(event: event, fetchBookedTickets: _fetchBookedTickets, isFavorited: _isEventFavorited);
            },
          );
        },
      ),
    );
  }

// void _onCardTapped(DocumentSnapshot event) {
//   Navigator.push(
//     context,
//     MaterialPageRoute(builder: (context) => Event_info(event: event)),
//   );
// }
}
class EventCard extends StatefulWidget {
  final DocumentSnapshot event;
  final Future<List<Map<String, dynamic>>> Function(String) fetchBookedTickets;
  final bool Function(String) isFavorited;

  const EventCard({
    Key? key,
    required this.event,
    required this.fetchBookedTickets,
    required this.isFavorited,
  }) : super(key: key);

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool showAllTickets = false; // Local state for toggling ticket visibility
  List<Map<String, dynamic>> bookedTickets = []; // Store booked tickets here

  @override
  void initState() {
    super.initState();
    _loadBookedTickets(); // Load tickets when the widget is initialized
  }

  // Future<void> _loadBookedTickets() async {
  //   String eventId = widget.event.id; // Get the event ID
  //   bookedTickets = await widget.fetchBookedTickets(eventId); // Fetch booked tickets
  //   setState(() {}); // Update state to refresh the UI
  // }


  Future<void> _loadBookedTickets() async {
    String eventId = widget.event.id;
    List<Map<String, dynamic>> rawTickets = await widget.fetchBookedTickets(eventId);

    // Group tickets by type and sum the quantities and total prices for each type
    Map<String, Map<String, dynamic>> groupedTickets = {};

    for (var ticket in rawTickets) {
      String type = ticket['type'];

      // Parse values to numbers for safe addition
      int quantity = int.tryParse(ticket['quantity'].toString()) ?? 0;
      double price = double.tryParse(ticket['price'].toString()) ?? 0.0;
      double totalPrice = double.tryParse(ticket['totalPrice'].toString()) ?? 0.0;

      if (groupedTickets.containsKey(type)) {
        // If ticket type already exists, add the quantity and total price
        groupedTickets[type]!['quantity'] += quantity;
        groupedTickets[type]!['totalPrice'] += totalPrice;
      } else {
        // If ticket type is new, add it to groupedTickets
        groupedTickets[type] = {
          'type': type,
          'price': price,
          'quantity': quantity,
          'totalPrice': totalPrice,
        };
      }
    }

    // Convert groupedTickets map back to a list for display
    bookedTickets = groupedTickets.values.toList();
    setState(() {}); // Update state to refresh UI
  }



  @override
  Widget build(BuildContext context) {
    // Safeguard for missing or null event data
    Timestamp? timestamp = widget.event['selectedDate'] as Timestamp?;

    // Format date
    String formattedDate = timestamp != null
        ? DateFormat('dd-MM-yy').format(timestamp.toDate())
        : 'Date not available';

    String eventName = widget.event['eventName'] ?? 'Unnamed Event';
    String aboutEvent = widget.event['aboutEvent'] ?? 'No description available';
    String selectedTime = widget.event['selectedTime'] ?? 'Time not set';
    String eventId = widget.event.id; // Get the event ID

    return InkWell(
      onTap: _onCardTapped, // Add the tap functionality
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    widget.event['eventPoster'] != null &&
                        widget.event['eventPoster'].isNotEmpty
                        ? widget.event['eventPoster']
                        : 'https://via.placeholder.com/150',
                    width: 120,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.event['eventName'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.event['location'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Date: $formattedDate',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Time: ${widget.event['selectedTime']}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            // Display booked tickets directly below the event poster
            if (bookedTickets.isNotEmpty) ...[
              const Text(
                'Booked Tickets:',
                style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
              ),
              const SizedBox(height: 2.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...bookedTickets.take(showAllTickets ? bookedTickets.length : 2).map((ticket) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 2.0),
                        Text(
                          'Ticket Type: ${ticket['type']}',
                          style: const TextStyle(color: textColor),
                        ),
                        Text(
                          'Quantity: ${ticket['quantity']}',
                          style: const TextStyle(color: textColor),
                        ),
                        Text(
                          'Price: ₹${ticket['price']}',
                          style: const TextStyle(color: textColor),
                        ),
                        const SizedBox(height: 2.0),
                        const Divider(),
                      ],
                    );
                  }).toList(),
                  if (bookedTickets.length > 2)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showAllTickets = !showAllTickets; // Toggle local state
                        });
                      },
                      child: Text(
                        showAllTickets ? 'Show Less' : 'Show More',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.share, color: iconColor),
                  onPressed: () {
                    String eventDetails = '''
                      Check out this event: $eventName
                      Date: $formattedDate
                      Time: $selectedTime
                      Details: $aboutEvent
                    ''';

                    if (widget.event['eventPoster'] != null &&
                        widget.event['eventPoster'].isNotEmpty) {
                      eventDetails += '\nEvent Poster: ${widget.event['eventPoster']}';
                    }

                    Share.share(eventDetails);
                  },
                ),
                FavoriteButton(
                  isFavorited: widget.isFavorited(eventId),
                  eventId: eventId,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onCardTapped() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Event_info(event: widget.event)),
    );
  }
}
