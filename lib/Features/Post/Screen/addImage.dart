import 'dart:io';
import 'package:artplace/Core/Utils/Loader.dart';
import 'package:artplace/Features/Authentication/Controller/AuthController.dart';
import 'package:artplace/Features/Post/Controller/PostController.dart';
import 'package:artplace/Models/UserModels.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';

class AddPostPage extends ConsumerStatefulWidget {
  @override
   ConsumerState<ConsumerStatefulWidget> createState() => _AddPostPageState();
}

class _AddPostPageState extends ConsumerState<AddPostPage> {
  File? _pickedImage;
  TextEditingController titleController=TextEditingController();
  void _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      File? croppedFile = File(result.files.single.path!);
      if (croppedFile != null) {
        setState(() {
          _pickedImage = croppedFile;

        });
      }
    }
  }
  void sharePost() async{
    if(_pickedImage!=null)
    {
      final user=ref.watch(userProvider);
      ref.read(postControllerProvider.notifier).shareImagePost(
            context: context,
            title: titleController.text.trim(),
            caption: titleController.text.trim(),
            user: user,
            file: _pickedImage,
          );
          titleController.clear();
          _pickedImage=null;
    }
    
  }

  

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(postControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Post'),
        backgroundColor: Colors.pink,
      ),
      body: (isLoading)?Loader(): SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10.0),
                    image: _pickedImage != null
                        ? DecorationImage(
                            image: FileImage(_pickedImage!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _pickedImage == null
                      ? Center(
                          child: Icon(
                            Icons.camera_alt,
                            size: 50,
                            color: Colors.white,
                          ),
                        )
                      : null,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  
                  hintText: 'Write a caption...',
                  contentPadding: EdgeInsets.all(12.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  sharePost();
                  
                  // Handle post submission logic here
                  // For example, you can upload the image and caption to a server
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.pink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    'Post',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}