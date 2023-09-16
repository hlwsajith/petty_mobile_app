import 'package:flutter/material.dart';
import 'package:adopt_v2/src/core/widgets/message_dialog.dart';
import 'package:adopt_v2/src/features/animalblog/repositories/animal_blog_repository.dart';

class AnimalBlogList extends StatefulWidget {
  @override
  _AnimalBlogListState createState() => _AnimalBlogListState();
}

class _AnimalBlogListState extends State<AnimalBlogList> {
  TextEditingController _commentTextController = TextEditingController();

  List<Post> _posts = [
    Post(
      author: 'John Doe',
      time: '2 hours ago',
      postText: 'This is a sample post',
      imagePath: 'https://example.com/image.jpg',
      likes: 15,
      comments: [
        Comment(author: 'Jane Smith', commentText: 'Nice post!'),
        Comment(author: 'David Johnson', commentText: 'I agree!'),
      ],
      isExpanded: false, // Track the expanded state for each post
    ),
    // Add more posts here
  ];

  void _likePost(int index) {
    setState(() {
      _posts[index].liked = !_posts[index].liked;
      if (_posts[index].liked) {
        _posts[index].likes++;
      } else {
        _posts[index].likes--;
      }
    });
  }

  void _viewComments(int index) {
    setState(() {
      _posts[index].isExpanded = !_posts[index].isExpanded; // Toggle the expanded state
    });
  }

  Future<void> _addComment() async {
    final String comment = _commentTextController.text;
    final String user = 'Logged User'; // Replace with the actual logged-in user name

    final AnimalBlogRepository repository = AnimalBlogRepository();
    try {
      await repository.addComment(comment, user);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return MessageDialog(
            title: 'Success',
            content: 'Comment added successfully.',
            icon: Icons.check_circle,
            iconColor: Colors.green,
            buttonColor: Colors.green,
            buttonText: 'OK',
            onButtonPressed: () {
              // Handle the custom button action
              // e.g., perform a specific action or navigate to another screen
              Navigator.of(context).pop(); // Close the dialog
            },
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return MessageDialog(
            title: 'Error',
            content: 'Failed to add comment',
            icon: Icons.error,
            iconColor: Colors.red,
            buttonColor: Colors.red,
            buttonText: 'OK',
            onButtonPressed: () {
              // Handle the custom button action
              // e.g., perform a specific action or navigate to another screen
              Navigator.of(context).pop(); // Close the dialog
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _posts.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(_posts[index].imagePath),
                  ),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _posts[index].author,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _posts[index].time,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(_posts[index].postText),
              SizedBox(height: 8),
              Container(
                height: 200,
                color: Colors.grey[200],
                child: _posts[index].imagePath.isEmpty
                    ? SizedBox()
                    : Image.network(
                  _posts[index].imagePath,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 8),
              Divider(
                color: Colors.grey,
                thickness: 1,
                indent: 21,
                endIndent: 21,
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _likePost(index),
                    child: Icon(
                      _posts[index].liked
                          ? Icons.thumb_up
                          : Icons.thumb_up_alt_outlined,
                      color: _posts[index].liked ? Colors.blue : null,
                    ),
                  ),
                  SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _viewComments(index),
                    child: Text(
                      'View Comments',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
              if (_posts[index].isExpanded)
                Container(
                  height: 200, // Set the desired height for the dropdown
                  child: ListView.builder(
                    itemCount: _posts[index].comments.length,
                    itemBuilder: (context, commentIndex) {
                      final comment = _posts[index].comments[commentIndex];
                      return ListTile(
                        leading: CircleAvatar(
                          // Replace with the image of the commenter
                          child: Icon(Icons.person),
                        ),
                        title: Text(comment.author),
                        subtitle: Text(comment.commentText),
                      );
                    },
                  ),
                ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _commentTextController,
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      _addComment();
                    },
                    child: Text('Comment'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class Post {
  final String author;
  final String time;
  final String postText;
  final String imagePath;
  int likes;
  bool liked;
  final List<Comment> comments;
  bool isExpanded; // Initialize the isExpanded property

  Post({
    required this.author,
    required this.time,
    required this.postText,
    required this.imagePath,
    this.likes = 0,
    this.liked = false,
    this.comments = const [],
    this.isExpanded = false, // Initialize the isExpanded property
  });
}


class Comment {
  final String author;
  final String commentText;

  Comment({
    required this.author,
    required this.commentText,
  });
}
