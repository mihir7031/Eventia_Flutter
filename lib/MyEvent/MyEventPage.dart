import 'package:flutter/material.dart';
import 'package:eventia/Event_info/Event_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eventia/Favorite/FavoriteButton .dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:eventia/main.dart';

class Myeventpage extends StatefulWidget {
  const Myeventpage({super.key});

  @override
  State<Myeventpage> createState() => _MyeventpageState();
}

class _MyeventpageState extends State<Myeventpage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<String> favoriteEventIds = [];
  bool showScheduledEvents = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteEvents();
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

  void _onCardTapped(DocumentSnapshot event) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Event_info(event: event)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(

        backgroundColor: Colors.white,
        title: const Text(
          'My Events',
          style: TextStyle(color: primaryColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showScheduledEvents = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: !showScheduledEvents
                        ? primaryColor
                        : inactiveColor,
                  ),
                  child: const Text('Finished Events',style: TextStyle(color: Colors.white),),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showScheduledEvents = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: showScheduledEvents
                        ? primaryColor
                        : inactiveColor,
                  ),
                  child: const Text('Scheduled Events',style: TextStyle(color: Colors.white),),
                ),

              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: firestore
                    .collection('eventss')
                    .where('uid', isEqualTo: auth.currentUser?.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No events found.'));
                  }

                  var events = snapshot.data!.docs;
                  List<DocumentSnapshot> scheduledEvents = [];
                  List<DocumentSnapshot> finishedEvents = [];

                  for (var event in events) {
                    Timestamp? timestamp = event['selectedDate'] as Timestamp?;
                    if (timestamp != null) {
                      DateTime eventDate = timestamp.toDate();
                      if (eventDate.isAfter(DateTime.now())) {
                        scheduledEvents.add(event);
                      } else {
                        finishedEvents.add(event);
                      }
                    }
                  }

                  var eventsToShow = showScheduledEvents
                      ? scheduledEvents
                      : finishedEvents;

                  if (eventsToShow.isEmpty) {
                    return const Center(child: Text('No events found.'));
                  }

                  return ListView.builder(
                    itemCount: eventsToShow.length,
                    itemBuilder: (context, index) {
                      var event = eventsToShow[index];
                      Timestamp? timestamp = event['selectedDate'] as Timestamp?;
                      String formattedDate = timestamp != null
                          ? DateFormat('dd-MM-yy').format(timestamp.toDate())
                          : 'Date not available';

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: InkWell(
                          onTap: () => _onCardTapped(event),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    event['eventPoster'] != null &&
                                        event['eventPoster'].isNotEmpty
                                        ? event['eventPoster']
                                        : 'https://via.placeholder.com/150',
                                    width: 120,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ),

                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(
                                        event['eventName'],
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
                                        event['location'],
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
                                        'Time: ${event['selectedTime']}',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .end,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.share,
                                                color: primaryColor),
                                            onPressed: () {
                                              // Construct the message to share
                                              String eventDetails = '''
                                Check out this event: ${event['eventName']}
                                Date: $formattedDate
                                Time: ${event['selectedTime']}
                                Details: ${event['aboutEvent']}
                                ''';

                                              if (event['eventPoster'] !=
                                                  null &&
                                                  event['eventPoster']
                                                      .isNotEmpty) {
                                                eventDetails +=
                                                '\nEvent Poster: ${event['eventPoster']}';
                                              }

                                              Share.share(eventDetails);
                                            },
                                          ),
                                          FavoriteButton(
                                            isFavorited: _isEventFavorited(
                                                event.id),
                                            eventId: event.id,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
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