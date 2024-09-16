import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
// import 'package:eventia/Add_event/CreateEventPages/AddField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  // final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload image to Firebase Storage and get the download URL
  Future<String?> uploadImage(File imageFile) async {
    try {
      String fileName =
          'eventss_poster_${DateTime.now().millisecondsSinceEpoch}';
      Reference storageRef = _storage.ref().child('eventss_posters/$fileName');
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }
}

class InfoForm extends StatefulWidget {
  const InfoForm({super.key});

  @override
  State<InfoForm> createState() => _InfoFormState();
}

class _InfoFormState extends State<InfoForm> {
  final _formKey = GlobalKey<FormState>();
  List<FieldModel> fields = [];

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
  final ImagePicker _picker = ImagePicker();

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

  Future<void> saveEventData(
      Map<String, dynamic> eventData, BuildContext context) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final documentRef =
          firestore.collection('eventss').doc(); // Create a new document

      // Convert the fields list to a map
      List<Map<String, dynamic>> fieldMaps =
          fields.map((field) => field.toMap()).toList();

      // Add fields and eventData together, along with a timestamp
      eventData['fields'] = fieldMaps;
      eventData['createdAt'] = FieldValue.serverTimestamp();

      // Save the event data and fields to Firestore
      await documentRef.set(eventData);
      setState(() {
        fields.clear();
      });
      // Show a confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Event and fields saved successfully!'),
        ),
      );
    } catch (e) {
      // Handle any errors that occur during saving
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save event and fields: $e'),
        ),
      );
    }
  }

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
                  border:
                      UnderlineInputBorder(), // Keeps only the bottom border
                  enabledBorder: UnderlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(),
                  fillColor: Colors.transparent, // Removes any background color
                  filled: false,
                ),
                onChanged: (value) => passName = value,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Price',
                  border:
                      UnderlineInputBorder(), // Keeps only the bottom border
                  enabledBorder: UnderlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(),
                  fillColor: Colors.transparent, // Removes any background color
                  filled: false,
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => passPrice = double.tryParse(value) ?? 0.0,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  border:
                      UnderlineInputBorder(), // Keeps only the bottom border
                  enabledBorder: UnderlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(),
                  fillColor: Colors.transparent, // Removes any background color
                  filled: false,
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => passQuantity = int.tryParse(value) ?? 0,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'People Per Pass',
                  border:
                      UnderlineInputBorder(), // Keeps only the bottom border
                  enabledBorder: UnderlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(),
                  fillColor: Colors.transparent, // Removes any background color
                  filled: false,
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => peoplePerPass = int.tryParse(value) ?? 0,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
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
                  border:
                      UnderlineInputBorder(), // Keeps only the bottom border
                  enabledBorder: UnderlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(),
                  fillColor: Colors.transparent, // Removes any background color
                  filled: false,
                ),
                onChanged: (value) => passName = value,
              ),
              TextFormField(
                initialValue: passPrice.toString(),
                decoration: InputDecoration(
                  labelText: 'Price',
                  border:
                      UnderlineInputBorder(), // Keeps only the bottom border
                  enabledBorder: UnderlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(),
                  fillColor: Colors.transparent, // Removes any background color
                  filled: false,
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => passPrice = double.tryParse(value) ?? 0.0,
              ),
              TextFormField(
                initialValue: passQuantity.toString(),
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  border:
                      UnderlineInputBorder(), // Keeps only the bottom border
                  enabledBorder: UnderlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(),
                  fillColor: Colors.transparent, // Removes any background color
                  filled: false,
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => passQuantity = int.tryParse(value) ?? 0,
              ),
              TextFormField(
                initialValue: peoplePerPass.toString(),
                decoration: InputDecoration(
                  labelText: 'People Per Pass',
                  border:
                      UnderlineInputBorder(), // Keeps only the bottom border
                  enabledBorder: UnderlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(),
                  fillColor: Colors.transparent, // Removes any background color
                  filled: false,
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => peoplePerPass = int.tryParse(value) ?? 0,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
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

    // Check if an image was picked
    if (pickedFile != null) {
      // Update the state only if a new image was selected
      setState(() {
        eventPoster = File(pickedFile.path);
      });
    }
  }

  // ----------------------------------------------------
  Widget getFieldWidget(FieldModel field, VoidCallback onDelete) {
    switch (field.type) {
      case 'text':
        return TextFieldWidget(
          titleController: field.titleController,
          descriptionController: field.descriptionController ??
              TextEditingController(), // Provide fallback
          onDelete: onDelete,
        );
      case 'photo':
        return PhotoFieldWidget(
          titleController: field.titleController,
          imagePaths: field.imagePaths,
          onDelete: onDelete,
        );
      case 'file':
        return FileFieldWidget(
          titleController: field.titleController,
          fileNames: field.fileNames,
          onDelete: onDelete,
        );
      case 'social_media':
        return SocialMediaFieldWidget(
          titleController: field.titleController,
          linkController: field.linkController ??
              TextEditingController(), // Provide fallback
          onDelete: onDelete,
        );
      default:
        return Container(); // Fallback in case of unknown type
    }
  }

  void addTextField() {
    setState(() {
      fields.add(FieldModel(type: 'text')); // Only required parameters
    });
  }

  void addPhotoField() {
    setState(() {
      fields.add(FieldModel(type: 'photo'));
    });
  }

  void addFileField() {
    setState(() {
      fields.add(FieldModel(type: 'file'));
    });
  }

  void addSocialMediaField() {
    setState(() {
      fields.add(FieldModel(type: 'social_media'));
    });
  }

  void removeField(int index) {
    setState(() {
      fields.removeAt(index);
    });
  }

  void showFieldOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300, // Set a fixed height for better layout
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.text_fields),
                  title: Text('Text'),
                  onTap: () {
                    addTextField();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo),
                  title: Text('Photo'),
                  onTap: () {
                    addPhotoField();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.file_present),
                  title: Text('File'),
                  onTap: () {
                    addFileField();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.share),
                  title: Text('Social Media'),
                  onTap: () {
                    addSocialMediaField();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // -----------------------------------------------------
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
                      border:
                          UnderlineInputBorder(), // Keeps only the bottom border
                      enabledBorder: UnderlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(),
                      fillColor:
                          Colors.transparent, // Removes any background color
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
                        : 'Date: ${DateFormat('dd-MM-yyyy').format(selectedDate!)}'),
                    trailing: Icon(Icons.calendar_today),
                    onTap: () => _selectDate(context),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Duration(in Minute)',
                      border:
                          UnderlineInputBorder(), // Keeps only the bottom border
                      enabledBorder: UnderlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(),
                      fillColor:
                          Colors.transparent, // Removes any background color
                      filled: false,
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => duration = value,
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter duration' : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Capacity',
                      border:
                          UnderlineInputBorder(), // Keeps only the bottom border
                      enabledBorder: UnderlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(),
                      fillColor:
                          Colors.transparent, // Removes any background color
                      filled: false,
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => capacity = int.tryParse(value) ?? 0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Age Limit',
                      border:
                          UnderlineInputBorder(), // Keeps only the bottom border
                      enabledBorder: UnderlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(),
                      fillColor:
                          Colors.transparent, // Removes any background color
                      filled: false,
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => ageLimit = int.tryParse(value) ?? 0,
                  ),
                ),
                ListTile(
                  title: Text('Chat Environment'),
                  trailing: Switch(
                    value: chatEnvironment,
                    onChanged: (value) {
                      setState(() {
                        chatEnvironment = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: Text('Online/Offline'),
                  trailing: Switch(
                    value: isOnline,
                    onChanged: (value) {
                      setState(() {
                        isOnline = value;
                      });
                    },
                  ),
                ),
                if (isOnline == true)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Location',
                        border:
                            UnderlineInputBorder(), // Keeps only the bottom border
                        enabledBorder: UnderlineInputBorder(),
                        focusedBorder: UnderlineInputBorder(),
                        fillColor:
                            Colors.transparent, // Removes any background color
                        filled: false,
                      ),
                      onChanged: (value) => location = value,
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter location' : null,
                    ),
                  ),
                ListTile(
                  title: Text('Paid/Unpaid'),
                  trailing: Switch(
                    value: isPaid,
                    onChanged: (value) {
                      setState(() {
                        isPaid = value;
                      });
                    },
                  ),
                ),
                if (isPaid)
                  Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _addPass,
                          child: Text('Add Pass'),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      for (int i = 0; i < passes.length; i++)
                        ListTile(
                          title: Text('${passes[i]['name']}'),
                          subtitle: Text(
                              'Price: ${passes[i]['price']}, Quantity: ${passes[i]['quantity']}, People Per Pass: ${passes[i]['peoplePerPass']}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => _editPass(i),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => _removePass(i),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: GestureDetector(
                      onTap: _pickPoster, // This opens the gallery on tap
                      child: eventPoster != null
                          ? Image.file(
                              eventPoster!,
                              height:
                                  200.0, // Set the desired height for the image
                              fit: BoxFit
                                  .cover, // Optional: Adjust fit as needed
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_a_photo,
                                    size: 50), // Icon with specified size
                                SizedBox(
                                    height:
                                        8), // Adds spacing between icon and text
                                Text(
                                  "Upload Poster",
                                  style: TextStyle(
                                      fontSize: 16), // Style the text as needed
                                ),
                              ],
                            ),
                    )),
                Padding(
                  padding: EdgeInsets.all(16.0),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      for (int i = 0; i < fields.length; i++)
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 1.0),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: getFieldWidget(
                                  fields[i], () => removeField(i)),
                            ),
                            if (i < fields.length - 1)
                              SizedBox(
                                height: 15.0,
                              ) // Add a divider between fields
                          ],
                        ),
                      SizedBox(height: 20),
                      // Conditionally show Add More button
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: showFieldOptions,
                          child: Text('Add More'),
                        ),
                      ),
                      SizedBox(height: 20),
                      // Conditionally show Save button
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        String? imageUrl;
                        if (eventPoster != null) {
                          // Upload image to Firebase and get the URL
                          imageUrl =
                              await FirebaseService().uploadImage(eventPoster!);
                        }

                        saveEventData({
                          'eventName': eventName,
                          'selectedTime': selectedTime?.format(context),
                          'selectedDate': selectedDate,
                          'duration': duration,
                          'location': location,
                          'capacity': capacity,
                          'ageLimit': ageLimit,
                          'isOnline': isOnline,
                          'isPaid': isPaid,
                          'passes': passes,
                          'chatEnvironment': chatEnvironment,
                          'eventPoster':
                              imageUrl, // Store the uploaded image URL
                        }, context);

                        _formKey.currentState?.reset();
                        setState(() {
                          selectedTime = null;
                          selectedDate = null;
                          eventPoster = null;
                          passes = [];
                        });
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

// Widget for Text Field
class TextFieldWidget extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final VoidCallback onDelete;

  TextFieldWidget({
    required this.titleController,
    required this.descriptionController,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("Text Field"),
            Spacer(),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: onDelete,
            ),
          ],
        ),
        SizedBox(height: 8), // Padding between elements
        TextField(
          controller: titleController,
          decoration: InputDecoration(
            labelText: 'Title',
            border: UnderlineInputBorder(), // No border by default
            enabledBorder:
                UnderlineInputBorder(), // No border when enabled but not focused
            focusedBorder: UnderlineInputBorder(), // No border when focused
            disabledBorder: InputBorder.none,
            filled: false, // No border by default
          ),
        ),
        SizedBox(height: 16), // Padding between title and description
        TextField(
          controller: descriptionController,
          decoration: InputDecoration(
            labelText: 'Description',
            border: UnderlineInputBorder(), // No border by default
            enabledBorder:
                UnderlineInputBorder(), // No border when enabled but not focused
            focusedBorder: UnderlineInputBorder(), // No border when focused
            disabledBorder: InputBorder.none,
            filled: false, // No border by default
          ),
          keyboardType: TextInputType.multiline, // Enables multiline input
          minLines: 1, // Minimum number of lines the TextField will show
          maxLines: null,
        ),
      ],
    );
  }
}

//photo field
class PhotoFieldWidget extends StatefulWidget {
  final TextEditingController titleController;
  final List<String> imagePaths; // Image URLs will be saved here
  final VoidCallback onDelete;

  PhotoFieldWidget({
    required this.titleController,
    required this.imagePaths,
    required this.onDelete,
  });

  @override
  _PhotoFieldWidgetState createState() => _PhotoFieldWidgetState();
}

class _PhotoFieldWidgetState extends State<PhotoFieldWidget> {
  List<XFile> _imageFiles = []; // Selected images before upload

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  String uid = '';

  void inputData() {
    final User? user = auth.currentUser;
    if (user != null) {
      setState(() {
        uid = user.uid;
      });
    } else {
      print("No user is logged in.");
    }
  }

  Future<void> pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _imageFiles.addAll(pickedFiles);
      });
    }
  }

  void removeImage(int index) {
    setState(() {
      _imageFiles.removeAt(index);
    });
  }

  Future<String?> uploadImage(File imageFile) async {
    try {
      String fileName =
          'eventss_images_${DateTime.now().millisecondsSinceEpoch}';
      Reference storageRef =
          _storage.ref().child('eventss_images/$uid/$fileName');
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // Function to upload images and save the URLs in widget.imagePaths
  Future<void> uploadImagesAndSaveUrls() async {
    for (var imageFile in _imageFiles) {
      File file = File(imageFile.path);
      String? downloadUrl = await uploadImage(file);
      if (downloadUrl != null) {
        setState(() {
          widget.imagePaths.add(downloadUrl); // Add URL to widget.imagePaths
        });
      }
    }

    print("Images uploaded and URLs saved to imagePaths.");
  }

  // Function to save data to Firestore

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("Photo Field"),
            Spacer(),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: widget.onDelete,
            ),
          ],
        ),
        SizedBox(height: 8),
        TextField(
          controller: widget.titleController,
          decoration: InputDecoration(
            labelText: "Title",
            border: UnderlineInputBorder(),
            enabledBorder: UnderlineInputBorder(),
            focusedBorder: UnderlineInputBorder(),
            disabledBorder: InputBorder.none,
            filled: false,
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: pickImages,
          child: Text('Pick Images'),
        ),
        _imageFiles.isNotEmpty
            ? Wrap(
                children: _imageFiles.map((imageFile) {
                  int index = _imageFiles.indexOf(imageFile);
                  return Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.all(8.0),
                        width: 100,
                        height: 100,
                        child: Image.file(
                          File(imageFile.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => removeImage(index),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              )
            : Container(),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: uploadImagesAndSaveUrls,
          child: Text('Upload Images'),
        ),
      ],
    );
  }
}

// Widget for File Field
class FileFieldWidget extends StatefulWidget {
  final TextEditingController titleController;
  final List<String> fileNames;
  final VoidCallback onDelete;

  FileFieldWidget({
    required this.titleController,
    required this.fileNames,
    required this.onDelete,
  });

  @override
  _FileFieldWidgetState createState() => _FileFieldWidgetState();
}

class _FileFieldWidgetState extends State<FileFieldWidget> {
  late List<String> _fileNames;

  @override
  void initState() {
    super.initState();
    _fileNames = widget.fileNames;
  }

  Future<void> pickFiles() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      setState(() {
        _fileNames.addAll(result.files.map((file) => file.name).toList());
      });
    }
  }

  void removeFile(int index) {
    setState(() {
      _fileNames.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("File Field"),
            Spacer(),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: widget.onDelete,
            ),
          ],
        ),
        SizedBox(height: 8), // Padding between elements
        TextField(
          controller: widget.titleController,
          decoration: InputDecoration(
            labelText: "Title",
            border: UnderlineInputBorder(), // No border by default
            enabledBorder:
                UnderlineInputBorder(), // No border when enabled but not focused
            focusedBorder: UnderlineInputBorder(), // No border when focused
            disabledBorder: InputBorder.none,
            filled: false, // No border by default
          ),
        ),
        SizedBox(height: 16), // Padding between title and file button
        ElevatedButton(
          onPressed: pickFiles,
          child: Text('Pick Files'),
        ),
        _fileNames.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _fileNames.map((fileName) {
                  int index = _fileNames.indexOf(fileName);
                  return ListTile(
                    title: Text(fileName),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => removeFile(index),
                    ),
                  );
                }).toList(),
              )
            : Container(),
      ],
    );
  }
}

// Widget for Social Media Field
class SocialMediaFieldWidget extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController linkController;
  final VoidCallback onDelete;

  SocialMediaFieldWidget({
    required this.titleController,
    required this.linkController,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("Social Media Field"),
            Spacer(),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: onDelete,
            ),
          ],
        ),
        SizedBox(height: 8), // Padding between elements
        TextField(
          controller: titleController,
          decoration: InputDecoration(
            labelText: 'Title',
            border: UnderlineInputBorder(), // No border by default
            enabledBorder:
                UnderlineInputBorder(), // No border when enabled but not focused
            focusedBorder: UnderlineInputBorder(), // No border when focused
            disabledBorder: InputBorder.none,
            filled: false, // No border by default
          ),
        ),
        SizedBox(height: 16), // Padding between title and link
        TextField(
          controller: linkController,
          decoration: InputDecoration(
            labelText: 'Link',
            border: UnderlineInputBorder(), // No border by default
            enabledBorder:
                UnderlineInputBorder(), // No border when enabled but not focused
            focusedBorder: UnderlineInputBorder(), // No border when focused
            disabledBorder: InputBorder.none,
            filled: false, // No border by default
          ),
        ),
      ],
    );
  }
}

class FieldModel {
  final String type;
  final TextEditingController titleController;
  final TextEditingController?
      descriptionController; // Optional for text fields
  final List<String> imagePaths; // For photos
  final List<String> fileNames; // For files
  final TextEditingController?
      linkController; // Optional for social media links

  FieldModel({
    required this.type,
    TextEditingController? titleController,
    TextEditingController? descriptionController,
    List<String>? imagePaths,
    List<String>? fileNames,
    TextEditingController? linkController,
  })  : titleController = titleController ?? TextEditingController(),
        descriptionController =
            descriptionController ?? TextEditingController(),
        imagePaths = imagePaths ?? [],
        fileNames = fileNames ?? [],
        linkController = linkController ?? TextEditingController();

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'title': titleController.text,
      'description': descriptionController?.text ?? '',
      'imagePaths': imagePaths,
      'fileNames': fileNames,
      'link': linkController?.text ?? '',
    };
  }
}