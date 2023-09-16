import 'package:adopt_v2/src/core/widgets/bottom_navbar.dart';
import 'package:adopt_v2/src/features/listingpage/screens/adoption_application_screen.dart';
import 'package:adopt_v2/src/features/listingpage/widgets/animal_details_page.dart';
import 'package:adopt_v2/src/features/profilepage/widgets/my_list_grid.dart';
import 'package:flutter/material.dart';
import 'package:adopt_v2/src/shared/widgets/animal_list_grid.dart';

class UserListingsScreen extends StatefulWidget {
  @override
  _UserListingsScreenState createState() => _UserListingsScreenState();
}

class _UserListingsScreenState extends State<UserListingsScreen> {
  int _currentIndex = 0;
  TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'specie';
  bool _isLoading = false;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 0) {
      // Navigate to the Home page
    } else if (index == 1) {
      // Navigate to the Search page
    } else if (index == 2) {
      // Navigate to the Profile page
    } else if (index == 3) {
      // Navigate to the Animal Details page
      // _navigateToAnimalDetails(123); // Replace 123 with the actual animal ID
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToAnimalDetails(String animalId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AnimalDetailsPage(animalId: animalId)),
    );
  }

  void _triggerSearch() async {
    // Add a delay of 1 second before triggering the search
    await Future.delayed(Duration(seconds: 1));

    if (mounted) {
      // Check if the widget is still mounted before updating the state
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Listings'),
        backgroundColor: Color(0xff4FC9E0),
      ),
      body: Column(
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/dog cover.jpg'), // Replace with your image path
                fit: BoxFit.cover, // You can adjust this to fit your needs
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: 'Search',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _isLoading = true; // Start loading
                            _triggerSearch(); // Trigger the search function with a delay
                          });
                        },
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _isLoading = true; // Start loading
                        _searchController.text = value;
                        _triggerSearch(); // Trigger the search function with a delay
                      });
                    },
                  ),
                ),
                SizedBox(width: 16.0),
                // DropdownButton<String>(
                //   value: _selectedFilter,
                //   hint: Text('Filter'),
                //   onChanged: (value) {
                //     setState(() {
                //       _isLoading = true; // Start loading
                //       _selectedFilter = value!;
                //       _triggerSearch();
                //       // Apply the selected filter and update the grid items
                //     });
                //   },
                //   items: [
                //     DropdownMenuItem<String>(
                //       value: 'name',
                //       child: Text('name'),
                //     ),
                //     DropdownMenuItem<String>(
                //       value: 'category',
                //       child: Text('category'),
                //     ),
                //     DropdownMenuItem<String>(
                //       value: 'location',
                //       child: Text('location'),
                //     ),
                //     DropdownMenuItem<String>(
                //       value: 'Filter 3',
                //       child: Text('Filter 3'),
                //     ),
                //   ],
                // ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdoptionApplicationScreen()),
                    );
                  },
                  icon: Icon(Icons.add), // Replace with your desired icon
                  label: Text('Add Pet'), // Replace with your desired text
                  style: ElevatedButton.styleFrom(
                    // You can customize the button's appearance here
                    primary: Color(0xff4FC9E0), // Change the button's background color
                    onPrimary: Colors.white, // Change the text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0), // Adjust the button's corner radius
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: MyListGrid(
              searchQuery: _searchController.text,
              isLoading: _isLoading,
              onSearchStart: () {
                setState(() {
                  _isLoading = true;
                  _triggerSearch();
                });
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
