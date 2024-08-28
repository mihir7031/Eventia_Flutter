import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9EEEA), // Primary background color
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Avatar
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const CircleAvatar(
                      radius: 60.0,
                      backgroundColor: Color(0xFFB2BBAF), // Background color for avatar
                      backgroundImage: AssetImage('assets/profile_placeholder.png'), // Replace with user image
                    ),
                    Positioned(
                      bottom: 0,
                      right: -10,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xE9A908A1), // Color for edit button
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
                          icon: const Icon(Icons.edit, color: Colors.white),
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
              _buildUserInfoWithIcon(Icons.person, 'JohnDoe'),
              _buildDivider(),
              _buildUserInfoWithIcon(Icons.phone, '+123 456 7890'),
              _buildDivider(),
              _buildUserInfoWithIcon(Icons.email, 'johndoe@example.com'),
              _buildDivider(),
              _buildUserInfoWithIcon(Icons.cake, 'January 1, 1990'),
              _buildDivider(),
              _buildUserInfoWithIcon(Icons.location_on, 'New York, USA'),
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
                  _buildSocialMediaIcon(FontAwesomeIcons.facebook, 'Facebook', 'https://facebook.com/johndoe', const Color(0xFF1877F2)),
                  _buildSocialMediaIcon(FontAwesomeIcons.instagram, 'Instagram', 'https://instagram.com/johndoe', const Color(0xFFC13584)),
                  _buildSocialMediaIcon(FontAwesomeIcons.twitter, 'Twitter', 'https://twitter.com/johndoe', const Color(0xFF1DA1F2)),
                  _buildSocialMediaIcon(FontAwesomeIcons.linkedin, 'LinkedIn', 'https://linkedin.com/in/johndoe', const Color(0xFF0077B5)),
                ],
              ),
              _buildDivider(),

              // Address
              const SizedBox(height: 20.0),
              _buildUserInfoWithIcon(Icons.home, '123 Main Street, Apt 4B, New York, NY 10001'),
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
                color: Color(0xFF555555), // Medium-dark text color for values
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
      color: Color(0xFFB2BBAF), // Line color
      thickness: 1.0,
    );
  }

  Widget _buildSocialMediaIcon(IconData icon, String platform, String url, Color color) {
    return GestureDetector(
      onTap: () {
        // Handle social media link
        // e.g., launch(url);
      },
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: color, // Brand color for each social media platform
            radius: 25.0,
            child: Icon(
              icon,
              color: Colors.white,
              size: 20.0,
            ),
          ),
          const SizedBox(height: 5.0),
          Text(
            platform,
            style: const TextStyle(
              color: Color(0xFF555555),
              fontSize: 14.0,
            ),
          ),
        ],
      ),
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

void main() => runApp(const MaterialApp(home: ProfilePage()));