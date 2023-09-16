import 'dart:io';

import 'package:adopt_v2/src/core/widgets/message_dialog.dart';
import 'package:adopt_v2/src/features/sellerScreens/models/Product.dart';
import 'package:adopt_v2/src/features/sellerScreens/repositories/seller_repository.dart';
import 'package:adopt_v2/src/features/sellerScreens/screens/product_list_screen.dart';
import 'package:adopt_v2/src/features/shoppage/models/Product.dart';
import 'package:adopt_v2/src/features/shoppage/repositories/shop_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class ProductEditScreen extends StatefulWidget {
  final String productId; // Pass the productId as a parameter

  ProductEditScreen({required this.productId});

  @override
  _ProductEditScreenState createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
  late ImagePicker _imagePicker;
  XFile? _selectedImage;
  final storage = FlutterSecureStorage();
  final SellerRepository _sellerRepository = SellerRepository();
  String _category = 'Food';
  List<String> _categories = ['Food', 'Toys', 'Accessories', 'Grooming'];
  String _condition = 'New';
  List<String> _conditions = ['New', 'Used'];

  // Add your TextEditingController variables for editing product details here
  TextEditingController _productNameController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _conditionController = TextEditingController();
  TextEditingController _contactPhoneController = TextEditingController();

  String? _imageFromBackend;

  Future<void>? _fetchData;
  bool _isLoading = false;
  String sellername = '';
  Product? fetchedDatas;

  @override
  void initState() {
    super.initState();
    _fetchData = _fetchProductDetails();
    _imagePicker = ImagePicker();
    _initializeData();
    // _fetchProductDetails();
    // _imagePicker = ImagePicker();
    // Fetch product details using widget.productId and populate the input fields here
    // _categoryController.text = _category;
    // _conditionController.text = _condition;

  }

  Future<void> _initializeData() async {
    sellername = await storage.read(key: 'sellername') ?? '';
    setState(() {
      sellername = sellername;
    });
  }

  Future<void> _fetchProductDetails() async {
    // Replace this with your logic to fetch product details based on the widget.productId
    // For example:
    ShopRepository repository = ShopRepository();
    Product? fetchedData = await repository.fetchOneProductDetails(widget.productId);
    fetchedDatas = fetchedData;
    print(fetchedData!.name);
    // Then populate the text controllers:
    _productNameController.text = fetchedData.name;
    // _categoryController.text = fetchedData.category;

    _priceController.text = fetchedData.price.toString();
    _descriptionController.text = fetchedData.description;
    // _conditionController.text = fetchedData.condition;

    _contactPhoneController.text = fetchedData.sellerContact;
    if (_conditions.contains(fetchedData.category)) {
      _categoryController.text = fetchedData.category;
    } else {
      _categoryController.text = _categories[0]; // Set a default value if the fetched condition is not found
    }
    if (_conditions.contains(fetchedData.condition)) {
      _conditionController.text = fetchedData.condition;
    } else {
      _conditionController.text = _conditions[0]; // Set a default value if the fetched condition is not found
    }

    _imageFromBackend = fetchedData.imageUrl;

  }

  Future<void> _pickImage() async {
    final image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  Future<void> _copyImageToAssets() async {
    if (_selectedImage != null) {
      final selectedImagePath = _selectedImage!.path;
      File selectedFile = File(selectedImagePath);
      await saveFile(selectedFile);
    }
  }

  Future<void> saveFile(File file) async {
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      final selectedImagePath = _selectedImage!.path;
      final imageName = path.basename(selectedImagePath);
      String filePath = '${appDocDir.path}/$imageName';

      await file.copy(filePath);
      print('File saved at: $filePath');
    } catch (e) {
      print('Error saving file: $e');
    }
  }

  void _saveEditedProductData() async {
    setState(() {
      _isLoading = true; // Show loading effect
    });
    final selectedImagePath = _selectedImage!.path;
    ProductData productData = ProductData(
      productId: fetchedDatas!.productId,
      imageUrl: path.basename(selectedImagePath),
      name: _productNameController.text.trim(),
      category: _categoryController.text.trim(),
      price: double.parse(_priceController.text.trim()),
      description: _descriptionController.text.trim(),
      condition: _conditionController.text.trim(),
      sellerName: sellername,
      sellerContact: _contactPhoneController.text.trim(),
      ratingCount: '0',
    );

    int? responseCode = await _sellerRepository.editProduct(productData);
    // Implement saving edited product data and updating the database here
    // Don't forget to also update the image if a new image is selected
    if (responseCode == 200) {
      _copyImageToAssets();
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return MessageDialog(
            title: 'Successful',
            content: 'Product Edit Successful',
            icon: Icons.check_circle,
            iconColor: Colors.green,
            buttonColor: Colors.green,
            buttonText: 'OK',
            onButtonPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              _clearForm(); // Clear input fields and selected image
              Navigator.push(
                context as BuildContext,
                MaterialPageRoute(builder: (context) => ProductListScreen()),
              );
            },
          );
        },
      );

    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return MessageDialog(
            title: 'Unsuccessful',
            content: 'Product Edit Unsuccessful',
            icon: Icons.error,
            iconColor: Colors.red,
            buttonColor: Colors.red,
            buttonText: 'OK',
            onButtonPressed: () {
              // Navigator.pop(context);
            },
          );
        },
      );
    }
  }
  void _clearForm() {
    setState(() {
      _selectedImage = null;
      _productNameController.clear();
      _categoryController.text = _category;
      _priceController.clear();
      _descriptionController.clear();
      _conditionController.clear();

      _contactPhoneController.clear();
    } );
  }
  @override
  void dispose() {
    // Dispose of your text controllers
    _productNameController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _conditionController.dispose();
    _contactPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: FutureBuilder<void>(
        future: _fetchData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                        ),
                        child: _selectedImage != null
                            ? Image.file(File(_selectedImage!.path), fit: BoxFit.cover)
                            : (_imageFromBackend != null
                            ? FutureBuilder<bool>(
                          future: _doesImageExist(_imageFromBackend!),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasData && snapshot.data!) {
                              return FutureBuilder<String>(
                                future: _constructImagePath(_imageFromBackend!),
                                builder: (context, pathSnapshot) {
                                  if (pathSnapshot.connectionState == ConnectionState.waiting) {
                                    return Center(child: CircularProgressIndicator());
                                  } else if (pathSnapshot.hasData) {
                                    final imagePath = pathSnapshot.data!;
                                    return GestureDetector(
                                      onTap: _pickImage, // Trigger image selection
                                      child: Image.file(File(imagePath), fit: BoxFit.cover),
                                    );
                                  } else {
                                    return Center(child: Icon(Icons.add_a_photo));
                                  }
                                },
                              );
                            } else {
                              return Center(child: Icon(Icons.add_a_photo));
                            }
                          },
                        )
                            : Center(child: Icon(Icons.add_a_photo))),
                      ),
                    ),

                    SizedBox(height: 16),
                    TextFormField(
                      controller: _productNameController,
                      decoration: InputDecoration(labelText: 'Product Name'),
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField(
                      value: _categoryController.text,
                      items: _categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _categoryController.text = value.toString();
                          _category = value.toString();
                        });
                      },
                      decoration: InputDecoration(labelText: 'Category'),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Price'),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(labelText: 'Description'),
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField(
                      value: _conditionController.text,
                      items: _conditions.map((condition) {
                        return DropdownMenuItem(
                          value: condition,
                          child: Text(condition),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _conditionController.text = value.toString();
                        });
                      },
                      decoration: InputDecoration(labelText: 'Condition'),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _contactPhoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(labelText: 'Contact Phone'),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _saveEditedProductData,
                      child: Text('Save'),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<String> _constructImagePath(String imageName) async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final imagePath = File('${appDocDir.path}/$imageName');
    return imagePath.path;
  }

  Future<bool> _doesImageExist(String imageName) async {
    try {
      final imagePath = await _constructImagePath(imageName);
      final file = File(imagePath);
      return await file.exists();
    } catch (e) {
      return false;
    }
  }
}