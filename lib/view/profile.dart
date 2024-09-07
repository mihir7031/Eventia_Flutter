import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:eventia/profile_info_gathering/profile_info_taking.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  File? _imageFile;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      await _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) return;

    User? currentUser = auth.currentUser;
    if (currentUser != null) {
      String fileName = '${currentUser.uid}.jpg';
      UploadTask uploadTask = storage.ref().child('user_profiles/$fileName').putFile(_imageFile!);

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      await firestore.collection('User').doc(currentUser.uid).update({'imgUrl': downloadUrl});
    }
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = auth.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Color(0xFF333333),
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: currentUser == null
          ? Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to login page
          },
          child: const Text('Please log in'),
        ),
      )
          : StreamBuilder<DocumentSnapshot>(
        stream: firestore.collection('User').doc(currentUser.uid).snapshots(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (userSnapshot.hasError) {
            return Center(
              child: Text('Error loading profile: ${userSnapshot.error}'),
            );
          } else if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
            return const Center(child: Text('Profile not found.'));
          }

          var userData = userSnapshot.data!.data() as Map<String, dynamic>;
          String? userName = userData['name'];
          String? userEmail = userData['email'];
          String? userProfileImage = userData['imgUrl'];

          return StreamBuilder<DocumentSnapshot>(
            stream: firestore.collection('User_profile').doc(currentUser.uid).snapshots(),
            builder: (context, profileSnapshot) {
              if (profileSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (profileSnapshot.hasError) {
                return Center(
                  child: Text('Error loading profile: ${profileSnapshot.error}'),
                );
              }

              var profileData = profileSnapshot.data?.data() as Map<String, dynamic>? ?? {};
              String? birthdate = profileData['birthdate'];
              String? profession = profileData['profession'];
              String? city = profileData['city'];
              String? state = profileData['state'];
              String? aboutMe = profileData['aboutMe'];
              String? language = profileData['language'];

              List<Widget> profileWidgets = [
                Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: userProfileImage != null && userProfileImage.isNotEmpty
                            ? NetworkImage(userProfileImage)
                            : null,
                        child: userProfileImage == null || userProfileImage.isEmpty
                            ? Text(
                          userName != null && userName.isNotEmpty ? userName[0].toUpperCase() : '',
                          style: const TextStyle(fontSize: 40.0, color: Colors.grey),
                        )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: -10,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.pinkAccent,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 6.0,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt, color: Colors.white),
                            onPressed: _pickImage,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                Center(
                  child: Text(
                    userName ?? 'Name not available',
                    style: const TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    userEmail ?? 'Email not available',
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),
              ];

              if (birthdate != null) {
                profileWidgets.addAll([
                  _buildProfileOption(icon: Icons.cake, label: 'Birthday', value: birthdate),
                  _buildDivider(),
                ]);
              }

              if (profession != null) {
                profileWidgets.addAll([
                  _buildProfileOption(icon: Icons.work, label: 'Profession', value: profession),
                  _buildDivider(),
                ]);
              }

              if (city != null && state != null) {
                profileWidgets.addAll([
                  _buildProfileOption(icon: Icons.location_on, label: 'Location', value: '$city, $state'),
                  _buildDivider(),
                ]);
              }

              if (aboutMe != null) {
                profileWidgets.addAll([
                  const Text(
                    'About Me',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    aboutMe,
                    style: const TextStyle(fontSize: 16.0, color: Color(0xFF555555)),
                  ),
                  const SizedBox(height: 20.0),
                ]);
              }

              if (language != null) {
                profileWidgets.addAll([
                  _buildProfileOption(icon: Icons.language, label: 'Language', value: language),
                  _buildDivider(),
                ]);
              }

              profileWidgets.add(
                _buildEditButton(),
              );

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: profileWidgets,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildProfileOption({required IconData icon, required String label, required String value}) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.grey,
          size: 28.0,
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0),
      child: Divider(
        color: Color(0xFFDDDDDD),
        thickness: 1.0,
      ),
    );
  }

  Widget _buildEditButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  UserInfoForm()),
          );
        },
        child: const Text('Edit Profile'),
      ),
    );
  }
}
