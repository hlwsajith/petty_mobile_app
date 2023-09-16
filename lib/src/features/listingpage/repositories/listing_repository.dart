import 'dart:convert';
import 'package:adopt_v2/src/features/listingpage/models/PetData.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adopt_v2/src/core/models/Animal.dart';

class ListingRepository {
  final String baseUrl = 'http://192.168.1.6:8000';

  // Future<void> submitApplication({
  //   required Animal animal,
  //   required String name,
  //   required String email,
  //   required String phone,
  //   required String address,
  // }) async {
  //   final url = 'YOUR_BACKEND_URL'; // Replace with your backend URL
  //
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? token = prefs.getString('token');
  //
  //     final headers = {
  //       'Content-Type': 'application/json',
  //       if (token != null) 'Authorization': 'Bearer $token',
  //     };
  //
  //     final response = await http.post(
  //       Uri.parse(url),
  //       headers: headers,
  //       body: jsonEncode({
  //         'animal': animal.name,
  //         'name': name,
  //         'email': email,
  //         'phone': phone,
  //         'address': address,
  //       }),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       // Application submitted successfully
  //       print('Application submitted successfully!');
  //     } else {
  //       // Error submitting the application
  //       print('Failed to submit the application. Status code: ${response.statusCode}');
  //     }
  //   } catch (error) {
  //     // Exception occurred while submitting the application
  //     print('An error occurred: $error');
  //   }
  // }

  Future<int?> savePet(PetData petData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/animals/createanimal'),
        body: {
          'imageName': petData.imageName,
          'animalName': petData.animalName,
          'specie': petData.specie,
          'gender': petData.gender,
          'markings': petData.markings,
          'nstatus': petData.nstatus,
          'vaccination': petData.vaccination,
          'SpecialMedicalNeeds': petData.SpecialMedicalNeeds,
          'temperament': petData.temperament,
          'behavioralIssues': petData.behavioralIssues,
          'ageGroup': petData.ageGroup,
          'location': petData.location,
          'contactName': petData.contactName,
          'contactEmail': petData.contactEmail,
          'contactPhone': petData.contactPhone,
          'storyOfAnimal': petData.storyOfAnimal,
          'adopterRequirements': petData.adopterRequirements,
          'tag': petData.tag,
        },
      );

      if (response.statusCode == 201) {
        return response.statusCode;
      } else {
        return null; // Or handle error accordingly
      }
    } catch (e) {
      print('Error saving product: $e');
      return null; // Or handle error accordingly
    }
  }

  Future<int?> editAnimal(Animal petData) async {
    try {

      final response = await http.patch(
        Uri.parse('$baseUrl/animals/editanimal'),
        body: {
          'animalId': petData.animalId,
          'imageName': petData.imageName,
          'animalName': petData.animalName,
          'specie': petData.specie,
          'gender': petData.gender,
          'markings': petData.markings,
          'nstatus': petData.nstatus,
          'vaccination': petData.vaccination,
          'SpecialMedicalNeeds': petData.SpecialMedicalNeeds,
          'temperament': petData.temperament,
          'behavioralIssues': petData.behavioralIssues,
          'ageGroup': petData.ageGroup,
          'location': petData.location,
          'contactName': petData.contactName,
          'contactEmail': petData.contactEmail,
          'contactPhone': petData.contactPhone,
          'storyOfAnimal': petData.storyOfAnimal,
          'adopterRequirements': petData.adopterRequirements,
          'tag': petData.tag,
        },
      );
      print("=================================================================");
      print(response.statusCode);
      print("=================================================================");
      if (response.statusCode == 200) {
        return response.statusCode;
      } else {
        return null; // Or handle error accordingly
      }
    } catch (e) {
      print('Error Updating animal: $e');
      return null; // Or handle error accordingly
    }
  }

  Future<int?> deleteAnimal(String animalId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/animals/deleteanimal?animalId=$animalId'),
        headers: {
          'Content-Type': 'application/json', // Adjust headers as needed
          // Add any additional headers if required for authentication, etc.
        },
      );

      if (response.statusCode == 200) {
        // Successfully deleted the animal
        return response.statusCode;
      } else {
        // Handle other status codes (e.g., 404 for not found)
        print('Failed to delete animal: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error deleting animal: $e');
      return null;
    }
  }
}
