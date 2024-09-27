import 'package:eventia/LoginPages/login.dart';
import 'package:flutter/material.dart';
import 'package:eventia/Favorite/favorit_page.dart';
import 'package:eventia/view/profile.dart';
import 'package:eventia/Event_info/Event_info.dart';
import 'package:eventia/Add_event/CreateEventForm.dart';
import 'package:eventia/main.dart';
import 'package:eventia/MyEvent/MyEventPage.dart';
import 'package:eventia/joinedEvent/joinedEvent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:eventia/notification/notification.dart';
import 'package:intl/intl.dart';
import 'package:eventia/Favorite/FavoriteButton .dart';
import 'package:eventia/view/drawer.dart';
import 'dart:io';

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


  Future<void> _toggleFavorite(String eventId) async {
    final userDoc =
    firestore.collection('favourite').doc(auth.currentUser?.uid);
    final isFavorited = favoriteEventIds.contains(eventId);

    // Optimistically update the local state to reflect the change without waiting for Firestore
    setState(() {
      if (isFavorited) {
        favoriteEventIds.remove(eventId);
      } else {
        favoriteEventIds.add(eventId);
      }
    });

    try {
      // Update Firestore
      if (isFavorited) {
        // If it's already a favorite, remove it
        await userDoc.update({
          'events': FieldValue.arrayRemove([eventId])
        });
      } else {
        // Otherwise, add it to favorites
        await userDoc.update({
          'events': FieldValue.arrayUnion([eventId])
        });
      }
    } catch (e) {
      // In case of error, revert the optimistic update
      setState(() {
        if (isFavorited) {
          favoriteEventIds.add(eventId);
        } else {
          favoriteEventIds.remove(eventId);
        }
      });
    }
  }

  bool _isEventFavorited(String eventId) {
    return favoriteEventIds.contains(eventId);
  }

  int _selectedIndex = 0;
  List<Map<String, String>> favoriteEvents = [];

  String? userName;
  String? userProfileImage;

  // @override
  // void initState() {
  //   super.initState();
  //   _fetchUserProfile();
  // }

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

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      _uploadImage(File(pickedImage.path));
    }
  }

  Future<void> _uploadImage(File image) async {
    User? currentUser = auth.currentUser;
    if (currentUser != null) {
      String userId = currentUser.uid;
      String imagePath = 'user_profiles/$userId.jpg';

      try {
        // Upload image to Firebase Storage
        UploadTask uploadTask = storage.ref(imagePath).putFile(image);
        TaskSnapshot snapshot = await uploadTask;

        // Get the download URL
        String downloadUrl = await snapshot.ref.getDownloadURL();

        // Update Firestore with the new image URL
        await firestore.collection('User').doc(userId).update({
          'imgUrl': downloadUrl,
        });

        // Update local state
        setState(() {
          userProfileImage = downloadUrl;
        });
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

  Future<void> _addFavoriteEvent(String eventId) async {
    User? currentUser = auth.currentUser;
    if (currentUser != null) {
      String userId = currentUser.uid;
      DocumentReference favoriteRef =
          firestore.collection('favourite').doc(userId);

      try {
        // Get the document for the current user in the "favourite" collection
        DocumentSnapshot docSnapshot = await favoriteRef.get();

        if (docSnapshot.exists) {
          // Document exists, update the array if the event is not already in the list
          List<dynamic> favoriteEvents = docSnapshot['events'] ?? [];

          if (!favoriteEvents.contains(eventId)) {
            await favoriteRef.update({
              'events': FieldValue.arrayUnion([eventId]),
            });

            // Optionally, update the local state
            setState(() {
              this.favoriteEvents.add({'id': eventId});
            });
          } else {
            print('Event is already favorited by the user.');
          }
        } else {
          // Document does not exist, create it and add the event to the array
          await favoriteRef.set({
            'userId': userId,
            'events': [eventId], // Create an array with the eventId
            'addedAt': FieldValue.serverTimestamp(),
          });

          // Optionally, update the local state
          setState(() {
            this.favoriteEvents.add({'id': eventId});
          });
        }
      } catch (e) {
        print('Error adding favorite: $e');
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
      drawer:const DrawerWidget(),
      // Drawer(
      //   backgroundColor: Colors.white,
      //   child: ListView(
      //     padding: EdgeInsets.zero,
      //     children: <Widget>[
      //       UserAccountsDrawerHeader(
      //         decoration: const BoxDecoration(
      //           color: primaryColor,
      //         ),
      //         accountName: StreamBuilder<DocumentSnapshot>(
      //           stream: firestore
      //               .collection('User')
      //               .doc(auth.currentUser?.uid)
      //               .snapshots(),
      //           builder: (context, snapshot) {
      //             if (snapshot.connectionState == ConnectionState.waiting) {
      //               return const Text('Loading...',
      //                   style: TextStyle(color: Colors.white));
      //             }
      //             if (snapshot.hasData && snapshot.data!.exists) {
      //               final userDoc = snapshot.data!;
      //               final name = userDoc['name'] ?? 'Add name';
      //               return Text(name,
      //                   style: const TextStyle(color: Colors.white));
      //             }
      //             return const Text('Add name',
      //                 style: TextStyle(color: Colors.white));
      //           },
      //         ),
      //         accountEmail: Text(
      //           auth.currentUser?.email ?? 'Add email',
      //           style: const TextStyle(color: Colors.white),
      //         ),
      //         currentAccountPicture: StreamBuilder<DocumentSnapshot>(
      //           stream: firestore
      //               .collection('User')
      //               .doc(auth.currentUser?.uid)
      //               .snapshots(),
      //           builder: (context, snapshot) {
      //             if (snapshot.connectionState == ConnectionState.waiting) {
      //               return const CircleAvatar(
      //                 backgroundColor: Colors.white,
      //                 child: CircularProgressIndicator(),
      //               );
      //             }
      //             if (snapshot.hasData && snapshot.data!.exists) {
      //               final userDoc = snapshot.data!;
      //               final imgUrl = userDoc['imgUrl'] ?? '';
      //               final name = userDoc['name'] ?? '';
      //
      //               return Stack(
      //                 children: [
      //                   CircleAvatar(
      //                     radius: 50,
      //                     backgroundColor: Colors.white,
      //                     backgroundImage:
      //                         imgUrl.isNotEmpty ? NetworkImage(imgUrl) : null,
      //                     child: imgUrl.isEmpty
      //                         ? Text(
      //                             name.isNotEmpty ? name[0].toUpperCase() : '',
      //                             style: const TextStyle(
      //                                 fontSize: 40.0, color: primaryColor),
      //                           )
      //                         : null,
      //                   ),
      //                   Positioned(
      //                     bottom: 0,
      //                     right: 0,
      //                     child: Container(
      //                       width: 25,
      //                       height: 25,
      //                       decoration: const BoxDecoration(
      //                         color: cardColor,
      //                         shape: BoxShape.circle,
      //                       ),
      //                       child: IconButton(
      //                         icon: const Icon(
      //                           Icons.edit,
      //                           color: primaryColor,
      //                           size: 12,
      //                         ),
      //                         onPressed: _pickImage,
      //                       ),
      //                     ),
      //                   ),
      //                 ],
      //               );
      //             }
      //             return const CircleAvatar(
      //               radius: 50,
      //               backgroundColor: Colors.white,
      //               child: const Text(
      //                 'U',
      //                 style: TextStyle(fontSize: 40.0, color: primaryColor),
      //               ),
      //             );
      //           },
      //         ),
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.person),
      //         title: const Text('Profile'),
      //         onTap: () {
      //           Navigator.pop(context);
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(builder: (context) => const ProfilePage()),
      //           );
      //         },
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.event),
      //         title: const Text('My Events'),
      //         onTap: () {
      //           Navigator.pop(context);
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(builder: (context) => const MyEventPage()),
      //           );
      //         },
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.event_available),
      //         title: const Text('Joined Events'),
      //         onTap: () {
      //           Navigator.pop(context);
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(builder: (context) => const JoinedEvent()),
      //           );
      //         },
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.settings),
      //         title: const Text('Settings'),
      //         onTap: () {
      //           Navigator.pop(context);
      //           // Handle Settings action
      //         },
      //       ),
      //       auth.currentUser != null
      //           ? ListTile(
      //               leading: const Icon(Icons.logout),
      //               title: const Text('Sign Out'),
      //               onTap: () async {
      //                 await auth.signOut();
      //                 setState(() {
      //                   userName = null;
      //                   userProfileImage = null;
      //                 });
      //                 Navigator.pop(context);
      //               },
      //             )
      //           : ListTile(
      //               leading: const Icon(Icons.login),
      //               title: const Text('Sign In'),
      //               onTap: () {
      //                 Navigator.pop(context);
      //                 Navigator.push(
      //                   context,
      //                   MaterialPageRoute(builder: (context) => const LogIn()),
      //                 );
      //               },
      //             ),
      //     ],
      //   ),
      // ),
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
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.filter_alt_outlined,
                            color: primaryColor),
                        onPressed: () {
                          // Handle filter icon press
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

                    return Column(
                      children: List.generate(events.length, (index) {
                        var event = events[index];

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
                                                // Handle share logic
                                              },
                                            ),
                                            FavoriteButton(
                                              eventId: event.id,
                                              isFavorited: _isEventFavorited(event.id),
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
