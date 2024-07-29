import 'package:flutter/material.dart';
import 'package:eventia/Edit_pages/EditBasicInformationPage.dart';
import 'package:eventia/Edit_pages/Personalinfo.dart';
import 'package:eventia/Edit_pages/Preferences.dart';
import 'package:eventia/Edit_pages/security.dart';

class profile extends StatelessWidget {
  const profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Profile Page', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.lightBlue[300],
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          // Profile Picture
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            ),
          ),
          SizedBox(height: 16.0),

          // Combined Information (Basic + Personal)
          ProfileSectionWithEditButton(
            title: 'Personal & Basic Information',
            children: [
              ProfileListTile(
                title: 'Full Name',
                subtitle: 'John Doe',
                icon: Icons.person,
              ),
              ProfileListTile(
                title: 'Username',
                subtitle: '@johndoe',
                icon: Icons.alternate_email,
              ),
              ProfileListTile(
                title: 'Email Address',
                subtitle: 'john.doe@example.com',
                icon: Icons.email,
              ),
              ProfileListTile(
                title: 'Phone Number',
                subtitle: '+1234567890',
                icon: Icons.phone,
              ),
              ProfileListTile(
                title: 'Bio',
                subtitle: 'A brief bio about John Doe.',
                icon: Icons.info,
              ),
              ProfileListTile(
                title: 'Location',
                subtitle: 'New York, USA',
                icon: Icons.location_on,
              ),
              ProfileListTile(
                title: 'Occupation/Role',
                subtitle: 'Event Organizer',
                icon: Icons.work,
              ),
            ],
          ),
          Divider(),

          // Event Information
          ProfileSection(
            title: 'Event Information',
            children: [
              ProfileListTile(
                title: 'Upcoming Events',
                subtitle: '3 events',
                icon: Icons.event,
              ),
              ProfileListTile(
                title: 'Past Events',
                subtitle: '10 events',
                icon: Icons.history,
              ),
              ProfileListTile(
                title: 'Created Events',
                subtitle: '5 events',
                icon: Icons.create,
              ),
              ProfileListTile(
                title: 'Favorites',
                subtitle: '2 events',
                icon: Icons.favorite,
              ),
            ],
          ),
          Divider(),

          // Preferences
          ProfileSectionWithEditButton(
            title: 'Preferences',
            children: [
              ProfileListTile(
                title: 'Notification Settings',
                subtitle: 'Email, SMS, App',
                icon: Icons.notifications,
              ),
              ProfileListTile(
                title: 'Privacy Settings',
                subtitle: 'Public',
                icon: Icons.lock,
              ),
              ProfileListTile(
                title: 'Language Preferences',
                subtitle: 'English',
                icon: Icons.language,
              ),
            ],
          ),
          Divider(),

          // Security
          ProfileSectionWithEditButton(
            title: 'Security',
            children: [
              ProfileListTile(
                title: 'Change Password',
                subtitle: '',
                icon: Icons.lock,
              ),
            ],
          ),
          Divider(),

          // Additional Features
          ProfileSectionTitle('Additional Features'),
          ProfileListTile(
            title: 'Badges/Achievements',
            subtitle: '5 badges',
            icon: Icons.emoji_events,
          ),
          ProfileListTile(
            title: 'Certificates',
            subtitle: '3 certificates',
            icon: Icons.school,
          ),
        ],
      ),
    );
  }
}

class ProfileSectionWithEditButton extends StatelessWidget {
  final String title;
  final List<Widget> children;

  ProfileSectionWithEditButton({required this.title, required this.children});

  void _navigateToEditPage(BuildContext context) {
    Widget editPage;

    switch (title) {
      case 'Personal & Basic Information':
        editPage = EditPersonalAndBasicInformationPage();
        break;
      case 'Preferences':
        editPage = EditPreferencesPage();
        break;
      case 'Security':
        editPage = EditSecurityPage();
        break;
      default:
        editPage = Scaffold(
          appBar: AppBar(
            title: Text('Edit Page'),
          ),
          body: Center(
            child: Text('Edit form for $title'),
          ),
        );
        break;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => editPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightBlue[700],
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit, color: Colors.lightBlue[700]),
                onPressed: () => _navigateToEditPage(context),
              ),
            ],
          ),
        ),
        ...children,
      ],
    );
  }
}

class ProfileSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  ProfileSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.lightBlue[700],
            ),
          ),
        ),
        ...children,
      ],
    );
  }
}

class ProfileSectionTitle extends StatelessWidget {
  final String title;

  ProfileSectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.lightBlue[700],
        ),
      ),
    );
  }
}

class ProfileListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  ProfileListTile(
      {required this.title, required this.subtitle, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.lightBlue[400]),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}
