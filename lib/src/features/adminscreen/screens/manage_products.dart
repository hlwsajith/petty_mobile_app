import 'package:adopt_v2/src/core/widgets/admin_bottombar.dart';
import 'package:adopt_v2/src/core/widgets/seller_bottombar.dart';
import 'package:adopt_v2/src/features/adminscreen/screens/admin_product_card.dart';
import 'package:adopt_v2/src/features/adminscreen/widgets/admin_add_product.dart';
import 'package:adopt_v2/src/features/sellerScreens/widgets/seller_product_card.dart';
import 'package:flutter/material.dart';
import 'package:adopt_v2/src/core/widgets/bottom_navbar.dart';
import 'package:adopt_v2/src/features/shoppage/models/Product.dart';
import 'package:adopt_v2/src/features/shoppage/models/Services.dart';
import 'package:adopt_v2/src/features/shoppage/widgets/product_card.dart';
import 'package:adopt_v2/src/features/shoppage/widgets/service_card.dart';

class ManageProduct extends StatefulWidget {
  @override
  _ManageProductState createState() => _ManageProductState();
}

class _ManageProductState extends State<ManageProduct> with TickerProviderStateMixin {
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
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
        title: Text('Manage Shop'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Visibility(
                    // Conditionally show the search field for admin
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
                              isLoading = true; // Start loading
                              _triggerSearch(); // Trigger the search function with a delay
                            });
                          },
                        ),
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
                ),
                SizedBox(width: 16.0),
                Visibility( // Conditionally show the button for non-admin users
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AdminAddProduct()),
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
                ),
              ],
            ),
          ),
          SizedBox(height: 16.0),
          AdminProductCard(
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
      bottomNavigationBar: AdminBottomBar(),
    );
  }
}
