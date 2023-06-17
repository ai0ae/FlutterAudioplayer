import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_audioplayer/common/utils/translation.dart';
import 'package:flutter_application_audioplayer/features/profile/service/profile_service.dart';
import 'package:flutter_application_audioplayer/models/user.dart';
import 'package:flutter_application_audioplayer/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget { //Implement a profile page that displays user information and allows users to update their details.
  static const routeName = '/profile-page';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  UserRole? _selectedRole;

  @override
  void initState() {
    super.initState();
    // Initialize the form fields with current user information
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false); //Design the profile page to show relevant information depending on the user's role and additional details provided during registration.
    _nameController.text = userProvider.user.name;
    _emailController.text = userProvider.user.email;
    _selectedRole = userProvider.user.role;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(translation(context).profile),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              translation(context).profile,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 80,
                backgroundImage: _image != null
                    ? FileImage(_image!) as ImageProvider
                    : NetworkImage(userProvider.user.userImage),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text(translation(context).pickImage),
            ),
            SizedBox(height: 24),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: translation(context).name,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            ListTile(
              title: Text(_selectedRole == null
                  ? userProvider.user.role.toString().split('.')[1]
                  : _selectedRole.toString().split('.')[1]),
              trailing: Switch(
                value: _selectedRole != UserRole.user,
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value ? UserRole.creator : UserRole.user;
                  });
                },
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Update the user information with the new name, image, and role
                UserModel updatedUser = UserModel(
                  id: userProvider.user.id,
                  userImage: _image != null
                      ? _image!.path
                      : userProvider.user.userImage,
                  name: _nameController.text,
                  email: userProvider.user.email,
                  role: _selectedRole == null
                      ? userProvider.user.role
                      : _selectedRole!,
                );
                userProvider.setUserFromModel(updatedUser);
                ProfielService(FirebaseFirestore.instance)
                    .updateUserInfo(context, updatedUser);
              },
              child: Text(translation(context).updateProfile),
            ),
          ],
        ),
      ),
    );
  }
}
