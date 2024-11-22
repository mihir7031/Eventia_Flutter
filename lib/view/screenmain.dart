import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eventia/Event_info/Event_info.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:eventia/Favorite/FavoriteButton .dart';
import 'package:intl/intl.dart';
import 'package:eventia/main.dart';
import 'package:eventia/view/drawer.dart';// To format the date4
import 'package:eventia/profile/profile.dart';

class ScreenMain extends StatefulWidget {
  const ScreenMain({super.key});

  @override
  State<ScreenMain> createState() => _ScreenMainState();
}

class _ScreenMainState extends State<ScreenMain> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String _searchQuery = '';
  String? userName;
  String? userProfileImage;
  String _selectedCategory = 'All';
  List<String> favoriteEventIds = [];
  final List<String> categories = [
    'All',
    'Education',
    'Sports',
    'Music Festival',
    'Festival Arts',
    'Technology',
    'Others',
  ];

  final Map<String, IconData> categoryIcons = {
    'All': FontAwesomeIcons.solidCalendarAlt,
    'Education': FontAwesomeIcons.school,
    'Sports': FontAwesomeIcons.basketballBall,
    'Music Festival': FontAwesomeIcons.music,
    'Festival Arts': FontAwesomeIcons.theaterMasks,
    'Technology': FontAwesomeIcons.laptopCode,
    'Others': FontAwesomeIcons.cogs,
  };

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

  String _formatDate(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return DateFormat('dd/MM/yyyy').format(date);
  }

  void _onCardTapped(DocumentSnapshot event) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Event_info(event: event)),
    );
  }

  void _shareEvent(DocumentSnapshot event) {
    final eventName = event['eventName'];
    final eventLink = "https://example.com/events/${event.id}"; // Replace with actual link
    final shareText = "Check out this event: $eventName!\n$eventLink";

    Share.share(shareText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      appBar:  AppBar(
        title: Text(
          'Eventia',
          style: TextStyle(
            fontFamily: 'Blacksword',
            fontSize: 24,
            color: primaryColor,
          ),
        ),
        backgroundColor: Colors.white,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
            child: CircleAvatar(
              backgroundImage: userProfileImage != null
                  ? NetworkImage(userProfileImage!)
                  : null, // Set to null if no image is available
              child: userProfileImage == null
                  ? Icon(
                Icons.person, // Use the person icon
                color: primaryColor,
              )
                  : null, // No child if the image is available
              backgroundColor: userProfileImage == null ? Colors.grey : Colors.transparent,
            ),

          ),
          SizedBox(width: 16),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search events...',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.trim().toLowerCase();
                      });
                    },
                  ),
                ),

                // Filter by Category

                const SizedBox(height: 20),

                // Popular Events Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Popular Events',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                // Added expanded height to prevent overflow and ensure scrollable content
                Container(
                  height: 270,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: firestore
                        .collection('eventss')
                        .where('isPopular', isEqualTo: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text(
                            'No popular events found.',
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      }
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var event = snapshot.data!.docs[index];
                          return InkWell(
                            onTap: () => _onCardTapped(event),
                            child: Container(
                              width: 220,
                              margin: const EdgeInsets.all(10.0),
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      event['eventPoster'] ?? 'https://via.placeholder.com/150',
                                      fit: BoxFit.cover,
                                      height: 170,
                                      width: double.infinity,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                event['eventName'],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                event['location'],
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
                                        IconButton(
                                          icon: Icon(Icons.share, color: iconColor),
                                          onPressed: () => _shareEvent(event),
                                        ),
                                        FavoriteButton(
                                          isFavorited: _isEventFavorited(
                                              event.id),
                                          eventId: event.id,
                                        ),
                                      ],
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
                ),
SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: categories.map((category) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            avatar: Icon(
                              categoryIcons[category],
                              size: 20,
                              color: _selectedCategory == category
                                  ? Colors.white
                                  : primaryColor,
                            ),
                            label: Text(category,style: TextStyle(color: textColor),),
                            selected: _selectedCategory == category,
                            onSelected: (selected) {
                              setState(() {
                                _selectedCategory = selected ? category : 'All';
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                SizedBox(height: 20,),
                // All Events Section (Search Functionality Active)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    _selectedCategory,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: firestore
                      .collection('eventss')
                      .where(
                    'category',
                    isEqualTo: _selectedCategory == 'All' ? null : _selectedCategory,
                  )
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text(
                          'No events found.',
                          style: TextStyle(color: Colors.black),
                        ),
                      );
                    }

                    final events = snapshot.data!.docs;

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final event = events[index];

                        // Filter events by search query
                        if (_searchQuery.isNotEmpty &&
                            !event['eventName'].toLowerCase().contains(_searchQuery)) {
                          return const SizedBox.shrink();
                        }

                        final String formattedDate = _formatDate(event['selectedDate']);
                        final String eventPoster = event['eventPoster'] ?? 'https://via.placeholder.com/150';

                        return InkWell(
                          onTap: () => _onCardTapped(event),
                          child: Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      eventPoster,
                                      width: 120,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
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
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.share, color: iconColor),
                                              onPressed: () {
                                                // Construct the message to share
                                                String eventDetails = '''
                                Check out this event: ${event['eventName']}
                                Date: $formattedDate
                                Time: ${event['selectedTime']}
                                Details: ${event['aboutEvent']}
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
                                              isFavorited: _isEventFavorited(event.id),
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

              ],
            ),
          ),
        ),
      ),
    );
  }
}