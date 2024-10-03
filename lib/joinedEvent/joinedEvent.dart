import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_plus/share_plus.dart';
import 'package:eventia/Favorite/FavoriteButton .dart';
import 'package:eventia/Event_info/Event_info.dart';
import 'package:intl/intl.dart';

class JoinedEventsScreen extends StatefulWidget {
  @override
  _JoinedEventsScreenState createState() => _JoinedEventsScreenState();
}

class _JoinedEventsScreenState extends State<JoinedEventsScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<String> favoriteEventIds = [];

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
      QuerySnapshot purchaseSnapshot = await FirebaseFirestore.instance
          .collection('userPurchases')
          .doc(userId)
          .collection('purchases')
          .get();

      for (QueryDocumentSnapshot doc in purchaseSnapshot.docs) {
        String eventId = doc['eventId'];

        if (!eventIdSet.contains(eventId)) {
          eventIdSet.add(eventId); // Add to set if not already present

          DocumentSnapshot eventDoc = await FirebaseFirestore.instance
              .collection('eventss')
              .doc(eventId)
              .get();

          if (eventDoc.exists) {
            joinedEvents.add(eventDoc); // Add the DocumentSnapshot to the list
          }
        }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Joined Events"),
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

              // Safeguard for missing or null event data
              Timestamp? timestamp =
              event['selectedDate'] as Timestamp?;

              // If the timestamp is null, show a default message
              String formattedDate;
              if (timestamp != null) {
                DateTime dateTime = timestamp.toDate();
                formattedDate =
                    DateFormat('dd-MM-yy').format(dateTime);
              } else {
                formattedDate =
                'Date not available'; // Handle null date
              }
              String eventName = event['eventName'] ?? 'Unnamed Event';
              String aboutEvent = event['aboutEvent'] ?? 'No description available';
              String selectedTime = event['selectedTime'] ?? 'Time not set';
              String eventId = event.id; // Get the event ID

              return InkWell(
                onTap: () => _onCardTapped(event),
                child: Card(
                  color: Colors.white,
                  margin: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: SizedBox(
                          width: 100.0,
                          height: 150.0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              event['eventPoster'] != null &&
                                  event['eventPoster'].isNotEmpty &&
                                  event['eventPoster'] != " "
                                  ? event['eventPoster']
                                  : 'https://via.placeholder.com/150', // Placeholder image URL
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/no_image_available.png', // Placeholder image in assets
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$formattedDate  • $selectedTime',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Text(
                                eventName,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 5.0),
                              Text(
                                aboutEvent,
                                style: const TextStyle(color: Colors.blue),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.share, color: Colors.blue),
                                    onPressed: () {
                                      String eventDetails = '''
                                        Check out this event: $eventName
                                        Date: $formattedDate
                                        Time: $selectedTime
                                        Details: $aboutEvent
                                      ''';

                                      if (event['eventPoster'] != null &&
                                          event['eventPoster'].isNotEmpty) {
                                        eventDetails +=
                                        '\nEvent Poster: ${event['eventPoster']}';
                                      }

                                      Share.share(eventDetails);
                                    },
                                  ),
                                  FavoriteButton(
                                    isFavorited: _isEventFavorited(eventId),
                                    eventId: eventId,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _onCardTapped(DocumentSnapshot event) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Event_info(event: event)),
    );
  }
}
