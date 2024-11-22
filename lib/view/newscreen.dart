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

class ScreenMain extends StatefulWidget {
  const ScreenMain({super.key});

  @override
  State<ScreenMain> createState() => _ScreenMainState();
}

class _ScreenMainState extends State<ScreenMain> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  final FocusNode _searchFocusNode = FocusNode();
  List<String> favoriteEventIds = [];
  String _searchQuery = ''; // Added for search
  String _selectedCategory = ''; // Added for category filter

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

  List<Map<String, String>> favoriteEvents = [];

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

  void _showCategoryFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select a Category'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                // Add the category options
                ListTile(
                  title: const Text('Music'),
                  onTap: () {
                    setState(() {
                      _selectedCategory = 'Music';
                    });
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
                ListTile(
                  title: const Text('Sports'),
                  onTap: () {
                    setState(() {
                      _selectedCategory = 'Sports';
                    });
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
                ListTile(
                  title: const Text('Education'),
                  onTap: () {
                    setState(() {
                      _selectedCategory = 'Education';
                    });
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
                ListTile(
                  title: const Text('Technology'),
                  onTap: () {
                    setState(() {
                      _selectedCategory = 'Technology';
                    });
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
                ListTile(
                  title: const Text('Health'),
                  onTap: () {
                    setState(() {
                      _selectedCategory = 'Health';
                    });
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
                ListTile(
                  title: const Text('Entertainment'),
                  onTap: () {
                    setState(() {
                      _selectedCategory = 'Entertainment';
                    });
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
                ListTile(
                  title: const Text('Others'),
                  onTap: () {
                    setState(() {
                      _selectedCategory = 'Others';
                    });
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
                ListTile(
                  title: const Text('All'), // Option to clear the filter
                  onTap: () {
                    setState(() {
                      _selectedCategory = ''; // Clear the category filter
                    });
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
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
        backgroundColor: Colors.white,
        title: const Row(
          children: [
            SizedBox(width: 10),
            Text('E',
                style:
                TextStyle(fontFamily: 'Blacksword', color: primaryColor)),
            Text('ventia',
                style:
                TextStyle(fontFamily: 'BeautyDemo', color: primaryColor)),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Container(
              decoration: const BoxDecoration(
                color: cardColor, // Background color
                shape: BoxShape.circle, // Circular shape
              ),
              child: IconButton(
                icon: const Icon(Icons.notifications, color: primaryColor),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NotificationPage()),
                  );
                },
              ),
            ),
          )
        ],
      ),
      drawer: const DrawerWidget(),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          focusNode: _searchFocusNode,
                          decoration: InputDecoration(
                            hintText: 'Search',
                            prefixIcon:
                            const Icon(Icons.search, color: primaryColor),
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
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.filter_alt_outlined,
                            color: primaryColor),
                        onPressed: () {
                          _showCategoryFilterDialog();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                StreamBuilder<QuerySnapshot>(
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

                    // Filter events based on search query and selected category
                    final List<DocumentSnapshot> filteredEvents = events.where((event) {
                      final eventName = event['eventName']?.toLowerCase() ?? '';
                      final eventCategory = event['category']?.toLowerCase() ?? '';

                      // Check if the event matches the search query
                      final matchesSearch = _searchQuery.isEmpty || eventName.contains(_searchQuery);

                      // Check if the event matches the selected category (or all)
                      final matchesCategory = _selectedCategory.isEmpty || eventCategory == _selectedCategory.toLowerCase();

                      return matchesSearch && matchesCategory; // Only include events that match both conditions
                    }).toList();

                    if (filteredEvents.isEmpty) {
                      return const Center(
                        child: Text('No events available for the selected category.'),
                      );
                    }

                    return Column(
                      children: List.generate(filteredEvents.length, (index) {
                        var event = filteredEvents[index];

                        // Check if 'selectedDate' exists and is not null
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
                                            : 'https://via.placeholder.com/150', // Placeholder image URL
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
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
                                              icon: const Icon(Icons.share,
                                                  color: primaryColor),
                                              onPressed: () {
                                                // Construct the message you want to share
                                                String eventDetails = '''
                                                          Check out this event: ${event['eventName']}
                                                          Date: $formattedDate
                                                          Time: ${event['selectedTime']}
                                                          Details: ${event['aboutEvent']}
                                                          ''';

                                                // If eventPoster is available, include the link as well
                                                if (event['eventPoster'] != null &&
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
                                        )
                                      ],
                                    ),
                                  ),
                                )
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
