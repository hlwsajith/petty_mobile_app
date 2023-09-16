import 'package:adopt_v2/src/core/widgets/bottom_navbar.dart';
import 'package:adopt_v2/src/features/authentication/models/User.dart';
import 'package:adopt_v2/src/features/authentication/screens/welcome_screen.dart';
import 'package:adopt_v2/src/features/chatScreen/screens/chat_list_screen.dart';
import 'package:adopt_v2/src/features/profilepage/widgets/appointment_list.dart';
import 'package:adopt_v2/src/features/profilepage/widgets/listings_screen.dart';
import 'package:adopt_v2/src/features/reminders/screens/reminder_screen.dart';
import 'package:adopt_v2/src/features/reminders/widgets/add_reminder.dart';
import 'package:adopt_v2/src/features/reminders/widgets/reminder_list.dart';
import 'package:adopt_v2/src/shared/repositories/profile_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final storage = FlutterSecureStorage();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isEditing = false;
  bool _isLoading = false;
  String username = '';

  @override
  void initState() {
    super.initState();
    _initializeData();
    // Initialize the text controllers with user data
    _nameController.text = 'John Doe'; // Replace with your user data
    _passwordController.text = '********'; // Replace with your user data
  }

  @override
  void dispose() {
    // Dispose the text controllers when the widget is disposed
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Future<void> _initializeData() async {
    username = await storage.read(key: 'username') ?? '';
    setState(() {
      username = username;
    });
  }

  void _updateUserData() {
    // Create a new User instance with the updated data
    User updatedUser = User(
      username: _nameController.text,
      password: _passwordController.text,
    );

    // Call the updateUser function from the ProfileRepository
    ProfileRepository.updateUser(updatedUser).then((_) {
      // Handle the successful update
    }).catchError((error) {
      // Handle errors if any
    });

    // Once the update is complete, toggle the editing state
    _toggleEditing();
  }

  void _chats() {
    Navigator.push(
      context as BuildContext,
      MaterialPageRoute(builder: (context) => ChatListScreen(username: username)),
    );
  }

  void _handleLogout(){
    setState(() {
      _isLoading = true; // Show loading effect
    });

    // Simulate a logout process here (you can replace this with your actual logout logic)
    Future.delayed(Duration(seconds: 2), () async {
      // After logout is complete, reset loading state
      setState(() {
        _isLoading = false;
      });

      // Add your navigation logic after successful logout
      // For example, you can navigate to the login screen
      // Navigator.pushReplacementNamed(context, '/login');
      await storage.deleteAll();
      Navigator.push(
        context as BuildContext,
        MaterialPageRoute(builder: (context) => WelcomeScreen()),
      );
    });
  }

  void appointmentListingScreen(){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AppointmentList(username: username), // Pass the selected user's data as a parameter
      ),
    );
}
  void listingScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UserListingsScreen(), // Pass the selected user's data as a parameter
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff4FC9E0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // CircleAvatar(
            //   radius: 25.0,
            //   backgroundColor: Colors.grey[300],
            //   backgroundImage: AssetImage(
            //       'assets/user_image.jpg'), // Replace with user image
            //   child: _isEditing
            //       ? IconButton(
            //           icon: Icon(Icons.edit),
            //           onPressed: () {
            //             // Implement image editing logic here
            //           },
            //         )
            //       : null,
            // ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _nameController,
              enabled: _isEditing,
              decoration: InputDecoration(
                labelText: 'Name',
                filled: true,
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              enabled: _isEditing,
              decoration: InputDecoration(
                labelText: 'Password',
                filled: true,
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (_isEditing) {
                  _updateUserData();
                }
                _toggleEditing();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _isEditing ? Icons.save : Icons.edit, // Icon based on the editing state
                    color: Colors.white// Icon size
                  ),
                  SizedBox(width: 8.0), // Space between the icon and text
                  Text(
                    _isEditing ? 'Save' : 'Edit',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _chats();
              },
              child: Text('Chats'),
            ),
            SizedBox(height: 0.0),
            ElevatedButton(
              onPressed: () {
                listingScreen();
              },
              child: Text('My Listings'),
            ),
            ElevatedButton(
              onPressed: () {
                appointmentListingScreen();
              },
              child: Text('My Appointments'),
            ),
            SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: _isLoading ? null : _handleLogout,
              style: ElevatedButton.styleFrom(
                primary: Colors.red, // Set button color to red
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (!_isLoading) // Show icon and text when not loading
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.logout), // Replace with your desired icon
                        SizedBox(width: 8),
                        Text('Logout'),
                      ],
                    ),
                  if (_isLoading) // Show loading effect when loading
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(), // Loading indicator
                        SizedBox(height: 8),
                        Text('Signing Out'), // Loading message
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
