import 'package:flutter/material.dart';
import 'package:adopt_v2/src/features/animalblog/widgets/animal_blog_list.dart';
import 'package:adopt_v2/src/features/animalblog/widgets/animal_blog_add.dart';

class AnimalBlogFeed extends StatefulWidget {
  @override
  _AnimalBlogFeedState createState() => _AnimalBlogFeedState();
}



class _AnimalBlogFeedState extends State<AnimalBlogFeed> {
  void _navigateToCreate() {
    Navigator.push(
      context as BuildContext,
      MaterialPageRoute(builder: (context) => AnimalBlogAddScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animal Blog Feed'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.only(top: 18, bottom: 0),
            child: Center(
              child: Text(
                'Welcome!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                _navigateToCreate();
              },
              child: Text('Create Post --->'),
            ),
          ),
          Expanded(
            child: AnimalBlogList(), // Add widget from AnimalBlogList screen
          ),
        ],
      ),
    );
  }
}
