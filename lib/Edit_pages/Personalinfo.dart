import 'package:flutter/material.dart';

class EditPersonalAndBasicInformationPage extends StatefulWidget {
  @override
  _EditPersonalAndBasicInformationPageState createState() => _EditPersonalAndBasicInformationPageState();
}

class _EditPersonalAndBasicInformationPageState extends State<EditPersonalAndBasicInformationPage> {
  final _formKey = GlobalKey<FormState>();
  String fullName = 'John Doe';
  String username = '@johndoe';
  String emailAddress = 'john.doe@example.com';
  String phoneNumber = '+1234567890';
  String bio = 'A brief bio about John Doe.';
  String location = 'New York, USA';
  String occupation = 'Event Organizer';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Personal & Basic Information'),
        backgroundColor: Colors.lightBlue[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: fullName,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
                onSaved: (value) {
                  fullName = value!;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                initialValue: username,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
                onSaved: (value) {
                  username = value!;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                initialValue: emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email address';
                  }
                  return null;
                },
                onSaved: (value) {
                  emailAddress = value!;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                initialValue: phoneNumber,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
                onSaved: (value) {
                  phoneNumber = value!;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                initialValue: bio,
                decoration: InputDecoration(
                  labelText: 'Bio',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a brief bio';
                  }
                  return null;
                },
                onSaved: (value) {
                  bio = value!;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                initialValue: location,
                decoration: InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your location';
                  }
                  return null;
                },
                onSaved: (value) {
                  location = value!;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                initialValue: occupation,
                decoration: InputDecoration(
                  labelText: 'Occupation/Role',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your occupation or role';
                  }
                  return null;
                },
                onSaved: (value) {
                  occupation = value!;
                },
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Information updated successfully')),
                    );
                    Navigator.pop(context);
                  }
                },
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
