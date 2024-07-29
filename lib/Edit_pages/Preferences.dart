import 'package:flutter/material.dart';

class EditPreferencesPage extends StatefulWidget {
  @override
  _EditPreferencesPageState createState() => _EditPreferencesPageState();
}

class _EditPreferencesPageState extends State<EditPreferencesPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _notificationSettingsController =
      TextEditingController();
  final TextEditingController _privacySettingsController =
      TextEditingController();
  final TextEditingController _languagePreferencesController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the text controllers with current user data
    _notificationSettingsController.text = "Email, SMS, App";
    _privacySettingsController.text = "Public";
    _languagePreferencesController.text = "English";
  }

  @override
  void dispose() {
    _notificationSettingsController.dispose();
    _privacySettingsController.dispose();
    _languagePreferencesController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      // Save changes
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Preferences'),
        backgroundColor: Colors.lightBlue[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _notificationSettingsController,
                decoration: InputDecoration(
                  labelText: 'Notification Settings',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your notification settings';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _privacySettingsController,
                decoration: InputDecoration(
                  labelText: 'Privacy Settings',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your privacy settings';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _languagePreferencesController,
                decoration: InputDecoration(
                  labelText: 'Language Preferences',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your language preferences';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _saveChanges,
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
