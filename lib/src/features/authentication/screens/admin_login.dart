import 'package:adopt_v2/src/features/adminscreen/screens/admin_home.dart';
import 'package:adopt_v2/src/features/authentication/models/User.dart';
import 'package:adopt_v2/src/features/authentication/repositories/auth_repository.dart';
import 'package:adopt_v2/src/features/authentication/screens/signup_screen.dart';
import 'package:adopt_v2/src/features/authentication/screens/vet_signup.dart';
import 'package:adopt_v2/src/features/authentication/screens/welcome_screen.dart';
import 'package:adopt_v2/src/features/homepage/screens/home_screen.dart';
import 'package:adopt_v2/src/features/vetScreens/screens/vet_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});
  @override
  _AdminLoginState createState() => _AdminLoginState();
}
class _AdminLoginState extends State<AdminLogin> {
  // const LoginScreen({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  final TextEditingController adminnameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthRepository backendService = AuthRepository();
  final storage = FlutterSecureStorage();

  Future<void> _login(BuildContext context) async {
    try {
      final String adminname = adminnameController.text;
      final String password = passwordController.text;

      // Call the API endpoint for user authentication
      // Assuming you have a backendService instance that handles API requests
      String token = (await backendService.loginAdmin(adminname, password)) as String;
      if (token.isNotEmpty) {
        // Store the token in secure storage (e.g., Flutter Secure Storage)
        await storage.write(key: 'auth_token', value: token);
        await storage.write(key: 'adminname', value: adminname);
        await storage.write(key: 'usertype', value: 'admin');
        int expirationTimestamp = DateTime.now().add(Duration(hours: 24)).millisecondsSinceEpoch;
        await storage.write(key: 'tokenExpiration', value: expirationTimestamp.toString());
        // and use it for future authenticated API requests

        // Redirect to the homepage screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdminHome()),
        );
      } else {
        // Handle incorrect credentials
        // Show an error message or perform other actions
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Invalid Credentials'),
              content: Text('The adminname or password is incorrect.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Handle login error
      print('Login failed: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Login Failed'),
            content: Text('An error occurred during login. Please try again.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*--- section 1 ---*/
                Image(
                  image: AssetImage("assets/images/petty_logo.png"),
                  width: width * 0.1,
                ),
                Text(
                  "Login as Admin",
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                    color: Color(0xff161F2C), // Set the desired color
                  ),
                ),
                Text(
                  "Fill data",
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    color: Color(0xff7A8B95), // Set the desired color
                  ),
                ),

                /*--- section 2 ---*/
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 30.0 - 10),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: adminnameController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person_outline_outlined),
                            labelText: " username",
                            hintText: "username",
                            border: OutlineInputBorder(),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 30.0 - 20),
                        TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.fingerprint),
                              labelText: "Password",
                              hintText: "Password",
                              border: OutlineInputBorder(),
                              suffixIcon: IconButton(
                                  onPressed: null,
                                  icon: Icon(Icons.remove_red_eye_sharp))),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Password';
                            }else if(value.length < 8){
                              return 'Password must be less than 8 characters';
                            }else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 30.0 - 20,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                              onPressed: () {}, child: Text("Forget Password")),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () {
                                // Validate returns true if the form is valid, or false otherwise.
                                if (_formKey.currentState!.validate()) {
                                  _login(context);
                                }
                              },
                              child: Text("Login".toUpperCase())),
                        )
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("OR"),
                      SizedBox(height: 30.0 - 20),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => WelcomeScreen()),
                          );
                        },
                        child: Text.rich(
                          TextSpan(
                            text: "Sign Up as Seller or User",
                            style: Theme.of(context).textTheme.bodyText1,
                            children: [
                              TextSpan(
                                text: " Sign Up",
                                style: TextStyle(color: Colors.blue),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
