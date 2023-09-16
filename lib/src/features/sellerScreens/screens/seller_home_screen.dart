import 'package:adopt_v2/src/core/widgets/bottom_navbar.dart';
import 'package:adopt_v2/src/core/widgets/seller_bottombar.dart';
import 'package:adopt_v2/src/features/animalblog/screens/animal_blog_feed.dart';
import 'package:adopt_v2/src/features/homepage/widgets/animal_card.dart';
import 'package:adopt_v2/src/features/homepage/widgets/animal_category_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SellerHomeScreen extends StatefulWidget {
  @override
  _SellerHomeScreenState createState() => _SellerHomeScreenState();
}

class _SellerHomeScreenState extends State<SellerHomeScreen> {
  int _currentIndex = 0;
  String username = '';
  final storage = FlutterSecureStorage(); // Replace with the actual user name

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    username = await storage.read(key: 'sellername') ?? '';
    setState(() {
      username = username;
    });
  }

  void _navigateToFeed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AnimalBlogFeed()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Seller Home'),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Hello, $username!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Stack(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    color: Color(0xffFFB7D5), // Replace with suitable color
                    margin: EdgeInsets.all(16.0),
                    child: SizedBox(
                      height: 188, // Adjust the height as needed
                      child: Padding(
                        padding: EdgeInsets.all(14.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Save Animals Feed',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff941F1C),
                                    ),
                                  ),
                                  SizedBox(height: 16.0),
                                  Text(
                                    'Every street animal needs\nour protection. Please\nhelp them today',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 16.0),
                                  ElevatedButton(
                                    onPressed: () {
                                      _navigateToFeed();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14.0), // Set rounded corners
                                      ),
                                      primary: Color(0xff4FC9E0),
                                      onPrimary: Colors.white,
                                      padding: EdgeInsets.symmetric(vertical: 10.0),
                                    ),
                                    child: Text("  Go To the Feed -->  "),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: -9,
                    right: 19,
                    child: Image.asset(
                      'assets/images/home banner.png', // Replace with actual image path
                      width: 178,
                      // height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Categories',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    AnimalCategoryChip(
                      name: 'Cat',
                      emoji: '🐱',
                      backgroundColor: Color(0xffF7E3BC),
                      textColor: Color(0xff292828),
                    ),
                    AnimalCategoryChip(
                      name: 'Dog',
                      emoji: '🐶',
                      backgroundColor: Color(0xffDCECE3),
                      textColor: Color(0xff292828),
                    ),
                    AnimalCategoryChip(
                      name: 'Ham',
                      emoji: '🐹',
                      backgroundColor: Color(0xffC6E8F0),
                      textColor: Color(0xff292828),
                    ),
                    AnimalCategoryChip(
                      name: 'Bunny',
                      emoji: '🐰',
                      backgroundColor: Color(0xffF2DED4),
                      textColor: Color(0xff292828),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Animal Details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 16.0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    AnimalCard(
                      imagePath: 'assets/images/do1-removebg-preview.png',
                      // Replace with actual image path
                      name: 'Papet',
                      location: 'Distance 2.4 km 📍',
                    ),
                    AnimalCard(
                      imagePath: 'assets/images/dog2-removebg-preview.png',
                      // Replace with actual image path
                      name: 'Muzli',
                      location: 'Distance 3.4 km 📍',
                    ),
                    AnimalCard(
                      imagePath: 'assets/images/dog3-removebg-preview.png',
                      // Replace with actual image path
                      name: 'Furry',
                      location: 'Distance 4.4 km 📍',
                    ),
                    AnimalCard(
                      imagePath: 'assets/images/do1-removebg-preview.png',
                      // Replace with actual image path
                      name: 'Papet',
                      location: 'Distance 5.4 km 📍',
                    ),
                    AnimalCard(
                      imagePath: 'assets/images/dog2-removebg-preview.png',
                      // Replace with actual image path
                      name: 'Muzli',
                      location: 'Distance 6.4 km 📍',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SellerBottomBar(),
    );
  }
}
