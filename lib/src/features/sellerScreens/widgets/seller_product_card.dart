import 'dart:io';

import 'package:adopt_v2/src/features/sellerScreens/repositories/seller_repository.dart';
import 'package:adopt_v2/src/features/shoppage/screens/product_details_page.dart';
import 'package:flutter/material.dart';
import 'package:adopt_v2/src/features/shoppage/models/Product.dart';
import 'package:adopt_v2/src/features/shoppage/repositories/shop_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';

class SellerProductCard extends StatefulWidget {
  final String searchQuery;
  final bool isLoading;
  final VoidCallback onSearchStart;

  SellerProductCard({
    required this.searchQuery,
    required this.isLoading,
    required this.onSearchStart,
  });

  @override
  _SellerProductCardState createState() => _SellerProductCardState();
}

class _SellerProductCardState extends State<SellerProductCard> {
  List<Product> productList = [];
  final storage = FlutterSecureStorage();
  String username = '';

  @override
  void initState() {
    super.initState();
    _initializeData().then((_) {
    fetchProducts();
      });
  }

  Future<void> _initializeData() async {
    username = await storage.read(key: 'sellername') ?? '';
    setState(() {
      username = username;
    });
  }

  @override
  void didUpdateWidget(SellerProductCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchQuery != oldWidget.searchQuery) {
      fetchProducts();
    } else {
      print('Failed to fetch services');
    }
  }

  Future<void> fetchProducts() async {
    try {
      List<Product> fetchedData;
      if (widget.searchQuery.isNotEmpty) {
        fetchedData = await SellerRepository().searchProducts(widget.searchQuery,username);
      } else {
        fetchedData = await SellerRepository().fetchAllProducts(username);
      }
      setState(() {
        productList = fetchedData;
      });
    } catch (e) {
      print('Failed to fetch products: $e');
    }
  }

  Future<List<File>> _loadImages(List<String> imageNames) async {
    List<File> imageFiles = [];
    Directory appDocDir = await getApplicationDocumentsDirectory();

    for (String imageName in imageNames) {
      String filePath = '${appDocDir.path}/$imageName';
      File imageFile = File(filePath);
      bool fileExists = imageFile.existsSync();

      if (imageFile.existsSync()) {
        imageFiles.add(imageFile);
      }
    }

    return imageFiles;
  }

  void _navigateToProductDetails(String productId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductDetailsPage(productId: productId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.all(12.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: productList.length,
        itemBuilder: (context, index) {
          Product product = productList[index];
          List<String> imageNamesFromBackend = product.imageUrl.split(','); // Replace ',' with your delimiter// Replace with actual field

          return GestureDetector(
            onTap: () {
              _navigateToProductDetails(product.productId);
            },
            child: Container(
              height: 580,
              decoration: BoxDecoration(
                color: Color(0xffF9E4BE),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FutureBuilder<List<File>>(
                        future: _loadImages(imageNamesFromBackend),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error loading images');
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Text('No images available');
                          }

                          List<File> imageFiles = snapshot.data!;

                          return Padding(
                            padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0), // Add your desired padding
                            child: Image.file(
                              imageFiles.first,
                              fit: BoxFit.cover,
                              width: 140,
                              height: 95,
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 0.0),
                        child: Text(
                          product.name,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 4.0),
                        child: Row(
                          children: [
                            Text(
                              '\$${product.price.toStringAsFixed(2)} | ',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            Icon(
                              Icons.star,
                              color: Colors.yellow,
                              size: 16.0,
                            ),
                            Text(
                              '(${product.ratingCount})',
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      onPressed: () {
                        // Handle favorite button press
                      },
                      icon: Icon(Icons.favorite),
                      color: Colors.red,
                      iconSize: 20.0,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
