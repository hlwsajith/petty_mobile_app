import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:adopt_v2/src/features/authentication/models/User.dart';

class AuthRepository {
  final String baseUrl = 'http://192.168.1.6:8000';

  Future<String> loginUser(String username, String password) async {
    var headers = {'Content-Type': 'application/json'};
    var body = json.encode({'username': username, 'password': password});

    var response = await http.post(
      Uri.parse('$baseUrl/authenticated/login'),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      String token = responseData['token'];
      return token;
    } else {
      throw Exception('Failed to login: ${response.statusCode}');
    }
  }

  Future<String> loginSeller(String username, String password) async {
    var headers = {'Content-Type': 'application/json'};
    var body = json.encode({'sellername': username, 'password': password});

    var response = await http.post(
      Uri.parse('$baseUrl/authenticated/sellerlogin'),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      String token = responseData['token'];
      return token;
    } else {
      throw Exception('Failed to login: ${response.statusCode}');
    }
  }

  Future<String> loginVet(String username, String password) async {
    var headers = {'Content-Type': 'application/json'};
    var body = json.encode({'vetname': username, 'password': password});

    var response = await http.post(
      Uri.parse('$baseUrl/authenticated/vetlogin'),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      String token = responseData['token'];
      return token;
    } else {
      throw Exception('Failed to login: ${response.statusCode}');
    }
  }

  Future<String> loginAdmin(String adminname, String password) async {
    var headers = {'Content-Type': 'application/json'};
    var body = json.encode({'adminname': adminname, 'password': password});

    var response = await http.post(
      Uri.parse('$baseUrl/authenticated/adminlogin'),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      String token = responseData['token'];
      return token;
    } else {
      throw Exception('Failed to login: ${response.statusCode}');
    }
  }


  Future<int?> signUpUser(String username, String email, String password) async {
    // final url = '$baseUrl/users/createuser';
    var headers = {'Content-Type': 'application/json'};
    var body = json.encode({'username': username,'email':email, 'password': password});
    print(body);
    try {
      var response = await http.post(
        Uri.parse('$baseUrl/users/createuser'),
        headers: headers,
        body: body,
      );
print(response.body);
      if (response.statusCode == 201) {
        // User signed up successfully
        print('User signed up successfully!');
        return response.statusCode;
      } else {
        // Error signing up the user
        print('Failed to sign up the user. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Exception occurred while signing up the user
      print('An error occurred: $error');
    }
  }

  Future<int?> signUpSeller(String username, String email, String shop, String password) async {
    // final url = '$baseUrl/users/createuser';
    var headers = {'Content-Type': 'application/json'};
    var body = json.encode({'sellername': username,'email':email, 'password': password});
    print(body);
    try {
      var response = await http.post(
        Uri.parse('$baseUrl/sellers/createseller'),
        headers: headers,
        body: body,
      );
      print(response.body);
      if (response.statusCode == 201) {
        // User signed up successfully
        print('User signed up successfully!');
        return response.statusCode;
      } else {
        // Error signing up the user
        print('Failed to sign up the user. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Exception occurred while signing up the user
      print('An error occurred: $error');
    }
  }

  Future<int?> signUpVet(String username, String email, String clinic, String password) async {
    // final url = '$baseUrl/users/createuser';
    var headers = {'Content-Type': 'application/json'};
    var body = json.encode({'vetname': username,'email':email, 'password': password});
    print(body);
    try {
      var response = await http.post(
        Uri.parse('$baseUrl/vets/createvet'),
        headers: headers,
        body: body,
      );
      print(response.body);
      if (response.statusCode == 201) {
        // User signed up successfully
        print('User signed up successfully!');
        return response.statusCode;
      } else {
        // Error signing up the user
        print('Failed to sign up the user. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Exception occurred while signing up the user
      print('An error occurred: $error');
    }
  }
}
