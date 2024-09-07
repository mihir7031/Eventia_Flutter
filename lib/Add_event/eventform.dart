import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';

class EventForm extends StatefulWidget {
  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>();
  String eventName = '';
  DateTime? eventDate;
  TimeOfDay? eventTime;
  int? eventDuration;
  int? eventCapacity;
  String? eventMode;
  bool isPaid = false;
  String? paymentType;
  String? eventDescription;
  String? eventLocation;
  File? eventPoster;
  bool hasAgeLimit = false;
  int? ageLimit;
  List<Map<String, dynamic>> passes = [];

  final picker = ImagePicker();

  Future<void> _selectEventPoster() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        eventPoster = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Event'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Event Name
              TextFormField(
                decoration: InputDecoration(labelText: 'Event Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter event name';
                  }
                  return null;
                },
                onSaved: (value) => eventName = value!,
              ),
              // Event Date
              ListTile(
                title: Text(eventDate == null
                    ? 'Select Event Date'
                    : eventDate!.toLocal().toString().split(' ')[0]),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != eventDate)
                    setState(() {
                      eventDate = picked;
                    });
                },
              ),
              // Event Time
              ListTile(
                title: Text(eventTime == null
                    ? 'Select Event Time'
                    : eventTime!.format(context)),
                trailing: Icon(Icons.access_time),
                onTap: () async {
                  TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null && picked != eventTime)
                    setState(() {
                      eventTime = picked;
                    });
                },
              ),
              // Duration
              TextFormField(
                decoration: InputDecoration(labelText: 'Duration (minutes)'),
                keyboardType: TextInputType.number,
                onSaved: (value) => eventDuration = int.parse(value!),
              ),
              // Capacity
              TextFormField(
                decoration: InputDecoration(labelText: 'Capacity'),
                keyboardType: TextInputType.number,
                onSaved: (value) => eventCapacity = int.parse(value!),
              ),
              // Mode
              DropdownButtonFormField<String>(
                value: eventMode,
                decoration: InputDecoration(labelText: 'Mode'),
                items: ['Online', 'Offline']
                    .map((label) => DropdownMenuItem(
                  child: Text(label),
                  value: label,
                ))
                    .toList(),
                onChanged: (value) => setState(() => eventMode = value),
              ),
              // Payment
              SwitchListTile(
                title: Text('Paid Event'),
                value: isPaid,
                onChanged: (bool value) {
                  setState(() {
                    isPaid = value;
                    paymentType = null;
                  });
                },
              ),
              if (isPaid)
                DropdownButtonFormField<String>(
                  value: paymentType,
                  decoration: InputDecoration(labelText: 'Payment Type'),
                  items: ['Fixed Rate', 'Passes']
                      .map((label) => DropdownMenuItem(
                    child: Text(label),
                    value: label,
                  ))
                      .toList(),
                  onChanged: (value) => setState(() => paymentType = value),
                ),
              if (isPaid && paymentType == 'Passes')
                Column(
                  children: passes.map((pass) {
                    return TextFormField(
                      decoration: InputDecoration(labelText: 'Pass: ${pass['name']}'),
                      keyboardType: TextInputType.number,
                      initialValue: pass['price'].toString(),
                      onSaved: (value) => pass['price'] = int.parse(value!),
                    );
                  }).toList(),
                ),
              // Description
              TextFormField(
                decoration: InputDecoration(labelText: 'Brief Description'),
                onSaved: (value) => eventDescription = value,
              ),
              // Location
              TextFormField(
                decoration: InputDecoration(labelText: 'Location'),
                onSaved: (value) => eventLocation = value,
              ),
              // Event Poster
              ListTile(
                title: Text('Select Event Poster'),
                trailing: Icon(Icons.image),
                onTap: _selectEventPoster,
              ),
              if (eventPoster != null)
                Image.file(eventPoster!, height: 100, width: 100),
              // Age Limit
              SwitchListTile(
                title: Text('Age Limit'),
                value: hasAgeLimit,
                onChanged: (bool value) {
                  setState(() {
                    hasAgeLimit = value;
                  });
                },
              ),
              if (hasAgeLimit)
                TextFormField(
                  decoration: InputDecoration(labelText: 'Age Limit'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => ageLimit = int.parse(value!),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveEvent,
                child: Text('Create Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveEvent() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      String? posterUrl;
      if (eventPoster != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('event_posters/${DateTime.now().millisecondsSinceEpoch}');
        await storageRef.putFile(eventPoster!);
        posterUrl = await storageRef.getDownloadURL();
      }

      FirebaseFirestore.instance.collection('events').add({
        'name': eventName,
        'date': eventDate,
        'time': eventTime?.format(context),
        'duration': eventDuration,
        'capacity': eventCapacity,
        'mode': eventMode,
        'isPaid': isPaid,
        'paymentType': paymentType,
        'passes': passes,
        'description': eventDescription,
        'location': eventLocation,
        'posterUrl': posterUrl,
        'ageLimit': hasAgeLimit ? ageLimit : null,
        'createdAt': Timestamp.now(),
      });

      // Show confirmation or navigate back
    }
  }
}
