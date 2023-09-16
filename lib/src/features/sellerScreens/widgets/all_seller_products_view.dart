import 'dart:io';

import 'package:adopt_v2/src/features/chatScreen/screens/chat_screen.dart';
import 'package:adopt_v2/src/features/sellerScreens/widgets/edit_product.dart';
import 'package:adopt_v2/src/features/shoppage/models/Product.dart';
import 'package:adopt_v2/src/features/shoppage/repositories/shop_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';

class AllSellerProductView extends StatefulWidget {
  final String productId;

  const AllSellerProductView({required this.productId});

  @override
  _AllSellerProductViewState createState() => _AllSellerProductViewState();
}

class _AllSellerProductViewState extends State<AllSellerProductView> {
  final storage = FlutterSecureStorage();
  Product? product;
  String? imagePath;
  String sellerName = '';
  String usertype = '';

  @override
  void initState() {
    super.initState();
    _initializeData().then((_) {
      fetchProductDetails();
    });
  }

  Future<void> _initializeData() async {
    usertype = await storage.read(key: 'usertype') ?? '';
  }

  Future<void> fetchProductDetails() async {
    ShopRepository repository = ShopRepository();
    Product? fetchedData =
    await repository.fetchOneProductDetails(widget.productId);

    if (fetchedData != null) {
      setState(() {
        product = fetchedData;
        sellerName = fetchedData.sellerName;
      });
    }

    _loadImageFromDocumentsDirectory(product!.imageUrl);
  }

  Future<void> _loadImageFromDocumentsDirectory(String imageName) async {
    try {
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String appDocPath = appDocDir.path;
      final String imgPath = '$appDocPath/$imageName';

      setState(() {
        imagePath = imgPath;
      });
    } catch (e) {
      print('Error loading image from documents directory: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
        backgroundColor: Color(0xFF007AFF),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                image: imagePath != null
                    ? DecorationImage(
                  image: FileImage(File(imagePath!)),
                  fit: BoxFit.cover,
                )
                    : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Product - " + (product?.name ?? ''),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    "Seller - " + sellerName,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 20,
                        color: Colors.amber,
                      ),
                      SizedBox(width: 4.0),
                      Text(
                        product?.ratingCount ?? '',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        '( ' + (product?.ratingCount ?? '') + ' Reviews)',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$' + (product?.price.toString() ?? ''),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Buy Now',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0xFF007AFF),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Divider(
                    color: Colors.grey,
                    thickness: 1.0,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Description:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    product?.description ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            SellerDetailsCard(
              sellerName: sellerName,
              sellerContact: product?.sellerContact ?? '',
            ),
          ],
        ),
      ),
    );
  }
}

class SellerDetailsCard extends StatelessWidget {
  final String sellerName;
  final String sellerContact;

  SellerDetailsCard({
    required this.sellerName,
    required this.sellerContact,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 30.0,
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 40.0,
              ),
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Seller - $sellerName',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Contact\n$sellerContact',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.message),
              color: Color(0xFF007AFF),
              onPressed: () {
                // Handle message icon press
              },
            ),
            IconButton(
              icon: Icon(Icons.phone),
              color: Color(0xFF007AFF),
              onPressed: () {
                // Handle phone icon press
              },
            ),
          ],
        ),
      ),
    );
  }
}
