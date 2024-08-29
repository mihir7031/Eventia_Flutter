import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?>? userProfileFuture;

  @override
  void initState() {
    super.initState();
    userProfileFuture = _fetchUserProfile();
  }

  Future<Map<String, dynamic>?> _fetchUserProfile() async {
    User? currentUser = auth.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc =
      await firestore.collection('User').doc(currentUser.uid).get();
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>?;
      }
    }
    return null; // If no user or no document found
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = auth.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFE9EEEA), // Primary background color
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Color(0xFF333333), // Darker text color for better contrast
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
          : FutureBuilder<Map<String, dynamic>?>(
        future: userProfileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading profile.'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Profile not found.'));
          }

          var userProfile = snapshot.data!;
          String? userName = userProfile['name'];
          String? userEmail = userProfile['email'];
          String? userProfileImage = userProfile['imgUrl'];

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 24.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Avatar
                  Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          radius: 60.0,
                          backgroundColor:
                          const Color(0xFFB2BBAF), // Background color for avatar
                          backgroundImage: userProfileImage != null
                              ? NetworkImage(userProfileImage)
                              : null,
                          child: userProfileImage == null
                              ? const Icon(Icons.person,
                              size: 60, color: Colors.grey)
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: -10,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(
                                  0xE9A908A1), // Color for edit button
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 10.0,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.edit,
                                  color: Colors.white),
                              onPressed: () {
                                // Handle avatar edit
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  // User Info with Icons
                  _buildUserInfoWithIcon(
                      Icons.person, userName ?? 'Name not available'),
                  _buildDivider(),
                  _buildUserInfoWithIcon(
                      Icons.email, userEmail ?? 'Email not available'),
                  _buildDivider(),

                  // Other static info for now, you can update these as needed
                  _buildUserInfoWithIcon(Icons.cake, 'January 1, 1990'),
                  _buildDivider(),
                  _buildUserInfoWithIcon(
                      Icons.location_on, 'New York, USA'),
                  _buildDivider(),

                  // User Description
                  const SizedBox(height: 20.0),
                  const Text(
                    'About Me',
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  const Text(
                    'A passionate event organizer with a love for bringing people together. Enjoys traveling and exploring new cultures, and always looking for new experiences and opportunities to learn.',
                    style: TextStyle(
                      color: Color(0xFF555555),
                      fontSize: 16.0,
                    ),
                  ),
                  _buildDivider(),

                  // Occupation
                  const SizedBox(height: 20.0),
                  _buildUserInfoWithIcon(Icons.work, 'Event Coordinator'),
                  _buildDivider(),

                  // Social Media Links
                  const SizedBox(height: 20.0),
                  const Text(
                    'Social Media',
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSocialMediaIcon(
                          FontAwesomeIcons.facebook,
                          'Facebook',
                          'https://facebook.com/johndoe',
                          const Color(0xFF1877F2)),
                      _buildSocialMediaIcon(
                          FontAwesomeIcons.instagram,
                          'Instagram',
                          'https://instagram.com/johndoe',
                          const Color(0xFFC13584)),
                      _buildSocialMediaIcon(
                          FontAwesomeIcons.twitter,
                          'Twitter',
                          'https://twitter.com/johndoe',
                          const Color(0xFF1DA1F2)),
                      _buildSocialMediaIcon(
                          FontAwesomeIcons.linkedin,
                          'LinkedIn',
                          'https://linkedin.com/in/johndoe',
                          const Color(0xFF0077B5)),
                    ],
                  ),
                  _buildDivider(),

                  // Address
                  const SizedBox(height: 20.0),
                  _buildUserInfoWithIcon(Icons.home,
                      '123 Main Street, Apt 4B, New York, NY 10001'),
                  _buildDivider(),

                  // Preferences
                  const SizedBox(height: 20.0),
                  const Text(
                    'Preferences',
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  const Text(
                    '• Music\n• Sports\n• Traveling\n• Technology\n• Food',
                    style: TextStyle(
                      color: Color(0xFF555555),
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 30.0),

                  // Edit Profile Button with new color
                  _buildEditButton(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserInfoWithIcon(IconData icon, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF333333), // Darker icon color
            size: 24.0,
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF555555), // Medium-dark text color for readability
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      color: Color(0xFFCCCCCC), // Light gray divider color
      thickness: 1.0,
    );
  }

  Widget _buildSocialMediaIcon(
      IconData icon, String name, String url, Color color) {
    return IconButton(
      icon: Icon(icon, color: color, size: 30.0),
      onPressed: () {
        // Handle social media navigation
      },
    );
  }

  Widget _buildEditButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        gradient: const LinearGradient(
          colors: [
            Color(0xCFD00557),
            Color(0xE9A908A1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10.0,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextButton(
        onPressed: () {
          // Handle edit profile action
        },
        child: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
