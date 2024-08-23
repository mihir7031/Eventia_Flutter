import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class CreateEventForm extends StatefulWidget {
  const CreateEventForm({super.key});

  @override
  State<CreateEventForm> createState() => _CreateEventFormState();
}

class _CreateEventFormState extends State<CreateEventForm> {
  final _formKey = GlobalKey<FormState>();

  bool _isOnlineEvent = false;
  bool _isPaidEvent = false;

  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _aboutEventController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _artistNameController = TextEditingController();
  final TextEditingController _artistProfessionController = TextEditingController();
  final TextEditingController _organizerInfoController = TextEditingController();
  final TextEditingController _eventHighlightsController = TextEditingController();
  final TextEditingController _accessibilityInfoController = TextEditingController();

  List<Map<String, String>> _passes = [];

  File? _selectedImage;
  String? _imageUrl;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = '${picked.toLocal()}'.split(' ')[0];
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage != null) {
      try {
        final fileName = 'events/${DateTime.now().millisecondsSinceEpoch}.jpg';
        final storageRef = _storage.ref().child(fileName);

        final uploadTask = storageRef.putFile(_selectedImage!);
        final taskSnapshot = await uploadTask;

        _imageUrl = await taskSnapshot.ref.getDownloadURL();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image: $e')),
        );
      }
    }
  }

  void _addPass() {
    setState(() {
      _passes.add({'type': '', 'price': ''});
    });
  }

  Future<void> _addEventToDatabase() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Upload the image and get the URL
        await _uploadImage();

        // Save the event data to Firestore
        await _firestore.collection('events').add({
          'eventName': _eventNameController.text,
          'location': _locationController.text,
          'aboutEvent': _aboutEventController.text,
          'date': _dateController.text,
          'time': _timeController.text,
          'duration': _durationController.text,
          'capacity': _capacityController.text,
          'price': _isPaidEvent ? _priceController.text : 'Free',
          'artistName': _artistNameController.text,
          'artistProfession': _artistProfessionController.text,
          'organizerInfo': _organizerInfoController.text,
          'eventHighlights': _eventHighlightsController.text,
          'accessibilityInfo': _accessibilityInfoController.text,
          'imageUrl': _imageUrl ?? '',
          'isOnlineEvent': _isOnlineEvent,
          'passes': _passes,
        });

        // Clear the text fields
        _eventNameController.clear();
        _locationController.clear();
        _aboutEventController.clear();
        _dateController.clear();
        _timeController.clear();
        _durationController.clear();
        _capacityController.clear();
        _priceController.clear();
        _artistNameController.clear();
        _artistProfessionController.clear();
        _organizerInfoController.clear();
        _eventHighlightsController.clear();
        _accessibilityInfoController.clear();
        _passes.clear();
        _selectedImage = null;

        // Optionally reset the switches
        setState(() {
          _isOnlineEvent = false;
          _isPaidEvent = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event created successfully!')),
        );
        if (Navigator.canPop(context)) {
          Navigator.pop(context); // Only pop if possible
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create event: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: const [
            SizedBox(width: 10),
            Text('E', style: TextStyle(fontFamily: 'Blacksword', color: Colors.black)),
            Text('ventia', style: TextStyle(fontFamily: 'BeautyDemo', color: Colors.black)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Event Details'),
                _buildTextField(
                  controller: _eventNameController,
                  labelText: 'Event Name',
                  hintText: 'Enter the event name',
                ),
                SwitchListTile(
                  title: const Text('Is this an online event?'),
                  value: _isOnlineEvent,
                  onChanged: (bool value) {
                    setState(() {
                      _isOnlineEvent = value;
                      if (_isOnlineEvent) _locationController.clear();
                    });
                  },
                ),
                if (!_isOnlineEvent)
                  _buildTextField(
                    controller: _locationController,
                    labelText: 'Event Location',
                    hintText: 'Enter the event location',
                  ),
                _buildTextField(
                  controller: _aboutEventController,
                  labelText: 'About Event',
                  hintText: 'Enter details about the event',
                  maxLines: 4,
                ),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _dateController,
                        labelText: 'Date',
                        hintText: 'Select date',
                        readOnly: true,
                        onTap: () => _selectDate(context),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildTextField(
                        controller: _timeController,
                        labelText: 'Time',
                        hintText: 'Select time',
                        readOnly: true,
                        onTap: () => _selectTime(context),
                      ),
                    ),
                  ],
                ),
                _buildTextField(
                  controller: _durationController,
                  labelText: 'Event Duration',
                  hintText: 'Enter event duration',
                ),
                _buildTextField(
                  controller: _capacityController,
                  labelText: 'Capacity',
                  hintText: 'Enter event capacity',
                ),
                SwitchListTile(
                  title: const Text('Is this a paid event?'),
                  value: _isPaidEvent,
                  onChanged: (bool value) {
                    setState(() {
                      _isPaidEvent = value;
                    });
                  },
                ),
                if (_isPaidEvent)
                  _buildTextField(
                    controller: _priceController,
                    labelText: 'Price',
                    hintText: 'Enter event price',
                  ),
                const SizedBox(height: 10),
                _buildSectionTitle('Passes'),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _passes.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            labelText: 'Pass Type',
                            hintText: 'Enter pass type',
                            onChanged: (value) {
                              _passes[index]['type'] = value;
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildTextField(
                            labelText: 'Price',
                            hintText: 'Enter pass price',
                            onChanged: (value) {
                              _passes[index]['price'] = value;
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                    onPressed: _addPass,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                      textStyle: const TextStyle(fontSize: 16.0),
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Add Pass'),
                  ),
                ),
                _buildSectionTitle('Organizer Information'),
                _buildTextField(
                  controller: _artistNameController,
                  labelText: 'Artist Name',
                  hintText: 'Enter artist name',
                ),
                _buildTextField(
                  controller: _artistProfessionController,
                  labelText: 'Artist Profession',
                  hintText: 'Enter artist profession',
                ),
                _buildTextField(
                  controller: _organizerInfoController,
                  labelText: 'Organizer Information',
                  hintText: 'Enter organizer information',
                ),
                _buildSectionTitle('Event Highlights'),
                _buildTextField(
                  controller: _eventHighlightsController,
                  labelText: 'Event Highlights',
                  hintText: 'Enter event highlights',
                ),
                _buildTextField(
                  controller: _accessibilityInfoController,
                  labelText: 'Accessibility Information',
                  hintText: 'Enter accessibility information',
                ),
                const SizedBox(height: 10),
                _buildSectionTitle('Event Image'),
                if (_selectedImage != null)
                  Center(
                    child: Image.file(
                      _selectedImage!,
                      height: 200,
                      width: width * 0.8,
                      fit: BoxFit.cover,
                    ),
                  ),
                Center(
                  child: ElevatedButton(
                    onPressed: _pickImage,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                      textStyle: const TextStyle(fontSize: 16.0),
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text('Select Image from Gallery'),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _addEventToDatabase,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                      textStyle: const TextStyle(fontSize: 16.0),
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text('Create Event'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTextField({
    TextEditingController? controller, // Make controller optional
    required String labelText,
    required String hintText,
    bool readOnly = false,
    int maxLines = 1,
    void Function()? onTap,
    void Function(String)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        maxLines: maxLines,
        onTap: onTap,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $labelText';
          }
          return null;
        },
      ),
    );
  }
}
