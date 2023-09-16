import 'package:adopt_v2/src/features/authentication/repositories/auth_repository.dart';
import 'package:adopt_v2/src/features/authentication/screens/login_screen.dart';
import 'package:adopt_v2/src/features/authentication/screens/seller_login.dart';
import 'package:adopt_v2/src/features/authentication/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

class SellerSignup extends StatefulWidget {
  const SellerSignup({super.key});
  @override
  _SellerSignupState createState() => _SellerSignupState();
}

class _SellerSignupState extends State<SellerSignup> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _shopController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthRepository _authRepository = AuthRepository();

  void _handleSignUp() async {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String shop = _shopController.text.trim();
    String password = _passwordController.text.trim();

    // Call the signUpUser method and wait for the response
    int? responseCode =
        await _authRepository.signUpSeller(name, email, shop, password);
    print(responseCode);
    // Handle the response and redirect accordingly
    if (responseCode == 201) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Signup Suceessfull'),
            content: Text('Login Now.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SellerLogin()),
                  );
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Signup Failed'),
            content: Text('An error occurred during Signup. Please try again.'),
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
            padding: EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*--- section 1 ---*/
                Image(
                  image: AssetImage("assets/images/petty_logo.png"),
                  width: width * 0.1,
                ),
                Text(
                  "Seller SignUp",
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
                          controller: _nameController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person_outline_outlined),
                            labelText: "Seller Name",
                            hintText: "Seller Name",
                            border: OutlineInputBorder(),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Username';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email_outlined),
                            labelText: "Seller Email",
                            hintText: "Seller Email",
                            border: OutlineInputBorder(),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          controller: _shopController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.storefront),
                            labelText: "Shop Name",
                            hintText: "Shop Name",
                            border: OutlineInputBorder(),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your shop name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          controller: _passwordController,
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
                              return 'Please enter a password';
                            } else if (value.length < 6) {
                              return 'Password must be at least 6 characters long';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 30.0 - 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () {
                                // Validate returns true if the form is valid, or false otherwise.
                                if (_formKey.currentState!.validate()) {
                                  _handleSignUp;
                                }
                              },
                              child: Text("SignUp".toUpperCase())),
                        )
                      ],
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("OR"),
                    const SizedBox(
                      height: 10.0,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SellerLogin()),
                            );
                          },
                          icon: Image(
                            image: AssetImage("assets/images/petty_logo.png"),
                            width: 20.0,
                          ),
                          label: Text("Sign In With Petty")),
                    ),
                    const SizedBox(
                      height: 30.0 - 20,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WelcomeScreen()),
                          );
                        },
                        child: Text.rich(TextSpan(
                            text: "Login as User or Vet",
                            style: Theme.of(context).textTheme.bodyText1,
                            children: [
                              TextSpan(
                                  text: " Login",
                                  style: TextStyle(color: Colors.blue))
                            ])))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
