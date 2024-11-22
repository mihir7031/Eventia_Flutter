import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eventia/Event_info/Event_info.dart';
import 'package:eventia/main.dart';
import 'package:share_plus/share_plus.dart';
import 'package:eventia/Favorite/FavoriteButton .dart';
import 'package:intl/intl.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> _removeFromFavorites(String eventId) async {
    final userDoc = firestore.collection('favourite').doc(auth.currentUser?.uid);

    try {
      await userDoc.update({
        'events': FieldValue.arrayRemove([eventId])
      });
      setState(() {});  // Refresh the page to reflect the changes
    } catch (e) {
      // Handle errors (e.g., show a Snackbar with the error message)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove from favorites: $e')),
      );
    }
  }

  void _showRemoveDialog(String eventId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove from Favorites'),
          content: const Text('Are you sure you want to remove this event from your favorites?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();  // Close the dialog
                _removeFromFavorites(eventId);  // Remove the event from favorites
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Favorite Events',
          style: TextStyle(color: primaryColor),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: firestore.collection('favourite').doc(auth.currentUser?.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No favorite events found.'));
          }

          final favoriteData = snapshot.data!.data() as Map<String, dynamic>;
          final eventIds = List<String>.from(favoriteData['events'] ?? []);

          if (eventIds.isEmpty) {
            return const Center(child: Text('No favorite events found.'));
          }

          return FutureBuilder<QuerySnapshot>(
            future: firestore.collection('eventss').where(FieldPath.documentId, whereIn: eventIds).get(),
            builder: (context, eventSnapshot) {
              if (eventSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!eventSnapshot.hasData || eventSnapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No events found.'));
              }

              final events = eventSnapshot.data!.docs;


              return ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  Timestamp? timestamp = event['selectedDate'] as Timestamp?;

                  // If the timestamp is null, show a default message
                  String formattedDate;
                  if (timestamp != null) {
                    DateTime dateTime = timestamp.toDate();
                    formattedDate = DateFormat('dd-MM-yy').format(dateTime);
                  } else {
                    formattedDate = 'Date not available'; // Handle null date
                  }

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Event_info(event: event),
                        ),
                      );
                    },

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
                                      event['eventPoster'].isNotEmpty &&
                                      event['eventPoster'] != " "
                                      ? event['eventPoster']
                                      : 'https://via.placeholder.com/150', // Placeholder image URL width: 120,
                                  width: 120,
                                  height: 150,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/images/no_image_available.png', // Path to your placeholder image in assets
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
                                  const SizedBox(height: 5.0),
                                  // Text(
                                  //   event['organizerInfo'],
                                  //   style: const TextStyle(color: primaryColor),
                                  // ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.share,
                                            color: iconColor),
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
                                        isFavorited: true,
                                        eventId: event.id,
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
          );
        },
      ),
    );
  }
}
