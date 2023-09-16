import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnimalCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String location;

  const AnimalCard({
    required this.imagePath,
    required this.name,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          color: Color(0xffFEE3EB), // Replace with suitable color
          margin: EdgeInsets.all(16.0),
          child: SizedBox(
            // height: 140,
            width: 270,// Adjust the height as needed
            child: Padding(
              padding: EdgeInsets.all(14.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff941F1C),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          location,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffF2759D),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        ElevatedButton(
                          onPressed: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => LoginScreen()),
                            // );
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.0), // Set rounded corners
                            ),
                            primary: Color(0xff4FC9E0),
                            onPrimary: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                          ),
                          child: Text("  Adopt Now  "),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          // top: 1,
          right: 19,
          child: Image.asset(
            imagePath, // Replace with actual image path
            width: 118,
            // height: 100,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}