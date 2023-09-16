import 'dart:async';

import 'package:flutter/material.dart';
import 'package:adopt_v2/src/core/widgets/bottom_navbar.dart';
import 'package:adopt_v2/src/features/shoppage/models/Product.dart';
import 'package:adopt_v2/src/features/shoppage/models/Services.dart';
import 'package:adopt_v2/src/features/shoppage/widgets/product_card.dart';
import 'package:adopt_v2/src/features/shoppage/widgets/service_card.dart';

class ShopScreen extends StatefulWidget {
  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> with TickerProviderStateMixin {
  List<Product> shopProducts = [];
  List<Services> serviceProducts = [];
  int currentPage = 1;
  int pageSize = 10;
  int activeIndex = 0;
  PageController _pageController = PageController(initialPage: 0);
  TextEditingController _searchController = TextEditingController();
  bool isLoading = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        activeIndex = _tabController.index;
      });
    });
    _pageController = PageController(initialPage: activeIndex);

    // Start auto-sliding
    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (activeIndex < 2) {
        activeIndex++;
      } else {
        activeIndex = 0;
      }
      _pageController.animateToPage(
        activeIndex,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  // Define different gradient colors for each card.
  List<List<Color>> gradientColors = [
    [Colors.blue, Colors.teal], // Card 1 gradient colors
    [Colors.red, Colors.orange], // Card 2 gradient colors
    [Colors.green, Colors.blue], // Card 3 gradient colors
  ];

  void _triggerSearch() async {
    // Add a delay of 1 second before triggering the search
    await Future.delayed(Duration(seconds: 1));

    if (mounted) {
      // Check if the widget is still mounted before updating the state
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop for your pet 🐶'),
        backgroundColor: Color(0xff4FC9E0),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                prefixIcon: Icon(Icons.search),
                hintText: 'What are you looking for?',
              ),
              onChanged: (value) {
                setState(() {
                  isLoading = true; // Start loading
                  _searchController.text = value;
                  _triggerSearch(); // Trigger the search function with a delay
                });
              },
            ),
          ),
          // SizedBox(height: 0.0),
          Expanded(
            child: Container(
              child: PageView.builder(
                controller: _pageController,
                itemCount: 3,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: gradientColors[
                              index], // Use the correct gradient colors
                        ),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'New Arrival',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Product Name ${index + 1}',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '50% OFF',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.yellow,
                                  ),
                                ),
                                SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    // Add your action here
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    onPrimary: gradientColors[index][0],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 20,
                                    ),
                                    child: Text(
                                      'Shop Now',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                onPageChanged: (int index) {
                  setState(() {
                    activeIndex = index;
                  });
                },
              ),
            ),
          ),
          TabBar(
            indicator: BoxDecoration(
              color: Color(0xff4FC9E0), // Set the active tab's background color
              borderRadius: BorderRadius.circular(10.0),
            ),
            labelColor: Colors.white, // Set the active tab's text color
            unselectedLabelColor:
                Colors.grey, // Set the inactive tab's text color
            onTap: (index) {
              setState(() {
                activeIndex = index;
              });
            },
            controller: _tabController,
            tabs: [
              Tab(text: 'Store 🛍️'),
              Tab(text: 'Services 🩺⚕'),
            ],
          ),
          // SizedBox(height: 16.0),
          Flexible(
            child: TabBarView(
              controller: _tabController,
              children: [
                ProductCard(
                  searchQuery: _searchController.text,
                  isLoading: isLoading,
                  onSearchStart: () {
                    setState(() {
                      isLoading = true;
                      _triggerSearch();
                    });
                  },
                ),
                ServiceCard(
                  searchQuery: _searchController.text,
                  isLoading: isLoading,
                  onSearchStart: () {
                    setState(() {
                      isLoading = true;
                      _triggerSearch();
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
