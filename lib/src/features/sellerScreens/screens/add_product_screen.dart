import 'dart:io';

import 'package:adopt_v2/src/core/widgets/message_dialog.dart';
import 'package:adopt_v2/src/core/widgets/seller_bottombar.dart';
import 'package:adopt_v2/src/features/sellerScreens/models/Product.dart';
import 'package:adopt_v2/src/features/sellerScreens/repositories/seller_repository.dart';
import 'package:adopt_v2/src/features/sellerScreens/screens/product_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {

  final SellerRepository _sellerRepository = SellerRepository();
  final storage = FlutterSecureStorage();
  String username = '';
  late ImagePicker _imagePicker;
  XFile? _selectedImage;
  String _category = 'Food';
  List<String> _categories = ['Food', 'Toys', 'Accessories', 'Grooming'];
  String _condition = 'New';
  List<String> _conditions = ['New', 'Used'];
  bool _isLoading = false;

  TextEditingController _productNameController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _conditionController = TextEditingController();

  TextEditingController _contactPhoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeData();
    _imagePicker = ImagePicker();
    _categoryController.text = _category;
    _conditionController.text = _condition;
  }

  Future<void> _initializeData() async {
    username = await storage.read(key: 'sellername') ?? '';
    setState(() {
      username = username;
    });
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

  void  _saveProductData() async {
    setState(() {
      _isLoading = true; // Show loading effect
    });
    final selectedImagePath = _selectedImage!.path;

    ProductData productData = ProductData(
        productId:'',
      imageUrl: path.basename(selectedImagePath),
      name: _productNameController.text.trim(),
      category: _categoryController.text.trim(),
      price: double.parse(_priceController.text.trim()),
      description: _descriptionController.text.trim(),
      condition: _conditionController.text.trim(),
      sellerName: username,
      sellerContact: _contactPhoneController.text.trim(),
      ratingCount: '0',
    );

    int? responseCode = await _sellerRepository.saveProduct(productData);

    if (responseCode == 201) {
      _copyImageToAssets();
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return MessageDialog(
            title: 'Successful',
            content: 'Product Added Successful',
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
            content: 'Product Added Unsuccessful',
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
    _productNameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();

    _contactPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Pet Care Product'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
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
                      : Center(child: Icon(Icons.add_a_photo)),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _productNameController,
                decoration: InputDecoration(labelText: 'Product Name'),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField(
                value: _category,
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
                value: _condition,
                items: _conditions.map((condition) {
                  return DropdownMenuItem(
                    value: condition,
                    child: Text(condition),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _conditionController.text = value.toString();
                    _condition = value.toString();
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
                onPressed: _isLoading ? null : _saveProductData,
                style: ElevatedButton.styleFrom(
                  primary: Color(0xff34495e), // Set button color to red
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
                          Text('Add Product'),
                        ],
                      ),
                    if (_isLoading) // Show loading effect when loading
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(), // Loading indicator
                          SizedBox(height: 8),
                          Text('Adding Product'), // Loading message
                        ],
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
