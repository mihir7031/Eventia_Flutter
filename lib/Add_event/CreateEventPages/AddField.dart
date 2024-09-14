import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

// FieldModel Class
class FieldModel {
  final String type;
  final TextEditingController titleController;
  final TextEditingController? descriptionController;
  final List<String> imagePaths; // For photos
  final List<String> fileNames; // For files
  final TextEditingController? linkController; // Optional for social media

  FieldModel({
    required this.type,
    TextEditingController? titleController,
    this.descriptionController,
    List<String>? imagePaths,
    List<String>? fileNames,
    this.linkController,
  })  : titleController = titleController ?? TextEditingController(),
        imagePaths = imagePaths ?? [],
        fileNames = fileNames ?? [];

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

// Main Application

// FormScreen Widget with Add Field Functionality
class FormScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final List<FieldModel> fields = [];

  void addField(String fieldType) {
    setState(() {
      fields.add(FieldModel(
        type: fieldType,
        titleController: TextEditingController(),
        descriptionController: fieldType == 'Text' ? TextEditingController() : null,
        linkController: fieldType == 'Social Media' ? TextEditingController() : null,
      ));
    });
  }

  void removeField(int index) {
    setState(() {
      fields.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dynamic Form Fields'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: fields.length,
              itemBuilder: (context, index) {
                final field = fields[index];
                switch (field.type) {
                  case 'Text':
                    return TextFieldWidget(
                      titleController: field.titleController,
                      descriptionController: field.descriptionController!,
                      onDelete: () => removeField(index),
                    );
                  case 'Photo':
                    return PhotoFieldWidget(
                      titleController: field.titleController,
                      imageFiles: [],
                      onDelete: () => removeField(index),
                    );
                  case 'File':
                    return FileFieldWidget(
                      titleController: field.titleController,
                      fileNames: [],
                      onDelete: () => removeField(index),
                    );
                  case 'Social Media':
                    return SocialMediaFieldWidget(
                      titleController: field.titleController,
                      linkController: field.linkController!,
                      onDelete: () => removeField(index),
                    );
                  default:
                    return Container();
                }
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => addField('Text'),
              child: Text('Add Text Field'),
            ),
            ElevatedButton(
              onPressed: () => addField('Photo'),
              child: Text('Add Photo Field'),
            ),
            ElevatedButton(
              onPressed: () => addField('File'),
              child: Text('Add File Field'),
            ),
            ElevatedButton(
              onPressed: () => addField('Social Media'),
              child: Text('Add Social Media Field'),
            ),
          ],
        ),
      ),
    );
  }
}

// TextField Widget
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
        SizedBox(height: 8),
        TextField(
          controller: titleController,
          decoration: InputDecoration(
            labelText: 'Title',
            border: UnderlineInputBorder(),
          ),
        ),
        SizedBox(height: 16),
        TextField(
          controller: descriptionController,
          decoration: InputDecoration(
            labelText: 'Description',
            border: UnderlineInputBorder(),
          ),
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: null,
        ),
      ],
    );
  }
}

// PhotoField Widget
class PhotoFieldWidget extends StatefulWidget {
  final TextEditingController titleController;
  final List<XFile> imageFiles;
  final VoidCallback onDelete;

  PhotoFieldWidget({
    required this.titleController,
    required this.imageFiles,
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
    _imageFiles = widget.imageFiles;
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
      ],
    );
  }
}

// FileField Widget
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
        SizedBox(height: 8),
        TextField(
          controller: widget.titleController,
          decoration: InputDecoration(
            labelText: "Title",
            border: UnderlineInputBorder(),
          ),
        ),
        SizedBox(height: 16),
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

// SocialMediaField Widget
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
        SizedBox(height: 8),
        TextField(
          controller: titleController,
          decoration: InputDecoration(
            labelText: 'Title',
            border: UnderlineInputBorder(),
          ),
        ),
        SizedBox(height: 16),
        TextField(
          controller: linkController,
          decoration: InputDecoration(
            labelText: 'Link',
            border: UnderlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
