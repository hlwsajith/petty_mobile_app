import 'package:adopt_v2/src/features/animalblog/repositories/animal_blog_repository.dart';
import 'package:adopt_v2/src/features/animalblog/screens/animal_blog_feed.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Add this import statement

class AnimalBlogAddScreen extends StatefulWidget {
  @override
  _AnimalBlogAddScreenState createState() => _AnimalBlogAddScreenState();
}

class _AnimalBlogAddScreenState extends State<AnimalBlogAddScreen> {
  TextEditingController _postTextController = TextEditingController();
  late String _selectedImagePath = ''; // Initialize with an empty string

  void _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImagePath = pickedImage.path;
      });
    }
  }

  void _addPostToFeed() async {
    final String postText = _postTextController.text;
    final String imageExtension = _selectedImagePath.isNotEmpty
        ? _selectedImagePath.split('.').last.toLowerCase()
        : '';
    final String user = 'Logged User'; // Replace with the logged-in user details
    final DateTime now = DateTime.now();

    final AnimalBlogRepository repository = AnimalBlogRepository();
    await repository.addPostToFeed(postText, imageExtension, user, now);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Post added successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AnimalBlogFeed()),
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }


  @override
  void dispose() {
    _postTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _postTextController,
              maxLines: 1,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'What\'s on your mind?',
              ),
            ),
            SizedBox(height: 16.0),
            GestureDetector(
              onTap: _pickImage,
              child: Card(
                color: Colors.grey[200],
                child: _selectedImagePath.isNotEmpty // Check if the path is not empty
                    ? Image.file(
                  File(_selectedImagePath),
                  fit: BoxFit.cover,
                  height: 300,
                )
                    : Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Icon(
                    Icons.add_a_photo,
                    size: 64.0,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addPostToFeed, // Call the function to add the post
              child: Text('Add Post to Feed'),
            ),
          ],
        ),
      ),
    );
  }
}
