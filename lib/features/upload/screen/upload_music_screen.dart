import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_audioplayer/common/utils/show_sncakbar.dart';
import 'package:flutter_application_audioplayer/common/utils/translation.dart';
import 'package:flutter_application_audioplayer/features/home/service/home_service.dart';
import 'package:flutter_application_audioplayer/models/audio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class UploadMusicScreen extends StatefulWidget {
  static const routeName = '/upload';

  @override
  _UploadMusicScreenState createState() => _UploadMusicScreenState();
}

class _UploadMusicScreenState extends State<UploadMusicScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  File? _image;
  File? _audioFile;

  void _selectImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  void _selectAudioFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null) {
      setState(() {
        _audioFile = File(result.files.single.path!);
      });
    }
  }

  void _uploadMusic() async {
    if (_nameController.text.isEmpty ||
        _authorController.text.isEmpty ||
        _image == null ||
        _audioFile == null) {
      // Show error message or perform necessary validation
      return;
    }

    // Perform music upload logic here using the provided data
    final audio = Audio(
        id: const Uuid().v1(),
        name: _nameController.text,
        author: _authorController.text,
        authorId: FirebaseAuth.instance.currentUser!.uid,
        image:
            '', // Placeholder value, you can upload the image to Firebase Storage and set the URL here
        audioFile:
            '', // Placeholder value, you can upload the audio file to Firebase Storage and set the URL here
        views: 0,
        createdAt: DateTime.now());

    // Save the audio object to Firestore or perform any other necessary operations
    await FirebaseAudioService().uploadAudio(audio, _image!, _audioFile!);
    // Clear the form
    _nameController.clear();
    _authorController.clear();
    setState(() {
      _image = null;
      _audioFile = null;
    });

    // Show success message or navigate to a different screen
    showSnackBar(
        context: context, content: translation(context).uploadMusicSnackbar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translation(context).uploadAudio),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              translation(context).uploadAudio,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: translation(context).name,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _authorController,
              decoration: InputDecoration(
                labelText: translation(context).author,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            _image != null
                ? Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(_image!),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  )
                : ElevatedButton(
                    onPressed: _selectImage,
                    child: Text(translation(context).selectImage),
                  ),
            SizedBox(height: 16),
            _audioFile != null
                ? Text(translation(context).selectedAudioFile)
                : ElevatedButton(
                    onPressed: _selectAudioFile,
                    child: Text(translation(context).selectAudio),
                  ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _uploadMusic,
              child: Text(translation(context).uploadAudio),
            ),
          ],
        ),
      ),
    );
  }
}
