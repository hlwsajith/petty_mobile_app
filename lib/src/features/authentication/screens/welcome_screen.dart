import 'package:adopt_v2/src/features/authentication/screens/admin_login.dart';
import 'package:adopt_v2/src/features/authentication/screens/login_screen.dart';
import 'package:adopt_v2/src/features/authentication/screens/seller_login.dart';
import 'package:adopt_v2/src/features/authentication/screens/signup_screen.dart';
import 'package:adopt_v2/src/features/authentication/screens/vet_login.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20.0),
        color: Color(0xffDDF4FA), // Set the background color to blue
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image(
              image: AssetImage("assets/images/dogs-removebg-preview.png"),
              height: height * 0.4,
            ),
            Column(
              children: [
                Text(
                  "Welcome to Petty",
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                        color: Color(0xff161F2C), // Set the desired color
                      ),
                ),
                Text(
                  "Join and adopt your dream pet",
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        color: Color(0xff7A8B95), // Set the desired color
                      ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 30.0,
                ),
                Container(
                  width: double.infinity, // Set the width of the buttons
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      primary: Color(0xff4FC9E0),
                      onPrimary: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                    ),
                    child: Text("Login as User".toUpperCase()),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  width: double.infinity, // Set the width of the buttons
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SellerLogin()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      primary: Color(0xff4FC9E0),
                      onPrimary: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                    ),
                    child: Text("Login as Seller".toUpperCase()),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  width: double.infinity, // Set the width of the buttons
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => VetLogin()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      primary: Color(0xff4FC9E0),
                      onPrimary: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                    ),
                    child: Text("Login as Vet".toUpperCase()),
                  ),
                ),
                Container(
                  width: double.infinity, // Set the width of the buttons
                  child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AdminLogin()),
                        );
                      },
                      icon: Image(image: AssetImage("assets/images/petty_logo.png"), width: 20.0,),
                      label: Text("Admin Login")),

                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
