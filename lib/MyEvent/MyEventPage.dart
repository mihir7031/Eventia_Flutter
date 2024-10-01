import 'package:flutter/material.dart';
import 'package:eventia/main.dart';
import 'package:eventia/Event_info/booking.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:eventia/Event_info/Event_info.dart';
import 'package:eventia/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:eventia/notification/notification.dart';
import 'package:intl/intl.dart';
import 'package:eventia/Favorite/FavoriteButton .dart';
import 'package:eventia/view/drawer.dart';
import 'package:share_plus/share_plus.dart';



class Myeventpage extends StatefulWidget {
  const Myeventpage({super.key});

  @override
  State<Myeventpage> createState() => _MyeventpageState();
}

class _MyeventpageState extends State<Myeventpage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final FocusNode _searchFocusNode = FocusNode();
  List<String> favoriteEventIds = [];
  bool showScheduledEvents = true; // Determines whether to show scheduled or finished events

  @override
  void initState() {
    super.initState();
    _loadFavoriteEvents();
    _fetchUserProfile();
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

  String? userName;
  String? userProfileImage;

  Future<void> _fetchUserProfile() async {
    User? currentUser = auth.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc =
      await firestore.collection('User').doc(currentUser.uid).get();
      if (userDoc.exists) {
        setState(() {
          userName = userDoc['name'];
          userProfileImage = userDoc['imgUrl'];
        });
      }
    }
  }

  void _onCardTapped(DocumentSnapshot event) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Event_info(event: event)),
    );
  }

  @override
  void dispose() {
    _searchFocusNode.dispose(); // Dispose the FocusNode
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // Change this to your desired color
        ),
        backgroundColor: primaryColor,
        title: Text(
          'My Events',
          style: const TextStyle(color: secondaryColor),
        ),
      ),



      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),

                // Row of buttons for switching between Scheduled and Finished Events
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showScheduledEvents = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: showScheduledEvents
                            ? Colors.blue
                            : Colors.grey,
                      ),
                      child: const Text('Scheduled Events'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showScheduledEvents = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: !showScheduledEvents
                            ? Colors.blue
                            : Colors.grey,
                      ),
                      child: const Text('Finished Events'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                StreamBuilder<QuerySnapshot>(
                  stream: firestore
                      .collection('eventss')
                      .where('uid', isEqualTo: auth.currentUser?.uid)
                      .snapshots(), // Only fetch the current user's events
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text('No events found.'),
                      );
                    }

                    var events = snapshot.data!.docs;

                    List<DocumentSnapshot> scheduledEvents = [];
                    List<DocumentSnapshot> finishedEvents = [];

                    for (var event in events) {
                      Timestamp? timestamp =
                      event['selectedDate'] as Timestamp?;

                      if (timestamp != null) {
                        DateTime eventDate = timestamp.toDate();
                        DateTime currentDate = DateTime.now();

                        if (eventDate.isAfter(currentDate)) {
                          scheduledEvents.add(event); // Upcoming events
                        } else {
                          finishedEvents.add(event); // Past events
                        }
                      }
                    }

                    // Select the appropriate list of events based on the button selection
                    var eventsToShow = showScheduledEvents
                        ? scheduledEvents
                        : finishedEvents;

                    if (eventsToShow.isEmpty) {
                      return const Center(
                        child: Text('No events found for this category.'),
                      );
                    }

                    return Column(
                      children: List.generate(eventsToShow.length, (index) {
                        var event = eventsToShow[index];

                        // Check if 'selectedDate' exists and is not null
                        Timestamp? timestamp =
                        event['selectedDate'] as Timestamp?;

                        String formattedDate = 'Date not available';
                        if (timestamp != null) {
                          DateTime dateTime = timestamp.toDate();
                          formattedDate =
                              DateFormat('dd-MM-yy').format(dateTime);
                        }

                        return InkWell(
                          onTap: () => _onCardTapped(event),
                          child: Card(
                            color: cardColor,
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
                                            event['eventPoster']
                                                .isNotEmpty &&
                                            event['eventPoster'] != " "
                                            ? event['eventPoster']
                                            : 'https://via.placeholder.com/150',
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Image.asset(
                                            'assets/images/no_image_available.png',
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
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '$formattedDate  • ${event['selectedTime']}',
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 5.0),
                                        Text(
                                          event['eventName'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                        const SizedBox(height: 5.0),
                                        Text(
                                          event['aboutEvent'],
                                          style: const TextStyle(
                                              color: primaryColor),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                  Icons.share,
                                                  color: primaryColor),
                                              onPressed: () {
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
                                              eventId: event.id,
                                              isFavorited:
                                              _isEventFavorited(event.id),
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
                      }),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),


    );
  }
}