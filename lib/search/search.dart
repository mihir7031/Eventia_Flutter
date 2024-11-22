import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:eventia/Favorite/FavoriteButton .dart';
import 'package:share_plus/share_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eventia/main.dart';
import 'package:eventia/Event_info/Event_info.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FocusNode _searchFocusNode = FocusNode();
  final FirebaseAuth auth = FirebaseAuth.instance;
  String _searchQuery = '';
  List<String> favoriteEventIds = [];
  List<String> searchHistory = [];

  @override
  void dispose() {
    _searchFocusNode.dispose(); // Dispose the FocusNode when the page is closed
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadFavoriteEvents();
    _loadSearchHistory(); // Load the search history on initialization
  }

  Future<void> _loadFavoriteEvents() async {
    final userDoc = await firestore.collection('favourite').doc(auth.currentUser?.uid).get();
    if (userDoc.exists) {
      final favoriteData = userDoc.data() as Map<String, dynamic>?;
      setState(() {
        favoriteEventIds = List<String>.from(favoriteData?['events'] ?? []);
      });
    }
  }

  Future<void> _loadSearchHistory() async {
    final userDoc = await firestore.collection('searchHistory').doc(auth.currentUser?.uid).get();
    if (userDoc.exists) {
      final searchData = userDoc.data() as Map<String, dynamic>?;
      setState(() {
        searchHistory = List<String>.from(searchData?['history'] ?? []);
      });
    }
  }

  Future<void> _saveSearchHistory(String query) async {
    searchHistory.insert(0, query); // Add the new search query to the beginning
    if (searchHistory.length > 5) {
      searchHistory = searchHistory.sublist(0, 5); // Keep only the latest 5
    }
    await firestore.collection('searchHistory').doc(auth.currentUser?.uid).set({
      'history': searchHistory,
    });
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
      appBar: AppBar(
        title: const Text('Search Events',style: TextStyle(color: primaryColor),),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      focusNode: _searchFocusNode,
                      decoration: InputDecoration(
                        hintText: 'Search for events...',
                        hintStyle: TextStyle(color: textColor),
                        prefixIcon: const Icon(Icons.search, color: primaryColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none, // No border when focused
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value.trim().toLowerCase(); // Normalize input
                        });
                      },
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          _saveSearchHistory(value); // Save the query to history
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _searchQuery.isEmpty
                  ? _buildSearchHistory() // Show search history when query is empty
                  : _buildEventList(), // Show events based on the search query
            ),
          ],
        ),
      ),
    );
  }

  // Function to build the search history list
  // Function to build the search history list
  Widget _buildSearchHistory() {
    return ListView.builder(
      itemCount: searchHistory.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(
            Icons.history, // Icon for history items
            color: primaryColor, // You can adjust the color as needed
          ),
          title: Text(searchHistory[index],style: TextStyle(color: textColor),),
          onTap: () {
            setState(() {
              _searchQuery = searchHistory[index];
            });
          },
        );
      },
    );
  }


  // Function to build the list of events
  Widget _buildEventList() {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection('eventss').snapshots(),
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

        // Filter events based on search query
        var filteredEvents = events.where((event) {
          String eventName = (event['eventName'] as String).trim().toLowerCase();
          return eventName.contains(_searchQuery);
        }).toList();

        if (filteredEvents.isEmpty) {
          return const Center(
            child: Text('No events found.'),
          );
        }

        return ListView.builder(
          itemCount: filteredEvents.length,
          itemBuilder: (context, index) {
            var event = filteredEvents[index];

            Timestamp? timestamp = event['selectedDate'] as Timestamp?;
            String formattedDate;
            if (timestamp != null) {
              DateTime dateTime = timestamp.toDate();
              formattedDate = DateFormat('dd-MM-yy').format(dateTime);
            } else {
              formattedDate = 'Date not available';
            }

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
    );
  }
}
