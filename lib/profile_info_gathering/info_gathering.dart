import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventia/view/profile.dart';
class AdditionalInfoForm extends StatefulWidget {
  const AdditionalInfoForm({Key? key}) : super(key: key);

  @override
  _AdditionalInfoFormState createState() => _AdditionalInfoFormState();
}
class _AdditionalInfoFormState extends State<AdditionalInfoForm> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Controllers for form fields
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _aboutMeController = TextEditingController();
  final TextEditingController _professionController = TextEditingController();
  final TextEditingController _languageController = TextEditingController();

  // Social media links
  final TextEditingController _facebookController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _twitterController = TextEditingController();
  final TextEditingController _linkedinController = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    _birthdateController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _aboutMeController.dispose();
    _professionController.dispose();
    _languageController.dispose();
    _facebookController.dispose();
    _instagramController.dispose();
    _twitterController.dispose();
    _linkedinController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
    } else {
      _submitData();
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  void _skip() {
    if (_currentPage < 2) {
      _nextPage();
    } else {
      _submitData();
    }
  }

  Future<void> _submitData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      // Collect data
      Map<String, dynamic> userData = {
        'birthdate': _birthdateController.text,
        'city': _cityController.text,
        'state': _stateController.text,
        'aboutMe': _aboutMeController.text,
        'profession': _professionController.text,
        'language': _languageController.text,
        'socialMedia': {
          'facebook': _facebookController.text,
          'instagram': _instagramController.text,
          'twitter': _twitterController.text,
          'linkedin': _linkedinController.text,
        },
      };

      // Remove empty fields if skipped
      userData.removeWhere((key, value) => value == null || value == '');

      // Save to Firestore
      await FirebaseFirestore.instance
          .collection('User')
          .doc(currentUser.uid)
          .set(userData, SetOptions(merge: true));

      // Navigate to main screen or profile page
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complete Your Profile'),
        leading: _currentPage > 0
            ? IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: _prevPage,
        )
            : null,
        actions: [
          TextButton(
            onPressed: _skip,
            child: Text('Skip', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        physics: NeverScrollableScrollPhysics(), // Disable swipe to change page
        children: [
          _buildFirstPage(),
          _buildSecondPage(),
          _buildThirdPage(),
        ],
      ),
    );
  }

  Widget _buildFirstPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text('Tell us about yourself', style: TextStyle(fontSize: 24.0)),
          SizedBox(height: 20.0),
          TextField(
            controller: _birthdateController,
            decoration: InputDecoration(labelText: 'Birthdate'),
            keyboardType: TextInputType.datetime,
          ),
          TextField(
            controller: _cityController,
            decoration: InputDecoration(labelText: 'City'),
          ),
          TextField(
            controller: _stateController,
            decoration: InputDecoration(labelText: 'State'),
          ),
          TextField(
            controller: _aboutMeController,
            decoration: InputDecoration(labelText: 'About Me'),
            maxLines: 3,
          ),
          Spacer(),
          ElevatedButton(
            onPressed: _nextPage,
            child: Text('Next'),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text('Your Professional Details', style: TextStyle(fontSize: 24.0)),
          SizedBox(height: 20.0),
          TextField(
            controller: _professionController,
            decoration: InputDecoration(labelText: 'Profession'),
          ),
          TextField(
            controller: _languageController,
            decoration: InputDecoration(labelText: 'Language'),
          ),
          Spacer(),
          ElevatedButton(
            onPressed: _nextPage,
            child: Text('Next'),
          ),
        ],
      ),
    );
  }

  Widget _buildThirdPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text('Connect Your Social Media', style: TextStyle(fontSize: 24.0)),
          SizedBox(height: 20.0),
          TextField(
            controller: _facebookController,
            decoration: InputDecoration(labelText: 'Facebook URL'),
          ),
          TextField(
            controller: _instagramController,
            decoration: InputDecoration(labelText: 'Instagram URL'),
          ),
          TextField(
            controller: _twitterController,
            decoration: InputDecoration(labelText: 'Twitter URL'),
          ),
          TextField(
            controller: _linkedinController,
            decoration: InputDecoration(labelText: 'LinkedIn URL'),
          ),
          Spacer(),
          ElevatedButton(
            onPressed: _submitData,
            child: Text('Finish'),
          ),
        ],
      ),
    );
  }
}
