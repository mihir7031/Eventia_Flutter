import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class AddField extends StatefulWidget {
  final bool isSave; // Add isSave parameter

  AddField({this.isSave = false}); // Default to false if not provided

  @override
  _AddFieldState createState() => _AddFieldState();
}

class _AddFieldState extends State<AddField> {
  List<FieldModel> fields = [];

  @override
  void initState() {
    super.initState();
    // Automatically save fields if isSave is true
    if (widget.isSave) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        saveFields().then((_) {
          // Optionally show a confirmation or navigate after saving
        });
      });
    }
  }

  void addTextField() {
    setState(() {
      fields.add(FieldModel(type: 'text', title: '', description: ''));
    });
  }

  void addPhotoField() {
    setState(() {
      fields.add(FieldModel(type: 'photo', title: '', imagePaths: []));
    });
  }

  void addFileField() {
    setState(() {
      fields.add(FieldModel(type: 'file', title: '', fileNames: []));
    });
  }

  void addSocialMediaField() {
    setState(() {
      fields.add(FieldModel(type: 'social_media', title: '', link: ''));
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

  Future<void> saveFields() async {
    final firestore = FirebaseFirestore.instance;
    final documentRef = firestore.collection('events').doc(); // Create a new document

    List<Map<String, dynamic>> fieldMaps = fields.map((field) => field.toMap()).toList();

    await documentRef.set({
      'fields': fieldMaps,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          for (int i = 0; i < fields.length; i++)
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: getFieldWidget(fields[i], () => removeField(i)),
                ),
                if (i < fields.length - 1) SizedBox(height: 15.0,) // Add a divider between fields
              ],
            ),
          SizedBox(height: 20),
          if (!widget.isSave) // Conditionally show Add More button
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: showFieldOptions,
                child: Text('Add More'),
              ),
            ),
        ],
      ),
    );
  }

  Widget getFieldWidget(FieldModel field, VoidCallback onDelete) {
    switch (field.type) {
      case 'text':
        return TextFieldWidget(
          title: field.title,
          description: field.description,
          onDelete: onDelete,
        );
      case 'photo':
        return PhotoFieldWidget(
          title: field.title,
          imagePaths: field.imagePaths,
          onDelete: onDelete,
        );
      case 'file':
        return FileFieldWidget(
          title: field.title,
          fileNames: field.fileNames,
          onDelete: onDelete,
        );
      case 'social_media':
        return SocialMediaFieldWidget(
          title: field.title,
          link: field.link,
          onDelete: onDelete,
        );
      default:
        return Container(); // Fallback in case of unknown type
    }
  }
}

// Field Model
class FieldModel {
  final String type;
  final String title;
  final String description;
  final List<String> imagePaths; // For photos
  final List<String> fileNames; // For files
  final String link; // For social media

  FieldModel({
    required this.type,
    required this.title,
    this.description = '',
    this.imagePaths = const [],
    this.fileNames = const [],
    this.link = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'title': title,
      'description': description,
      'imagePaths': imagePaths,
      'fileNames': fileNames,
      'link': link,
    };
  }
}

// Widget for Text Field
class TextFieldWidget extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onDelete;

  TextFieldWidget({
    required this.title,
    required this.description,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text: title);
    final descriptionController = TextEditingController(text: description);

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
            focusedBorder:
            UnderlineInputBorder(), // No border when focused
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
            focusedBorder:
            UnderlineInputBorder(), // No border when focused
            disabledBorder: InputBorder.none,
            filled: false, // No border by default
          ),
          keyboardType: TextInputType.multiline,  // Enables multiline input
          minLines: 1,  // Minimum number of lines the TextField will show
          maxLines: null,
        ),
      ],
    );
  }
}

// Widget for Photo Field
class PhotoFieldWidget extends StatefulWidget {
  final String title;
  final List<String> imagePaths;
  final VoidCallback onDelete;

  PhotoFieldWidget({
    required this.title,
    required this.imagePaths,
    required this.onDelete,
  });

  @override
  _PhotoFieldWidgetState createState() => _PhotoFieldWidgetState();
}

class _PhotoFieldWidgetState extends State<PhotoFieldWidget> {
  late List<XFile> _imageFiles;

  @override
  void initState() {
    super.initState();
    _imageFiles = widget.imagePaths.map((path) => XFile(path)).toList();
  }

  Future<void> pickImages() async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile>? selectedImages = await _picker.pickMultiImage();
    if (selectedImages != null) {
      setState(() {
        _imageFiles.addAll(selectedImages);
      });
    }
  }

  void removeImage(int index) {
    setState(() {
      _imageFiles.removeAt(index);
    });
  }

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
        SizedBox(height: 8), // Padding between elements
        TextField(

          decoration: InputDecoration(
            labelText: "Title",
            border: UnderlineInputBorder(), // No border by default
            enabledBorder:
            UnderlineInputBorder(), // No border when enabled but not focused
            focusedBorder:
            UnderlineInputBorder(), // No border when focused
            disabledBorder: InputBorder.none,
            filled: false, // No border by default
          ),
        ),
        SizedBox(height: 16), // Padding between title and image button
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
      ],
    );
  }
}

// Widget for File Field
class FileFieldWidget extends StatefulWidget {
  final String title;
  final List<String> fileNames;
  final VoidCallback onDelete;

  FileFieldWidget({
    required this.title,
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

          decoration: InputDecoration(
            labelText: "Title",
            border: UnderlineInputBorder(), // No border by default
            enabledBorder:
            UnderlineInputBorder(), // No border when enabled but not focused
            focusedBorder:
            UnderlineInputBorder(), // No border when focused
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
  final String title;
  final String link;
  final VoidCallback onDelete;

  SocialMediaFieldWidget({
    required this.title,
    required this.link,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text: title);
    final linkController = TextEditingController(text: link);

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
            focusedBorder:
            UnderlineInputBorder(), // No border when focused
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
            focusedBorder:
            UnderlineInputBorder(), // No border when focused
            disabledBorder: InputBorder.none,
            filled: false, // No border by default
          ),
        ),
      ],
    );
  }
}

