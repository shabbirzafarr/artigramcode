import 'dart:io';
import 'dart:typed_data';

import 'package:artplace/Core/Utils/Loader.dart';
import 'package:artplace/Features/Authentication/Controller/AuthController.dart';
import 'package:artplace/Features/UserProfile.dart/Controller/UserProfileController.dart';
import 'package:artplace/Models/UserModels.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
class EditProfileScreen extends ConsumerStatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  File? _pickedImage;
  @override
  void initState() {
    super.initState();
    final user=ref.read(userProvider);
    _usernameController.text=user!.username;
    _nameController.text=user!.name;
  }
  @override
  Widget build(BuildContext context) {
    final userProvide=ref.watch(userProvider);
    final loading=ref.watch(userProfileControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              _saveChanges();
            },
          ),
        ],
      ),
      body: (loading)?Loader():
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (_pickedImage!=null)? CircleAvatar(
              radius: 80,
              // You can add user's profile image here
              backgroundImage: FileImage(_pickedImage!),
            )
            :CircleAvatar(
              radius: 80,
              // You can add user's profile image here
              backgroundImage: NetworkImage(userProvide!.profilePic),
            ),
            SizedBox(height: 16),
            InkWell(
              onTap: (){
                _pickImage();
              },
              child: Text(
                'Change Profile Photo',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Username',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                hintText: 'Enter your username',
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Name',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Enter your bio',
              ),
             
            ),
          ],
        ),
      ),
    );
  }

  void _saveChanges() {
    // Implement your logic to save changes to the server or local storage
    String newUsername = _usernameController.text;
    String newName = _nameController.text;
    ref.watch(userProfileControllerProvider.notifier).editProfile(profileFile: _pickedImage, context: context, username: newUsername, name: newName);

  }
 void _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null) {
      String? pth=result.paths.first;
      if(pth!=null){
        final croppedFile = await ImageCropper().cropImage(
        sourcePath: pth,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 25,
        aspectRatioPresets: [CropAspectRatioPreset.square]
        );
        String path=croppedFile!.path;

        if(croppedFile!=null){
          setState(() {
            _pickedImage= File(path);
          });
          
        }
        
      }
      }
      
      
    }
  }
