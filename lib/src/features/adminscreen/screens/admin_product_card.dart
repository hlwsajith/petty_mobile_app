import 'dart:io';

import 'package:adopt_v2/src/core/widgets/message_dialog.dart';
import 'package:adopt_v2/src/core/widgets/modern_message_dialog.dart';
import 'package:adopt_v2/src/features/adminscreen/screens/admin_home.dart';
import 'package:adopt_v2/src/features/sellerScreens/widgets/all_seller_products_view.dart';
import 'package:adopt_v2/src/features/shoppage/screens/product_details_page.dart';
import 'package:flutter/material.dart';
import 'package:adopt_v2/src/features/shoppage/models/Product.dart';
import 'package:adopt_v2/src/features/shoppage/repositories/shop_repository.dart';
import 'package:path_provider/path_provider.dart';

class AdminProductCard extends StatefulWidget {
  final String searchQuery;
  final bool isLoading;
  final VoidCallback onSearchStart;

  AdminProductCard({
    required this.searchQuery,
    required this.isLoading,
    required this.onSearchStart,
  });

  @override
  _AdminProductCardState createState() => _AdminProductCardState();
}

class _AdminProductCardState extends State<AdminProductCard> {
  List<Product> productList = [];
  final ShopRepository backendService = ShopRepository();

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  @override
  void didUpdateWidget(AdminProductCard oldWidget) {
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
        fetchedData = await ShopRepository().searchProducts(widget.searchQuery);
      } else {
        fetchedData = await ShopRepository().fetchAllProducts();
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
      MaterialPageRoute(builder: (context) => AllSellerProductView(productId: productId)),
    );
  }

  void deleteProduct(String productId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ModernMessageDialog(
          title: "Confirmation",
          content: "Are you sure you want to Delete?",
          icon: Icons.warning,
          iconColor: Colors.orange,
          okButtonColor: Colors.green,
          cancelButtonColor: Colors.red,
          okButtonText: "OK",
          cancelButtonText: "Cancel",
          onOkButtonPressed: () async {
            int? responseCode = await backendService.deleteProduct(productId);
            if (responseCode == 200) {
              Navigator.of(context).pop();
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return MessageDialog(
                    title: 'Successful',
                    content: 'Product Deleted Successful',
                    icon: Icons.delete_forever,
                    iconColor: Colors.red,
                    buttonColor: Colors.red,
                    buttonText: 'OK',
                    onButtonPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AdminHome()),
                      );
                    },
                  );
                },
              );
              //
            }else{
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return MessageDialog(
                    title: 'Unsuccessful',
                    content: 'Product delete Unsuccessful',
                    icon: Icons.warning,
                    iconColor: Colors.yellow,
                    buttonColor: Colors.yellow,
                    buttonText: 'OK',
                    onButtonPressed: () {
                      Navigator.of(context).pop();
                    },
                  );
                },
              );
            }

          },
          onCancelButtonPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
        );
      },
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
                color: Color(0xffFEE3EB),
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
                            color: Color(0xff941F1C),
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
                                color: Color(0xffF2759D),
                              ),
                            ),
                            Spacer(),
                            Icon(
                              Icons.star,
                              color: Color(0xffe67e22),
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
                        deleteProduct(product.productId);
                        // Handle favorite button press
                      },
                      icon: Icon(Icons.delete_forever_rounded),
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
