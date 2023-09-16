import 'package:adopt_v2/src/features/adminscreen/screens/admin%20profile.dart';
import 'package:adopt_v2/src/features/adminscreen/screens/admin_home.dart';
import 'package:adopt_v2/src/features/adminscreen/screens/manage_appointments.dart';
import 'package:adopt_v2/src/features/adminscreen/screens/manage_listing.dart';
import 'package:adopt_v2/src/features/adminscreen/screens/manage_products.dart';
import 'package:adopt_v2/src/features/authentication/screens/login_screen.dart';
import 'package:adopt_v2/src/features/authentication/screens/welcome_screen.dart';
import 'package:adopt_v2/src/features/breedScreen/screens/dog_breed_prediction_screen.dart';
import 'package:adopt_v2/src/features/donationpage/screens/donation_screen.dart';
import 'package:adopt_v2/src/features/homepage/screens/home_screen.dart';
import 'package:adopt_v2/src/features/listingpage/screens/list_screen.dart';
import 'package:adopt_v2/src/features/profilepage/screens/profile_screen.dart';
import 'package:adopt_v2/src/features/sellerScreens/screens/add_product_screen.dart';
import 'package:adopt_v2/src/features/sellerScreens/screens/product_list_screen.dart';
import 'package:adopt_v2/src/features/sellerScreens/screens/seller_chat_list.dart';
import 'package:adopt_v2/src/features/sellerScreens/screens/seller_home_screen.dart';
import 'package:adopt_v2/src/features/sellerScreens/screens/seller_profile.dart';
import 'package:adopt_v2/src/features/shoppage/screens/shop_screen.dart';
import 'package:adopt_v2/src/features/vetScreens/screens/appointment_history.dart';
import 'package:adopt_v2/src/features/vetScreens/screens/appointments_screen.dart';
import 'package:adopt_v2/src/features/vetScreens/screens/vet_chat_list.dart';
import 'package:adopt_v2/src/features/vetScreens/screens/vet_home_screen.dart';
import 'package:adopt_v2/src/features/vetScreens/screens/vet_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<String?> _checkTokenValidity() async {
    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'token');
    String? expirationString = await storage.read(key: 'tokenExpiration');

    if (token != null && expirationString != null) {
      int expirationTimestamp = int.tryParse(expirationString) ?? 0;
      if (DateTime.now().millisecondsSinceEpoch < expirationTimestamp) {
        return token; // Token is valid
      } else {
        // Token has expired, remove it from secure storage
        await storage.delete(key: 'token');
        await storage.delete(key: 'tokenExpiration');
      }
    }

    return null; // Token is not valid or not available
  }

  Future<void> _navigate(BuildContext context) async {
    String? token = await _checkTokenValidity();
    if (token != null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => WelcomeScreen()));
    }
  }


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: FutureBuilder<String?>(
        future: _checkTokenValidity(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data != null) {
              return HomeScreen();
            } else {
              return WelcomeScreen();
            }
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
      onGenerateRoute: (settings) {
        return MaterialPageRoute(builder: (context) => WelcomeScreen());
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => LoginScreen());
      },
      routes: {
        '/home': (context) => HomeScreen(),
        '/sellerhome': (context) => SellerHomeScreen(),
        '/vethome': (context) => VetHomeScreen(),
        '/adminhome': (context) => AdminHome(),
        '/list': (context) => ListScreen(),
        '/addshop': (context) => AddProductScreen(),
        '/appointments': (context) => AppointmentsScreen(),
        '/shop': (context) => ShopScreen(),
        '/adminlisting': (context) => ManageListings(),
        '/shoplist': (context) => ProductListScreen(),
        '/patienthistory': (context) => AppointmentHistory(),
        '/prediction': (context) => DogBreedPredictionScreen(),
        '/sellermessage': (context) => SellerChatList(),
        '/adminproducts': (context) => ManageProduct(),
        '/vetmessage': (context) => VetChatList(),
        '/profile': (context) => ProfileScreen(),
        '/sellerprofile': (context) => SellerProfile(),
        '/vetprofile': (context) => VetProfile(),
        '/adminappoint': (context) => ManageAppointments(),
        '/adminprofile': (context) => AdminProfile(),
      },
    );
  }
}
