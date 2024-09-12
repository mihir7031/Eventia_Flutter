import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:eventia/Add_event/CreateEventPages/AddField.dart';



import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveEventData(Map<String, dynamic> eventData) async {
    try {
      await _db.collection('eventss').add(eventData);
    } catch (e) {
      print("Error saving event data: $e");
    }
  }
}


class BasicInfoScreen extends StatefulWidget {
  @override
  _BasicInfoScreenState createState() => _BasicInfoScreenState();
}

class _BasicInfoScreenState extends State<BasicInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  String eventName = '';
  TimeOfDay? selectedTime;
  DateTime? selectedDate;
  String duration = '';
  String location = '';
  int capacity = 0;
  int ageLimit = 0;
  bool chatEnvironment = false;
  bool isOnline = true;
  bool isPaid = false;
  List<Map<String, dynamic>> passes = [];
  File? eventPoster;

  bool isSave = false; // Variable to track if form is saved

  final ImagePicker _picker = ImagePicker();

  // Date Picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  // Time Picker
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  // Add a Pass
  void _addPass() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String passName = '';
        double passPrice = 0.0;
        int passQuantity = 0;
        int peoplePerPass = 0;

        return AlertDialog(
          title: Text('Add Pass'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Pass Name',
                  border: InputBorder.none,
                ),
                onChanged: (value) => passName = value,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Price',
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => passPrice = double.tryParse(value) ?? 0.0,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => passQuantity = int.tryParse(value) ?? 0,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'People Per Pass',
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => peoplePerPass = int.tryParse(value) ?? 0,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (passName.isNotEmpty &&
                    passQuantity > 0 &&
                    passPrice >= 0 &&
                    peoplePerPass > 0) {
                  setState(() {
                    passes.add({
                      'name': passName,
                      'price': passPrice,
                      'quantity': passQuantity,
                      'peoplePerPass': peoplePerPass,
                    });
                  });
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill all fields correctly')),
                  );
                }
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Edit a Pass
  void _editPass(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String passName = passes[index]['name'];
        double passPrice = passes[index]['price'];
        int passQuantity = passes[index]['quantity'];
        int peoplePerPass = passes[index]['peoplePerPass'];

        return AlertDialog(
          title: Text('Edit Pass'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: passName,
                decoration: InputDecoration(
                  labelText: 'Pass Name',
                  border: InputBorder.none,
                ),
                onChanged: (value) => passName = value,
              ),
              TextFormField(
                initialValue: passPrice.toString(),
                decoration: InputDecoration(
                  labelText: 'Price',
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => passPrice = double.tryParse(value) ?? 0.0,
              ),
              TextFormField(
                initialValue: passQuantity.toString(),
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => passQuantity = int.tryParse(value) ?? 0,
              ),
              TextFormField(
                initialValue: peoplePerPass.toString(),
                decoration: InputDecoration(
                  labelText: 'People Per Pass',
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => peoplePerPass = int.tryParse(value) ?? 0,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (passName.isNotEmpty &&
                    passQuantity > 0 &&
                    passPrice >= 0 &&
                    peoplePerPass > 0) {
                  setState(() {
                    passes[index] = {
                      'name': passName,
                      'price': passPrice,
                      'quantity': passQuantity,
                      'peoplePerPass': peoplePerPass,
                    };
                  });
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill all fields correctly')),
                  );
                }
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Remove a Pass
  void _removePass(int index) {
    setState(() {
      passes.removeAt(index);
    });
  }

  // Pick Event Poster
  Future<void> _pickPoster() async {
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        eventPoster = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Basic Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Event Name',
                      border: UnderlineInputBorder(),
                      filled: false,
                    ),
                    onChanged: (value) => eventName = value,
                    validator: (value) =>
                    value!.isEmpty ? 'Please enter event name' : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: ListTile(
                    title: Text(selectedTime == null
                        ? 'Select Time'
                        : 'Time: ${selectedTime!.format(context)}'),
                    trailing: Icon(Icons.access_time),
                    onTap: () => _selectTime(context),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: ListTile(
                    title: Text(selectedDate == null
                        ? 'Select Date'
                        : 'Date: ${DateFormat('yyyy-MM-dd').format(selectedDate!)}'),
                    trailing: Icon(Icons.calendar_today),
                    onTap: () => _selectDate(context),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Duration',
                      border: UnderlineInputBorder(),
                      filled: false,
                    ),
                    onChanged: (value) => duration = value,
                    validator: (value) =>
                    value!.isEmpty ? 'Please enter duration' : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Location',
                      border: UnderlineInputBorder(),
                      filled: false,
                    ),
                    onChanged: (value) => location = value,
                    validator: (value) =>
                    value!.isEmpty ? 'Please enter location' : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Capacity',
                      border: UnderlineInputBorder(),
                      filled: false,
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) =>
                    capacity = int.tryParse(value) ?? 0,
                    validator: (value) =>
                    value!.isEmpty ? 'Please enter capacity' : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Age Limit',
                      border: UnderlineInputBorder(),
                      filled: false,
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => ageLimit = int.tryParse(value) ?? 0,
                    validator: (value) =>
                    value!.isEmpty ? 'Please enter age limit' : null,
                  ),
                ),
                SwitchListTile(
                  title: Text('Chat Environment'),
                  value: chatEnvironment,
                  onChanged: (value) {
                    setState(() {
                      chatEnvironment = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: Text('Online'),
                  value: isOnline,
                  onChanged: (value) {
                    setState(() {
                      isOnline = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: Text('Paid'),
                  value: isPaid,
                  onChanged: (value) {
                    setState(() {
                      isPaid = value;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: ElevatedButton(
                    onPressed: _pickPoster,
                    child: Text('Pick Event Poster'),
                  ),
                ),
                if (eventPoster != null)
                  Image.file(eventPoster!),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: ElevatedButton(
                    onPressed: _addPass,
                    child: Text('Add Pass'),
                  ),
                ),
                ...passes.map((pass) => ListTile(
                  title: Text(pass['name']),
                  subtitle: Text('Price: ${pass['price']}, Quantity: ${pass['quantity']}, People Per Pass: ${pass['peoplePerPass']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _editPass(passes.indexOf(pass)),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _removePass(passes.indexOf(pass)),
                      ),
                    ],
                  ),
                )).toList(),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: AddField(isSave: isSave),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          isSave = true;
                        });

                        // Prepare event data
                        final eventData = {
                          'eventName': eventName,
                          'selectedTime': selectedTime?.format(context),
                          'selectedDate': selectedDate?.toIso8601String(),
                          'duration': duration,
                          'location': location,
                          'capacity': capacity,
                          'ageLimit': ageLimit,
                          'chatEnvironment': chatEnvironment,
                          'isOnline': isOnline,
                          'isPaid': isPaid,
                          'passes': passes,
                          'eventPoster': eventPoster?.path ?? '', // You might need to upload the image to Firebase Storage and get its URL
                        };

                        // Save event data to Firebase
                        FirebaseService().saveEventData(eventData);

                        // After saving data
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Event data saved successfully')),
                        );
                      }
                    },
                    child: Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
