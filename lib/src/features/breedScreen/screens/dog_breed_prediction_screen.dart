import 'dart:convert';
import 'dart:io';
import 'package:adopt_v2/src/core/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class DogBreedPredictionScreen extends StatefulWidget {
  @override
  _DogBreedPredictionScreenState createState() =>
      _DogBreedPredictionScreenState();
}

class _DogBreedPredictionScreenState extends State<DogBreedPredictionScreen> {
  bool _isLoading = false;
  String _breedName = "";
  XFile? _selectedImage;
  late ImagePicker _imagePicker;

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
  }

  // Function to handle image selection from the device
  Future<void> _pickImage() async {
    final image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  // Function to send the image to the Python backend and fetch data from Node.js backend
  Future<void> _sendImageToBackend(File file) async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('http://192.168.1.6:7000/predict/');
    final request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final responseJson = json.decode(responseBody);

      if (response.statusCode == 200) {
        setState(() {
          _breedName = responseJson['predicted_breed'];
        });

        // Fetch data related to the predicted breed from your Node.js backend
        final breedDataResponse = await http.get(
          Uri.parse(
              'http://192.168.1.6:8000/breeds/getonebreed?breeds=$_breedName'),
        );
        final breedDataJson = json.decode(breedDataResponse.body);

        // Extract breed data
        final description = breedDataJson['Description'];
        final temperament = breedDataJson['Temperament'];
        final origin = breedDataJson['Origin'];
        final averageLifespan = breedDataJson['AverageLifespan'];

        // Show a popup dialog with the predicted breed and data
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xffFEE3EB),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              title: Text(
                'Prediction Result',
                style: TextStyle(fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff941F1C)),
                textAlign: TextAlign.center, // Center-align the title
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Predicted Breed Title
                    Text(
                      'Predicted Breed:',
                      style: TextStyle(fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff941F1C)),
                    ),

                    // Predicted Breed Name
                    Text(
                      _breedName,
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                      textAlign: TextAlign
                          .center, // Center-align the breed name
                    ),
                    SizedBox(height: 16),

                    // Breed Data Title
                    Text(
                      'Breed Data:',
                      style: TextStyle(fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff941F1C)),
                    ),

                    // Breed Data Descriptions
                    RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 16),
                        children: [
                          TextSpan(
                            text: 'Description: ',
                            style: TextStyle(fontWeight: FontWeight.bold,
                                color: Color(0xff941F1C)),
                          ),
                          TextSpan(text: description,
                              style: TextStyle(color: Colors.black)),
                          TextSpan(text: '\nTemperament: ',
                              style: TextStyle(color: Color(0xff941F1C))),
                          TextSpan(text: temperament,
                              style: TextStyle(color: Colors.black)),
                          TextSpan(text: '\nOrigin: ',
                              style: TextStyle(color: Color(0xff941F1C))),
                          TextSpan(text: origin,
                              style: TextStyle(color: Colors.black)),
                          TextSpan(text: '\nAverage Lifespan: ',
                              style: TextStyle(color: Color(0xff941F1C))),
                          TextSpan(text: averageLifespan,
                              style: TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close',
                      style: TextStyle(fontSize: 16, color: Color(0xffe74c3c))),
                ),
              ],
            );
          },
        );
      } else {
        // Handle error here
        print('Error: ${responseJson['error']}');
      }
    } catch (e) {
      // Handle network or other errors
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dog Breed Predictor'),
        backgroundColor: Color(0xff4FC9E0),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top Image
            Image.asset(
              'assets/images/Dogbanner.jpg', // Replace with your image path
              width: double.infinity,
              height: 100, // Adjust the height as needed
              fit: BoxFit.cover,
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                // Your existing content
                children: [
                  // Selected image preview
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: _selectedImage != null
                          ? Image.file(
                          File(_selectedImage!.path), fit: BoxFit.cover)
                          : Center(child: Icon(Icons.add_a_photo)),
                    ),
                  ),

                  SizedBox(height: 16),

                  // Predict the breed button
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () => _sendImageToBackend(File(_selectedImage!.path)),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            14.0), // Set rounded corners
                      ),
                      primary: Color(0xff4FC9E0),
                      // Background color of the button
                      textStyle: TextStyle( // Text size
                        fontWeight: FontWeight.bold, // Text weight (e.g., bold)
                        color: Colors.white, // Text color
                      ),
                      padding: EdgeInsets.all(
                          16.0), // Padding around the button's content
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : Text('Predict the Breed  🐶'),
                  ),

                  SizedBox(height: 16),

                  // Display the predicted breed name
                  _breedName.isNotEmpty
                      ? Column(
                    children: [
                      Text(
                        'Predicted Breed:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _breedName,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                      : SizedBox.shrink(),
                ],
              ),
            ),

            // Bottom Image
            Image.asset(
              'assets/images/Doglooker.jpg', // Replace with your image path
              width: double.infinity,
              height: 80, // Adjust the height as needed
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

