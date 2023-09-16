import 'dart:io';

import 'package:flutter/material.dart';
import 'package:adopt_v2/src/features/listingpage/widgets/animal_details_page.dart';
import 'package:adopt_v2/src/core/models/Animal.dart';
import 'package:adopt_v2/src/core/services/animal_repository.dart';
import 'package:path_provider/path_provider.dart';

class AnimalListGrid extends StatefulWidget {
  final String searchQuery;
  final bool isLoading;
  final VoidCallback onSearchStart;

  AnimalListGrid({
    required this.searchQuery,
    required this.isLoading,
    required this.onSearchStart,
  });

  @override
  _AnimalListGridState createState() => _AnimalListGridState();
}

class _AnimalListGridState extends State<AnimalListGrid> {
  List<Animal> animalList = [];

  @override
  void initState() {
    super.initState();
    _fetchAnimals();
  }

  @override
  void didUpdateWidget(AnimalListGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchQuery != oldWidget.searchQuery) {
      _fetchAnimals();
    }
  }

  Future<void> _fetchAnimals() async {
    AnimalRepository repository = AnimalRepository();
    List<Animal> fetchedData;

    if (widget.searchQuery.isNotEmpty) {
      fetchedData = await repository.searchAnimals(widget.searchQuery);
    } else {
      fetchedData = await repository.fetchAllAnimals();
    }

    setState(() {
      animalList = fetchedData;
    });
  }

  void _navigateToAnimalDetails(String animalId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AnimalDetailsPage(animalId: animalId)),
    );
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

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return GridView.builder(
        padding: EdgeInsets.all(16.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: animalList.length,
        itemBuilder: (context, index) {
          Animal animal = animalList[index];
          List<String> imageNamesFromBackend = animal.imageName.split(',');

          return GestureDetector(
            onTap: () {
              _navigateToAnimalDetails(animal.animalId);
            },
            child: Container(
              width: 150.0, // Set the desired width
              height: 200.0, // Set the desired height
              decoration: BoxDecoration(
                color: Color(0xffFEE3EB),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 8.0),
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
                        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0), // Add your desired padding
                        child: Image.file(
                          imageFiles.first,
                          width: 80.0,
                          height: 80.0,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    '${animal.animalName}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff941F1C),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Location ${animal.location}  📍',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Color(0xffF2759D),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // SizedBox(height: 8.0),
                  // Text(
                  //   '${animal.age} years old',
                  //   style: TextStyle(
                  //     fontSize: 16.0,
                  //     // fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  // SizedBox(height: 8.0),
                  // Text(
                  //   '${animal.availability}',
                  //   style: TextStyle(
                  //     fontSize: 16.0,
                  //     // fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
