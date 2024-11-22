import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eventia/main.dart';


class UserInfoForm extends StatefulWidget {
  @override
  _UserInfoFormState createState() => _UserInfoFormState();
}

class _UserInfoFormState extends State<UserInfoForm> {
  final _formKey = GlobalKey<FormState>();

// Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Form field controllers
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _aboutMeController = TextEditingController();
  final TextEditingController _professionController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();

  // Selected birthdate and language
  DateTime? _selectedDate;
  String? _selectedLanguage;

  // Available languages for dropdown
  final List<String> _languages = ['English', 'Spanish', 'French', 'German', 'Chinese'];

  // List of Indian states for suggestion
  final List<String> _indianStates = [
    'Andhra Pradesh', 'Arunachal Pradesh', 'Assam', 'Bihar', 'Chhattisgarh',
    'Goa', 'Gujarat', 'Haryana', 'Himachal Pradesh', 'Jharkhand', 'Karnataka',
    'Kerala', 'Madhya Pradesh', 'Maharashtra', 'Manipur', 'Meghalaya',
    'Mizoram', 'Nagaland', 'Odisha', 'Punjab', 'Rajasthan', 'Sikkim',
    'Tamil Nadu', 'Telangana', 'Tripura', 'Uttar Pradesh', 'Uttarakhand',
    'West Bengal'
  ];



  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  // Load user profile data from Firestore
  Future<void> _loadUserProfile() async {
    String uid = _auth.currentUser!.uid;
    DocumentSnapshot userProfile = await _firestore.collection('User_profile').doc(uid).get();

    if (userProfile.exists) {
      setState(() {
        _cityController.text = userProfile['city'] ?? '';
        _stateController.text = userProfile['state'] ?? '';
        _aboutMeController.text = userProfile['aboutMe'] ?? '';
        _professionController.text = userProfile['profession'] ?? '';
        _selectedLanguage = userProfile['language'];
        _selectedDate = userProfile['birthdate'] != null
            ? DateTime.parse(userProfile['birthdate'])
            : null;
      });
    }
  }

  @override
  void dispose() {
    // Dispose controllers to free up memory
    _cityController.dispose();
    _aboutMeController.dispose();
    _professionController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  // Function to pick a birthdate
  Future<void> _pickBirthdate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;

      });
    }
  }

  // Save user info to Firebase
  Future<void> _saveUserInfo() async {
    if (_formKey.currentState!.validate()) {
      bool confirmed = await _showConfirmationDialog();

      if (confirmed) {
        String uid = _auth.currentUser!.uid;

        await _firestore.collection('User_profile').doc(uid).set({
          'birthdate': _selectedDate != null ? _selectedDate.toString() : null,
          'city': _cityController.text,
          'state': _stateController.text,
          'aboutMe': _aboutMeController.text,
          'profession': _professionController.text,
          'language': _selectedLanguage,
          'uid': uid,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User Info Saved Successfully!')),
        );

        // Navigate back to the previous page
        Navigator.pop(context);
      }
    }
  }

  // Show confirmation dialog
  Future<bool> _showConfirmationDialog() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Changes'),
          content: Text('Are you sure you want to change the information?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile',style: TextStyle(color: primaryColor),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Birthdate Field with Calendar Picker
              ListTile(
                title: Text(_selectedDate == null
                    ? 'Select Birthdate'
                    : 'Birthdate: ${_selectedDate!.toLocal().toString().split(' ')[0]}' ,style: TextStyle(color:textColor),),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _pickBirthdate(context),
              ),
              SizedBox(height: 10),

              // City Field
              TextFormField(
                controller: _cityController,
                cursorColor: primaryColor,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(labelText: 'City',border:
                UnderlineInputBorder(), // Keeps only the bottom border
                  enabledBorder: UnderlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(),
                  fillColor: Colors.transparent, // Removes any background color
                  filled: false,),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your city';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),

              // State Field with Autocomplete Suggestions
              Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<String>.empty();
                  }
                  return _indianStates.where((String state) {
                    return state.toLowerCase().startsWith(textEditingValue.text.toLowerCase());
                  });
                },
                onSelected: (String selection) {
                  _stateController.text = selection;
                },
                fieldViewBuilder: (BuildContext context, TextEditingController fieldTextEditingController,
                    FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
                  return TextFormField(
                    controller: fieldTextEditingController,
                    focusNode: fieldFocusNode,
                    cursorColor: primaryColor,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(labelText: 'State',border:
                    UnderlineInputBorder(), // Keeps only the bottom border
                      enabledBorder: UnderlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(),
                      fillColor: Colors.transparent, // Removes any background color
                      filled: false,),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your state';
                      }
                      return null;
                    },
                  );
                },
              ),
              SizedBox(height: 10),

              // About Me Field
              TextFormField(
                controller: _aboutMeController,
                cursorColor: primaryColor,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(labelText: 'About Me',border:
                UnderlineInputBorder(), // Keeps only the bottom border
                  enabledBorder: UnderlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(),
                  fillColor: Colors.transparent, // Removes any background color
                  filled: false,),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter something about yourself';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),

              // Profession Field
              TextFormField(
                controller: _professionController,
                cursorColor: primaryColor,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(labelText: 'Profession',border:
                UnderlineInputBorder(), // Keeps only the bottom border
                  enabledBorder: UnderlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(),
                  fillColor: Colors.transparent, // Removes any background color
                  filled: false,),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your profession';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),

              // Language Dropdown
              DropdownButtonFormField<String>(
                value: _selectedLanguage,

                decoration: InputDecoration(labelText: 'Language',border:
                UnderlineInputBorder(), // Keeps only the bottom border
                  enabledBorder: UnderlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(),
                  fillColor: Colors.transparent, // Removes any background color
                  filled: false,),
                isExpanded: true,
                items: _languages.map((String language) {
                  return DropdownMenuItem<String>(
                    value: language,
                    child: Text(language),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedLanguage = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a language';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Save Button
              ElevatedButton(
                onPressed: _saveUserInfo,
                child: Text('Save'),
              ),
              SizedBox(height: 10),

              // Cancel Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
                style: ElevatedButton.styleFrom(backgroundColor:accentColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
