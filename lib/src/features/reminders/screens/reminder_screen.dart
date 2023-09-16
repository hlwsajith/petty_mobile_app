import 'package:adopt_v2/src/features/reminders/widgets/add_reminder.dart';
import 'package:flutter/material.dart';
import 'package:adopt_v2/src/features/animalblog/widgets/animal_blog_list.dart';
import 'package:adopt_v2/src/features/animalblog/widgets/animal_blog_add.dart';

class ReminderScreen extends StatefulWidget {
  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}



class _ReminderScreenState extends State<ReminderScreen> {
  void _navigateToCreate() {
    Navigator.push(
      context as BuildContext,
      MaterialPageRoute(builder: (context) => AddReminderScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pet Reminders'),
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
              child: Text('Create Reminder --->'),
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
