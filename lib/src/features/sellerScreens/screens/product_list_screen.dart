import 'package:adopt_v2/src/core/widgets/seller_bottombar.dart';
import 'package:adopt_v2/src/features/adminscreen/widgets/admin_add_product.dart';
import 'package:adopt_v2/src/features/sellerScreens/widgets/seller_product_card.dart';
import 'package:flutter/material.dart';
import 'package:adopt_v2/src/core/widgets/bottom_navbar.dart';
import 'package:adopt_v2/src/features/shoppage/models/Product.dart';
import 'package:adopt_v2/src/features/shoppage/models/Services.dart';
import 'package:adopt_v2/src/features/shoppage/widgets/product_card.dart';
import 'package:adopt_v2/src/features/shoppage/widgets/service_card.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> with TickerProviderStateMixin {
  List<Product> shopProducts = [];
  List<Services> serviceProducts = [];
  int currentPage = 1;
  int pageSize = 10;
  int activeIndex = 0;
  PageController _pageController = PageController(initialPage: 0);
  TextEditingController _searchController = TextEditingController();
  bool isLoading = false;
  late TabController _tabController;
  String usertype = '';
  final storage = FlutterSecureStorage();


  @override
  void initState() {
    super.initState();
    _initializeData();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        activeIndex = _tabController.index;
      });
    });
  }

  Future<void> _initializeData() async {
    usertype = await storage.read(key: 'usertype') ?? '';
    setState(() {
      usertype= usertype;
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
        title: Text('Shop'),
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
          SizedBox(height: 16.0),
          TabBar(
            indicator: BoxDecoration(
              color: Colors.blue, // Set the active tab's background color
              borderRadius: BorderRadius.circular(10.0),
            ),
            labelColor: Colors.white, // Set the active tab's text color
            unselectedLabelColor: Colors.grey, // Set the inactive tab's text color
            onTap: (index) {
              setState(() {
                activeIndex = index;
              });
            },
            controller: _tabController,
            tabs: [
              Tab(text: 'My Products'),
              Tab(text: 'All Products'),
            ],
          ),
          SizedBox(height: 16.0),
          Flexible(
            child: TabBarView(
              controller: _tabController,
              children: [
                SellerProductCard(
                  searchQuery: _searchController.text,
                  isLoading: isLoading,
                  onSearchStart: () {
                    setState(() {
                      isLoading = true;
                      _triggerSearch();
                    });
                  },
                ),
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
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SellerBottomBar(),
    );
  }
}
