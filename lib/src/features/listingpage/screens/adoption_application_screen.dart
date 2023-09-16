import 'dart:io';

import 'package:adopt_v2/src/core/widgets/bottom_navbar.dart';
import 'package:adopt_v2/src/core/widgets/message_dialog.dart';
import 'package:adopt_v2/src/core/widgets/seller_bottombar.dart';
import 'package:adopt_v2/src/features/adminscreen/screens/manage_listing.dart';
import 'package:adopt_v2/src/features/listingpage/models/PetData.dart';
import 'package:adopt_v2/src/features/listingpage/repositories/listing_repository.dart';
import 'package:adopt_v2/src/features/listingpage/screens/list_screen.dart';
import 'package:adopt_v2/src/features/sellerScreens/models/Product.dart';
import 'package:adopt_v2/src/features/sellerScreens/repositories/seller_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class AdoptionApplicationScreen extends StatefulWidget {
  @override
  _AdoptionApplicationScreenState createState() => _AdoptionApplicationScreenState();
}

class _AdoptionApplicationScreenState extends State<AdoptionApplicationScreen> {

  final ListingRepository _listingRepository = ListingRepository();
  final storage = FlutterSecureStorage();
  String username = '';
  String usertype = '';
  late ImagePicker _imagePicker;
  XFile? _selectedImage;
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
    _initializeData();
    _imagePicker = ImagePicker();
    _specieController.text = _specie;
    _ageGroupController.text = _ageGroup;
    _genderController.text = _gender;
    _nstatusController.text = _nstatus;
    _vaccinationController.text = _vaccination;
    _temperamentController.text = _temperament;
    _tagController.text = _tag;
  }

  Future<void> _initializeData() async {
    username = await storage.read(key: 'sellername') ?? '';
    username = await storage.read(key: 'username') ?? '';
    usertype = await storage.read(key: 'usertype') ?? '';
    setState(() {
      username = username;
      usertype= usertype;
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


  void  _savePetData() async {
    final selectedImagePath = _selectedImage!.path;

    PetData petData = PetData(
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

    int? responseCode = await _listingRepository.savePet(petData);
    if (responseCode == 201) {
      _copyImageToAssets();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return MessageDialog(
            title: 'Successful',
            content: 'Pet Added Successful',
            icon: Icons.check_circle,
            iconColor: Colors.green,
            buttonColor: Colors.green,
            buttonText: 'OK',
            onButtonPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              _clearForm();
              routePage();// Clear input fields and selected image
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
            content: 'Pet Add Unsuccessful',
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

  routePage(){
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
  }

  @override
  void dispose() {
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
        title: Text('Add Pet'),
        backgroundColor: Color(0xff4FC9E0),
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
                      _savePetData();
                    },
                    child: Text("Save Pet".toUpperCase())),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
