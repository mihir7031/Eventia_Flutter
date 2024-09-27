// drawer_widget.dart
import 'package:eventia/main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:eventia/view/profile.dart';
import 'package:eventia/MyEvent/MyEventPage.dart';
import 'package:eventia/joinedEvent/joinedEvent.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? userName;
  String? userProfileImage;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

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
        UploadTask uploadTask = FirebaseStorage.instance.ref(imagePath).putFile(image);
        TaskSnapshot snapshot = await uploadTask;

        String downloadUrl = await snapshot.ref.getDownloadURL();

        await firestore.collection('User').doc(userId).update({
          'imgUrl': downloadUrl,
        });

        setState(() {
          userProfileImage = downloadUrl;
        });
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: primaryColor,
            ),
            accountName: StreamBuilder<DocumentSnapshot>(
              stream: firestore.collection('User').doc(auth.currentUser?.uid).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Loading...', style: TextStyle(color: Colors.white));
                }
                if (snapshot.hasData && snapshot.data!.exists) {
                  final userDoc = snapshot.data!;
                  final name = userDoc['name'] ?? 'Add name';
                  return Text(name, style: const TextStyle(color: Colors.white));
                }
                return const Text('Add name', style: TextStyle(color: Colors.white));
              },
            ),
            accountEmail: Text(
              auth.currentUser?.email ?? 'Add email',
              style: const TextStyle(color: Colors.white),
            ),
            currentAccountPicture: StreamBuilder<DocumentSnapshot>(
              stream: firestore.collection('User').doc(auth.currentUser?.uid).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasData && snapshot.data!.exists) {
                  final userDoc = snapshot.data!;
                  final imgUrl = userDoc['imgUrl'] ?? '';
                  final name = userDoc['name'] ?? '';

                  return Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        backgroundImage: imgUrl.isNotEmpty ? NetworkImage(imgUrl) : null,
                        child: imgUrl.isEmpty
                            ? Text(
                          name.isNotEmpty ? name[0].toUpperCase() : '',
                          style: const TextStyle(fontSize: 40.0, color: Colors.blue),
                        )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 25,
                          height: 25,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.edit, size: 12),
                            onPressed: _pickImage,
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Text(
                    'U',
                    style: TextStyle(fontSize: 40.0, color: Colors.blue),
                  ),
                );
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.event),
            title: const Text('My Events'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const MyEventPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.event_available),
            title: const Text('Joined Events'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const JoinedEvent()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              // Handle Settings action
            },
          ),
          auth.currentUser != null
              ? ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign Out'),
            onTap: () async {
              await auth.signOut();
              Navigator.pop(context);
            },
          )
              : ListTile(
            leading: const Icon(Icons.login),
            title: const Text('Sign In'),
            onTap: () {
              Navigator.pop(context);
              // Handle Sign In action
            },
          ),
        ],
      ),
    );
  }
}
