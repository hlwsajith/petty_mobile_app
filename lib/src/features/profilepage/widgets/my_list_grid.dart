import 'dart:io';

import 'package:adopt_v2/src/core/widgets/message_dialog.dart';
import 'package:adopt_v2/src/core/widgets/modern_message_dialog.dart';
import 'package:adopt_v2/src/features/listingpage/repositories/listing_repository.dart';
import 'package:adopt_v2/src/features/profilepage/widgets/animal_details_user_page.dart';
import 'package:adopt_v2/src/features/profilepage/widgets/listings_screen.dart';
import 'package:flutter/material.dart';
import 'package:adopt_v2/src/features/listingpage/widgets/animal_details_page.dart';
import 'package:adopt_v2/src/core/models/Animal.dart';
import 'package:adopt_v2/src/core/services/animal_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';

class MyListGrid extends StatefulWidget {
  final String searchQuery;
  final bool isLoading;
  final VoidCallback onSearchStart;

  MyListGrid({
    required this.searchQuery,
    required this.isLoading,
    required this.onSearchStart,
  });

  @override
  _MyListGridState createState() => _MyListGridState();
}

class _MyListGridState extends State<MyListGrid> {
  final storage = FlutterSecureStorage();
  List<Animal> animalList = [];
  String username = '';
  final ListingRepository backendService = ListingRepository();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


  @override
  void initState() {
    super.initState();
    _initializeData().then((_) {
      _fetchAnimals();
    });

  }

  Future<void> _initializeData() async {
    username = await storage.read(key: 'username') ?? '';

  }

  @override
  void didUpdateWidget(MyListGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchQuery != oldWidget.searchQuery) {
      _fetchAnimals();
    }
  }

  Future<void> _fetchAnimals() async {
    AnimalRepository repository = AnimalRepository();
    List<Animal> fetchedData;

    if (widget.searchQuery.isNotEmpty) {
      fetchedData = await repository.searchUserAnimals(widget.searchQuery,username);
    } else {
      fetchedData = await repository.fetchAllUserAnimals(username);
    }

    setState(() {
      animalList = fetchedData;
    });
  }

  void _navigateToUserAnimalDetails(String animalId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AnimalDetailsUserPage(animalId: animalId)),
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

  void deleteAnimal(String animalId) async {
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
            int? responseCode = await backendService.deleteAnimal(animalId);
            if (responseCode == 200) {
              Navigator.of(context).pop();
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return MessageDialog(
                    title: 'Successful',
                    content: 'Appointment Deleted Successful',
                    icon: Icons.delete_forever,
                    iconColor: Colors.red,
                    buttonColor: Colors.red,
                    buttonText: 'OK',
                    onButtonPressed: () {
                      Navigator.of(context).pop();
                      navigatorKey.currentState?.pushReplacement(MaterialPageRoute(
                        builder: (context) => UserListingsScreen(),
                      ));
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
                    content: 'Appointment delete Unsuccessful',
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
        padding: EdgeInsets.all(12.0),
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
              _navigateToUserAnimalDetails(animal.animalId);
            },
            child: Container(

              width: 5.0, // Set the desired width
              height: 200.0, // Set the desired height
              decoration: BoxDecoration(
                color: Color(0xffFEE3EB),
                borderRadius: BorderRadius.circular(10.0),
              ),
          child: Stack(
              children: [
              Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                          padding: const EdgeInsets.fromLTRB(12.0, 0.0, 0.0, 0.0), // Add your desired padding
                          child: Image.file(
                            imageFiles.first,
                            width: 80.0,
                            height: 80.0,
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 8.0),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 2.0, 0.0, 0.0),
                      child: Text(
                        '${animal.animalName}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff941F1C),
                        ),
                      ),
                      ),
                    SizedBox(width: 8.0),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(19.0, 2.0, 0.0, 0.0),
                      child: Text(
                        'Location ${animal.location}  📍',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Color(0xffF2759D),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ]
              ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    onPressed: () {
                      deleteAnimal(animal.animalId);
                      // deleteItem(animal.animalId);
                      // Handle favorite button press
                    },
                    icon: Icon(Icons.delete_forever),
                    color: Colors.red,
                    iconSize: 20.0,
                  ),
                ),
              ]
          )
              // child: Flex(
              //   direction: Axis.vertical,
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     SizedBox(height: 8.0),
              //     FutureBuilder<List<File>>(
              //       future: _loadImages(imageNamesFromBackend),
              //       builder: (context, snapshot) {
              //         if (snapshot.connectionState == ConnectionState.waiting) {
              //           return CircularProgressIndicator();
              //         } else if (snapshot.hasError) {
              //           return Text('Error loading images');
              //         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              //           return Text('No images available');
              //         }
              //
              //         List<File> imageFiles = snapshot.data!;
              //
              //         return Padding(
              //           padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0), // Add your desired padding
              //           child: Image.file(
              //             imageFiles.first,
              //             width: 80.0,
              //             height: 80.0,
              //           ),
              //         );
              //       },
              //     ),
              //     SizedBox(height: 8.0),
              //     Text(
              //       '${animal.animalName}',
              //       style: TextStyle(
              //         fontSize: 20,
              //         fontWeight: FontWeight.bold,
              //         color: Color(0xff941F1C),
              //       ),
              //     ),
              //     SizedBox(height: 8.0),
              //     Text(
              //       'Location ${animal.location}  📍',
              //       style: TextStyle(
              //         fontSize: 14.0,
              //         color: Color(0xffF2759D),
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //     // SizedBox(height: 8.0),
              //     // Text(
              //     //   '${animal.age} years old',
              //     //   style: TextStyle(
              //     //     fontSize: 16.0,
              //     //     // fontWeight: FontWeight.bold,
              //     //   ),
              //     // ),
              //     // SizedBox(height: 8.0),
              //     // Text(
              //     //   '${animal.availability}',
              //     //   style: TextStyle(
              //     //     fontSize: 16.0,
              //     //     // fontWeight: FontWeight.bold,
              //     //   ),
              //     // ),
              //   ],
              // ),
            ),
          );
        },
      );
    }
  }


}
