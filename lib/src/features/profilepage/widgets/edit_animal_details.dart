import 'dart:io';

import 'package:adopt_v2/src/core/models/Animal.dart';
import 'package:adopt_v2/src/core/services/animal_repository.dart';
import 'package:adopt_v2/src/core/widgets/message_dialog.dart';
import 'package:adopt_v2/src/features/adminscreen/screens/manage_listing.dart';
import 'package:adopt_v2/src/features/listingpage/repositories/listing_repository.dart';
import 'package:adopt_v2/src/features/listingpage/screens/list_screen.dart';
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

class EditAnimalDetails extends StatefulWidget {
  final String animalId; // Pass the productId as a parameter

  EditAnimalDetails({required this.animalId});

  @override
  _EditAnimalDetailsState createState() => _EditAnimalDetailsState();
}

class _EditAnimalDetailsState extends State<EditAnimalDetails> {

  final ListingRepository _listingRepository = ListingRepository();
  final storage = FlutterSecureStorage();
  String username = '';
  String usertype = '';
  late ImagePicker _imagePicker;
  XFile? _selectedImage;
  String? _imageFromBackend;
  Future<void>? _fetchData;
  String sellername = '';
  Animal? fetchedDatas;
  bool _isLoading = false;
  String _specie = 'Dog';
  List<String> _species = ['Dog', 'Cat', 'Bird', 'etc.'];
  String _ageGroup = 'Puppy';
  List<String> _ageGroups = ['Puppy', 'Adult', 'Senior'];
  String _gender = 'Male';
  List<String> _genders = ['Male', 'Female'];
  String _nstatus = 'Neutered';
  List<String> _nstatuses = ['Neutered', 'Spayed'];
  String _vaccination = 'Vaccinated';
  List<String> _vaccinations = ['Vaccinated', 'Not Vaccinated'];
  String _temperament = 'Friendly';
  List<String> _temperaments = ['Friendly', 'Shy', 'Playful'];
  String _tag = 'Rescue';
  List<String> _tags = ['Rescue', 'Foster', 'Urgent'];

  // Add your TextEditingController variables for editing product details here
  TextEditingController _animalNameController = TextEditingController();
  TextEditingController _specieController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _markingsController = TextEditingController();
  TextEditingController _nstatusController = TextEditingController();
  TextEditingController _vaccinationController = TextEditingController();
  TextEditingController _SpecialMedicalNeedsController = TextEditingController();
  TextEditingController _temperamentController = TextEditingController();
  TextEditingController _behavioralIssuesController = TextEditingController();
  TextEditingController _ageGroupController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _contactNameController = TextEditingController();
  TextEditingController _contactEmailController = TextEditingController();
  TextEditingController _contactPhoneController = TextEditingController();
  TextEditingController _storyOfAnimalController = TextEditingController();
  TextEditingController _adopterRequirementsController = TextEditingController();
  TextEditingController _tagController = TextEditingController();



  @override
  void initState() {
    super.initState();
    _fetchData = _fetchProductDetails();
    _imagePicker = ImagePicker();
    _initializeData();
  }

  Future<void> _initializeData() async {
    username = await storage.read(key: 'username') ?? '';
    usertype = await storage.read(key: 'usertype') ?? '';
    setState(() {
      username = username;
      usertype= usertype;
    });
  }

  Future<void> _fetchProductDetails() async {
    // Replace this with your logic to fetch product details based on the widget.productId
    // For example:
    AnimalRepository repository = AnimalRepository();
    Animal? fetchedData = await await repository.fetchOneAnimalDetails(widget.animalId);
    fetchedDatas = fetchedData;
    print(fetchedData!.animalName);
    // Then populate the text controllers:
    _animalNameController.text = fetchedData.animalName;
    _specieController.text = fetchedData.specie;
    _genderController.text = fetchedData.gender;
    _markingsController.text = fetchedData.markings;
    _nstatusController.text = fetchedData.nstatus;
    _vaccinationController.text = fetchedData.vaccination;
    _SpecialMedicalNeedsController.text = fetchedData.SpecialMedicalNeeds;
    _temperamentController.text = fetchedData.temperament;
    _behavioralIssuesController.text = fetchedData.behavioralIssues;
    _ageGroupController.text = fetchedData.ageGroup;
    _locationController.text = fetchedData.location;
    _contactNameController.text = fetchedData.contactName;
    _contactEmailController.text = fetchedData.contactEmail;
    _contactPhoneController.text = fetchedData.contactPhone;
    _storyOfAnimalController.text = fetchedData.storyOfAnimal;
    _adopterRequirementsController.text = fetchedData.adopterRequirements;
    _tagController.text = fetchedData.tag;

    _imageFromBackend = fetchedData.imageName;

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

  void _saveEditedAnimalData() async {
    setState(() {
      _isLoading = true; // Show loading effect
    });
    final selectedImagePath = _selectedImage!.path;
    Animal productData = Animal(
      animalId: fetchedDatas!.animalId,
      imageName: path.basename(selectedImagePath),
      animalName: _animalNameController.text.trim(),
      specie: _specieController.text.trim(),
      gender: _genderController.text.trim(),
      markings: _markingsController.text.trim(),
      nstatus: _nstatusController.text.trim(),
      vaccination: _vaccinationController.text.trim(),
      SpecialMedicalNeeds: _SpecialMedicalNeedsController.text.trim(),
      temperament: _temperamentController.text.trim(),
      behavioralIssues: _behavioralIssuesController.text.trim(),
      ageGroup: _ageGroupController.text.trim(),
      location: _locationController.text.trim(),
      contactName: _contactNameController.text.trim(),
      contactEmail: _contactEmailController.text.trim(),
      contactPhone: _contactPhoneController.text.trim(),
      storyOfAnimal: _storyOfAnimalController.text.trim(),
      adopterRequirements: _adopterRequirementsController.text.trim(),
      tag: _tagController.text.trim(),
    );

    int? responseCode = await _listingRepository.editAnimal(productData);
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
            content: 'Pet Edit Successful',
            icon: Icons.check_circle,
            iconColor: Colors.green,
            buttonColor: Colors.green,
            buttonText: 'OK',
            onButtonPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              _clearForm(); // Clear input fields and selected image
              if(usertype == 'admin'){
                Navigator.push(
                  context as BuildContext,
                  MaterialPageRoute(builder: (context) => ManageListings()),
                );
              }else{
                Navigator.push(
                  context as BuildContext,
                  MaterialPageRoute(builder: (context) => ListScreen()),
                );
              }

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
            content: 'Pet Edit Unsuccessful',
            icon: Icons.error,
            iconColor: Colors.red,
            buttonColor: Colors.red,
            buttonText: 'OK',
            onButtonPressed: () {
              Navigator.of(context).pop();
            },
          );
        },
      );
    }
  }
  void _clearForm() {
    setState(() {
      _selectedImage = null;
      _animalNameController.clear();
      _specieController.text = _specie;
      _genderController.text = _gender;
      _nstatusController.text = _nstatus;
      _vaccinationController.text = _vaccination;
      _temperamentController.text = _temperament;
      _tagController.text = _tag;
      _contactPhoneController.clear();
      _markingsController.clear();
      _SpecialMedicalNeedsController.clear();
      _behavioralIssuesController.clear();
      _locationController.clear();
      _contactNameController.clear();
      _contactEmailController.clear();
      _contactPhoneController.clear();
      _storyOfAnimalController.clear();
      _adopterRequirementsController.clear();
    } );
  }
  @override
  void dispose() {
    // Dispose of your text controllers
    _animalNameController.dispose();
    _specieController.dispose();
    _genderController.dispose();
    _nstatusController.dispose();
    _vaccinationController.dispose();
    _temperamentController.dispose();
    _tagController.dispose();
    _contactPhoneController.dispose();
    _markingsController.dispose();
    _SpecialMedicalNeedsController.dispose();
    _behavioralIssuesController.dispose();
    _locationController.dispose();
    _contactNameController.dispose();
    _contactEmailController.dispose();
    _contactPhoneController.dispose();
    _storyOfAnimalController.dispose();
    _adopterRequirementsController.dispose();
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
                      controller: _animalNameController,
                      decoration: InputDecoration(labelText: 'Animal"s Name'),
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField(
                      value: _specie,
                      items: _species.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _specieController.text = value.toString();
                          _specie = value.toString();
                        });
                      },
                      decoration: InputDecoration(labelText: 'Species'),
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField(
                      value: _gender,
                      items: _genders.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _genderController.text = value.toString();
                          _gender = value.toString();
                        });
                      },
                      decoration: InputDecoration(labelText: 'Gender'),
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField(
                      value: _ageGroup,
                      items: _ageGroups.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _ageGroupController.text = value.toString();
                          _ageGroup = value.toString();
                        });
                      },
                      decoration: InputDecoration(labelText: 'Gender'),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _markingsController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Color/Markings'),
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField(
                      value: _nstatus ,
                      items: _nstatuses.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _nstatusController.text = value.toString();
                          _nstatus = value.toString();
                        });
                      },
                      decoration: InputDecoration(labelText: 'Neutered/Spayed Status'),
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField(
                      value: _vaccination,
                      items: _vaccinations.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _vaccinationController.text = value.toString();
                          _vaccination = value.toString();
                        });
                      },
                      decoration: InputDecoration(labelText: 'Vaccination Status'),
                    ),
                    TextFormField(
                      controller: _SpecialMedicalNeedsController,
                      maxLines: 3,
                      decoration: InputDecoration(labelText: 'Any Special Medical Needs'),
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField(
                      value: _temperament,
                      items: _temperaments.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _temperamentController.text = value.toString();
                          _temperament = value.toString();
                        });
                      },
                      decoration: InputDecoration(labelText: 'Temperament'),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _behavioralIssuesController,
                      maxLines: 3,
                      decoration: InputDecoration(labelText: 'Any Behavioral Issues (if applicable)'),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _locationController,
                      maxLines: 3,
                      decoration: InputDecoration(labelText: 'Location'),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _contactNameController,
                      maxLines: 3,
                      decoration: InputDecoration(labelText: 'Contact Name'),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _contactEmailController,
                      maxLines: 3,
                      decoration: InputDecoration(labelText: 'Contact Email'),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _contactPhoneController,
                      maxLines: 3,
                      decoration: InputDecoration(labelText: 'Contact Phone'),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _storyOfAnimalController,
                      maxLines: 3,
                      decoration: InputDecoration(labelText: 'Story Of Pet'),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _adopterRequirementsController,
                      maxLines: 3,
                      decoration: InputDecoration(labelText: 'Adopter Requirements'),
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField(
                      value: _tag,
                      items: _tags.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _tagController.text = value.toString();
                          _tag = value.toString();
                        });
                      },
                      decoration: InputDecoration(labelText: 'Tag'),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            _saveEditedAnimalData();
                          },
                          child: Text("Edit Pet".toUpperCase())),
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