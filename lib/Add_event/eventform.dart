import 'dart:io'; // Necessary for working with File class
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class AddFieldScreen extends StatefulWidget {
  @override
  _AddFieldScreenState createState() => _AddFieldScreenState();
}

class _AddFieldScreenState extends State<AddFieldScreen> {
  List<Widget> fields = [];

  void addTextField() {
    setState(() {
      fields.add(TextFieldWidget(onDelete: () => removeField(fields.length - 1)));
    });
  }

  void addPhotoField() {
    setState(() {
      fields.add(PhotoFieldWidget(onDelete: () => removeField(fields.length - 1)));
    });
  }

  void addFileField() {
    setState(() {
      fields.add(FileFieldWidget(onDelete: () => removeField(fields.length - 1)));
    });
  }

  void addSocialMediaField() {
    setState(() {
      fields.add(SocialMediaFieldWidget(onDelete: () => removeField(fields.length - 1)));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dynamic Fields"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ...fields,
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: showFieldOptions,
              child: Text('Add Field'),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget for Text Field
class TextFieldWidget extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final VoidCallback onDelete;

  TextFieldWidget({required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
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
              border: InputBorder.none,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              filled: false,
            ),
          ),
          SizedBox(height: 16), // Padding between title and description
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(
              labelText: 'Description',
              border: InputBorder.none,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              filled: false,
            ),
            keyboardType: TextInputType.multiline,  // Enables multiline input
            minLines: 1,  // Minimum number of lines the TextField will show
            maxLines: null,
          ),
        ],
      ),
    );
  }
}

// Widget for Photo Field
class PhotoFieldWidget extends StatefulWidget {
  final VoidCallback onDelete;

  PhotoFieldWidget({required this.onDelete});

  @override
  _PhotoFieldWidgetState createState() => _PhotoFieldWidgetState();
}

class _PhotoFieldWidgetState extends State<PhotoFieldWidget> {
  final TextEditingController titleController = TextEditingController();
  List<XFile>? _imageFiles = [];

  Future<void> pickImages() async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile>? selectedImages = await _picker.pickMultiImage();
    if (selectedImages != null) {
      setState(() {
        _imageFiles!.addAll(selectedImages);
      });
    }
  }

  void removeImage(int index) {
    setState(() {
      _imageFiles!.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
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
            controller: titleController,
            decoration: InputDecoration(
              labelText: 'Title',
              border: InputBorder.none,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              filled: false,
            ),
          ),
          SizedBox(height: 16), // Padding between title and image button
          ElevatedButton(
            onPressed: pickImages,
            child: Text('Pick Images'),
          ),
          _imageFiles!.isNotEmpty
              ? Wrap(
            children: _imageFiles!.map((image) {
              int index = _imageFiles!.indexOf(image);
              return Stack(
                alignment: Alignment.topRight,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(image.path),
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: GestureDetector(
                      onTap: () => removeImage(index),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.cancel,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          )
              : Container(),
        ],
      ),
    );
  }
}

// Widget for File Field
class FileFieldWidget extends StatefulWidget {
  final VoidCallback onDelete;

  FileFieldWidget({required this.onDelete});

  @override
  _FileFieldWidgetState createState() => _FileFieldWidgetState();
}

class _FileFieldWidgetState extends State<FileFieldWidget> {
  final TextEditingController titleController = TextEditingController();
  List<PlatformFile>? _selectedFiles = [];

  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      setState(() {
        _selectedFiles!.addAll(result.files);
      });
    }
  }

  void removeFile(int index) {
    setState(() {
      _selectedFiles!.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
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
            controller: titleController,
            decoration: InputDecoration(
              labelText: 'Title',
              border: InputBorder.none,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              filled: false,
            ),
          ),
          SizedBox(height: 16), // Padding between title and file button
          ElevatedButton(
            onPressed: pickFiles,
            child: Text('Pick Files'),
          ),
          _selectedFiles!.isNotEmpty
              ? Column(
            children: _selectedFiles!.map((file) {
              int index = _selectedFiles!.indexOf(file);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          file.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => removeFile(index),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.cancel,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          )
              : Container(),
        ],
      ),
    );
  }
}

// Widget for Social Media Field
class SocialMediaFieldWidget extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  final VoidCallback onDelete;

  SocialMediaFieldWidget({required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
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
              border: InputBorder.none,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              filled: false,
            ),
          ),
          SizedBox(height: 16), // Padding between title and link field
          TextField(
            controller: linkController,
            decoration: InputDecoration(
              labelText: 'Social Media Link',
              border: InputBorder.none,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              filled: false,
            ),

          ),
        ],
      ),
    );
  }
}
