import 'dart:convert';

import 'package:http/http.dart' as http;

class AnimalBlogRepository {

  Future<void> addPostToFeed(String postText, String imageExtension, String user, DateTime postingTime) async {
    final url = 'YOUR_API_ENDPOINT'; // Replace with your actual API endpoint
    // Prepare the request body with the necessary data
    final requestBody = {
      'postText': postText,
      'imageExtension': imageExtension,
      'user': user,
      'postingTime': postingTime.toIso8601String(),
    };

    try {
      final response = await http.post(Uri.parse(url), body: requestBody);
      if (response.statusCode == 200) {
        // Request successful, handle the response if needed
        print('Post added successfully');
      } else {
        // Request failed, handle the error
        print('Failed to add post');
      }
    } catch (e) {
      // Exception occurred, handle the error
      print('Error: $e');
    }
  }

  Future<void> addComment(String comment, String user) async {
    final url = 'YOUR_API_ENDPOINT'; // Replace with your actual API endpoint

    // Prepare the request body with the necessary data
    final requestBody = {
      'comment': comment,
      'user': user,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        // Comment added successfully
        print('Comment added successfully');
      } else {
        // Failed to add comment
        print('Failed to add comment');
      }
    } catch (e) {
      // Exception occurred, handle the error
      print('Error: $e');
    }
  }
}
