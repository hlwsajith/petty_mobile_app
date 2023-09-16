import 'dart:io';

import 'package:adopt_v2/src/features/profilepage/widgets/edit_animal_details.dart';
import 'package:flutter/material.dart';
import 'package:adopt_v2/src/core/models/Animal.dart';
import 'package:adopt_v2/src/core/services/animal_repository.dart';
import 'package:path_provider/path_provider.dart';

class AnimalDetailsAdminPage extends StatefulWidget {
  final String animalId;

  const AnimalDetailsAdminPage({required this.animalId});

  @override
  _AnimalDetailsAdminPageState createState() => _AnimalDetailsAdminPageState();
}

class _AnimalDetailsAdminPageState extends State<AnimalDetailsAdminPage> {
  Animal? animal;

  @override
  void initState() {
    super.initState();
    fetchAnimalDetails();
  }

  Future<void> fetchAnimalDetails() async {
    AnimalRepository repository = AnimalRepository();
    Animal? fetchedData = await repository.fetchOneAnimalDetails(widget.animalId);

    setState(() {
      animal = fetchedData;
    });
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

  Future<String?> _loadImageFromDocumentsDirectory(String imageName) async {
    try {
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String appDocPath = appDocDir.path;
      final String imagePath = '$appDocPath/$imageName'; // Replace with your image naming logic
      return imagePath;
    } catch (e) {
      print('Error loading image from documents directory: $e');
      return null; // Handle errors appropriately in your code
    }
  }

  _editAnimal(String animalId){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditAnimalDetails(animalId: animalId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (animal == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Pet Details'),
          backgroundColor: Color(0xff4FC9E0),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Animal Details'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Color(0xffD4EBF2),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Center(
                    child:
                    FutureBuilder<String?>(
                      future: _loadImageFromDocumentsDirectory(animal!.imageName),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError || snapshot.data == null) {
                          return Text('Error loading image');
                        } else if (snapshot.data!.isEmpty) {
                          return Text('No image available');
                        }

                        String imagePath = snapshot.data!;

                        return Padding(
                          padding: const EdgeInsets.all(0.0), // Add your desired padding
                          child: Image.file(
                            File(imagePath),
                            width: 80.0,
                            height: 80.0,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  animal!.animalName,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xff941F1C),),
                ),
                SizedBox(height: 10.0),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 20,
                      color: Color(0xffC77378, ), // Replace with your desired color
                    ),
                    SizedBox(width: 4.0),
                    Text(
                      animal!.location,
                      style: TextStyle(fontSize: 16, color: Color(0xffF2759D),fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        color: Color(0xffDDF0C8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  animal!.gender,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Align(
                                alignment: Alignment.center,
                                child: Text('Gender'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: Card(
                        color: Color(0xffFFEAC2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  animal!.ageGroup,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Align(
                                alignment: Alignment.center,
                                child: Text('Age'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: Card(
                        color: Color(0xffC2ECFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  animal!.specie,
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Align(
                                alignment: Alignment.center,
                                child: Text('Species'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Card(
                  color: Color(0xffEAF0F8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder<String?>(
                          future: _loadImageFromDocumentsDirectory(animal!.imageName), // Replace with your logic to load image path from the documents directory
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error loading images');
                            } else if (!snapshot.hasData || snapshot.data == null) {
                              return Text('No images available');
                            }

                            String imagePath = snapshot.data!;

                            return CircleAvatar(
                              backgroundImage: FileImage(File(imagePath)),
                              radius: 30.0, // Set your desired radius
                            );
                          },
                        ),
                        SizedBox(width: 10.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              animal!.contactName,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text('This is the user\'s descr'),
                          ],
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.message),
                          color: Color(0xff3498db),
                          onPressed: () {
                            // Handle message icon press
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.call),
                          color: Color(0xff2ecc71),
                          onPressed: () {
                            // Handle call icon press
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Description:',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff941F1C)
                  ),
                ),
                SizedBox(height: 8.0),
                Text(animal!.storyOfAnimal),
                SizedBox(height: 16.0),
                Center(
                  child: Container(
                    width: double.infinity, // Match the screen width
                    child: ElevatedButton(
                      onPressed: () {
                        _editAnimal(animal!.animalId);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.edit), // Add your desired icon here
                          SizedBox(width: 8.0), // Adjust spacing between icon and text
                          Text('Edit'),
                        ],
                      ),
                    ),
                  ),
                )

              ],
            ),
          ),
        ),
      );
    }
  }
}
