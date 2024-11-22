import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:eventia/LoginPages/login.dart';
import 'package:eventia/profile/Edit_Profile.dart';
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
  bool _isUploading = false;

  /// Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      await _uploadImage();
    }
  }

  /// Function to upload the image to Firebase Storage
  Future<void> _uploadImage() async {
    if (_imageFile == null) return;

    setState(() {
      _isUploading = true; // Show loading indicator during upload
    });

    try {
      User? currentUser = auth.currentUser;
      if (currentUser != null) {
        String fileName = '${currentUser.uid}.jpg';
        UploadTask uploadTask = storage.ref().child('user_profiles/$fileName').putFile(_imageFile!);

        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();

        // Update user profile image URL in Firestore
        await firestore.collection('User').doc(currentUser.uid).update({'imgUrl': downloadUrl});
      }
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
    } finally {
      setState(() {
        _isUploading = false; // Hide loading indicator after upload
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = auth.currentUser;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.onPrimary,
      appBar: AppBar(
        backgroundColor: colorScheme.secondary,
        elevation: 0,
        title: Text(
          'Profile',
          style: textTheme.titleLarge?.copyWith(color: colorScheme.onSecondary),
        ),
        centerTitle: true,
      ),
      body: currentUser == null
          ? _buildLoginPrompt(colorScheme, textTheme)
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

              return _buildProfileContent(
                userName: userName,
                userEmail: userEmail,
                userProfileImage: userProfileImage,
                birthdate: birthdate,
                profession: profession,
                city: city,
                state: state,
                aboutMe: aboutMe,
                language: language,
                colorScheme: colorScheme,
                textTheme: textTheme,
              );
            },
          );
        },
      ),
    );
  }

  /// Builds the content of the profile page
  Widget _buildProfileContent({
    required String? userName,
    required String? userEmail,
    required String? userProfileImage,
    required String? birthdate,
    required String? profession,
    required String? city,
    required String? state,
    required String? aboutMe,
    required String? language,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(userName, userProfileImage, colorScheme, textTheme),
            const SizedBox(height: 30.0),
            _buildProfileDetailRow('Name', userName ?? 'N/A', Icons.person, colorScheme.primary),
            _buildProfileDetailRow('Email', userEmail ?? 'N/A', Icons.email, colorScheme.primary),
            _buildProfileDetailRow('Birthday', birthdate ?? 'N/A', Icons.cake, colorScheme.primary),
            _buildProfileDetailRow('Profession', profession ?? 'N/A', Icons.work, colorScheme.primary),
            _buildProfileDetailRow('Location', city != null && state != null ? '$city, $state' : 'N/A', Icons.location_on, colorScheme.primary),
            _buildProfileDetailRow('About Me', aboutMe ?? 'N/A', Icons.info, colorScheme.primary),
            _buildProfileDetailRow('Language', language ?? 'N/A', Icons.language, colorScheme.primary),
            _buildDivider(),
            _buildEditButton(colorScheme.primary, textTheme),
          ],
        ),
      ),
    );
  }

  /// Builds the profile header with avatar and username
  Widget _buildProfileHeader(String? userName, String? userProfileImage, ColorScheme colorScheme, TextTheme textTheme) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: colorScheme.onSurface.withOpacity(0.2),
            backgroundImage: userProfileImage != null && userProfileImage.isNotEmpty ? NetworkImage(userProfileImage) : null,
            child: userProfileImage == null || userProfileImage.isEmpty
                ? Text(
              userName != null && userName.isNotEmpty ? userName[0].toUpperCase() : '',
              style: textTheme.headlineLarge?.copyWith(color: colorScheme.onSurface),
            )
                : null,
          ),
          if (_isUploading)
            Positioned(
              bottom: 0,
              right: -10,
              child: CircularProgressIndicator(),
            )
          else
            Positioned(
              bottom: 0,
              right: -10,
              child: _buildUploadButton(colorScheme),
            ),
        ],
      ),
    );
  }

  /// Builds a profile detail row with label and value
  Widget _buildProfileDetailRow(String label, String value, IconData icon, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 28.0),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4.0),
                Text(
                  value,
                  style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a divider for spacing between profile sections
  Widget _buildDivider() {
    return const Divider(color: Color(0xFFDDDDDD), thickness: 1.0);
  }

  /// Builds the Edit Profile button
  Widget _buildEditButton(Color buttonColor, TextTheme textTheme) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        ),
        onPressed: () {
          // Navigate to profile edit page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserInfoForm()),
          );
        },
        child: Text(
          'Edit Profile',
          style: textTheme.bodyLarge?.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  /// Builds a button for uploading a profile picture
  Widget _buildUploadButton(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.primary,
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
        icon: Icon(Icons.camera_alt, color: colorScheme.onPrimary),
        onPressed: _pickImage,
      ),
    );
  }

  /// Builds a prompt for users to log in if they're not authenticated
  Widget _buildLoginPrompt(ColorScheme colorScheme, TextTheme textTheme) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.secondary,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        ),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LogIn()),
          );
        },

        child: Text(
          'Please log in',
          style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSecondary),
        ),
      ),
    );
  }
}
