import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:adopt_v2/src/core/models/Animal.dart';

class AnimalRepository {
  final String baseUrl = 'http://192.168.1.6:8000';

  Future<List<Animal>> fetchAllAnimals() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/animals/getallanimals'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData != null && jsonData is List) {
          print("fetchedData");
          print(jsonData);
          print("fetchedData");
          List<Animal> fetchedData = jsonData.map((json) => Animal.fromJson(json)).toList();

          return fetchedData;
        } else {
          throw Exception('Invalid animal data format');
        }
      } else {
        throw Exception('Failed to fetch animal data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch animal data: $e');
    }
  }

  Future<List<Animal>> fetchAllUserAnimals(String username) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/animals/getalluseranimals?username=$username'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData != null && jsonData is List) {
          print("fetchedData");
          print(jsonData);
          print("fetchedData");
          List<Animal> fetchedData = jsonData.map((json) => Animal.fromJson(json)).toList();

          return fetchedData;
        } else {
          throw Exception('Invalid animal data format');
        }
      } else {
        throw Exception('Failed to fetch animal data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch animal data: $e');
    }
  }




  Future<List<Animal>> searchAnimals(String searchQuery) async {
    try {
      final encodedQuery = Uri.encodeComponent(searchQuery); // Encode the searchQuery parameter

      final response = await http.get(Uri.parse('$baseUrl/animals/searchanimals?query=$encodedQuery'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        List<Animal> fetchedData = List<Animal>.from(jsonData.map((json) => Animal.fromJson(json)));
        return fetchedData;
      } else {
        throw Exception('Failed to search animals');
      }
    } catch (e) {
      throw Exception('Failed to search animals: $e');
    }
  }

  Future<List<Animal>> searchUserAnimals(String searchQuery,String username) async {
    try {
      final encodedQuery = Uri.encodeComponent(searchQuery); // Encode the searchQuery parameter

      final response = await http.get(Uri.parse('$baseUrl/animals/searchuseranimals?query=$encodedQuery&username=$username'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        List<Animal> fetchedData = List<Animal>.from(jsonData.map((json) => Animal.fromJson(json)));
        return fetchedData;
      } else {
        throw Exception('Failed to search animals');
      }
    } catch (e) {
      throw Exception('Failed to search animals: $e');
    }
  }



  Future<List<Animal>> filterAnimals(String specie) async {
    try {

      final queryParams = {
        'sortBy': specie,
        'sortOrder': 'asc',
      };

      final uri = Uri.parse('$baseUrl/animals/filteranimals')
          .replace(queryParameters: queryParams);

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        List<Animal> fetchedData = List<Animal>.from(jsonData.map((json) => Animal.fromJson(json)));
        return fetchedData;
      } else {
        throw Exception('Failed to filter animals');
      }
    } catch (e) {
      throw Exception('Failed to filter animals: $e');
    }
  }

  Future<Animal?> fetchOneAnimalDetails(String animalid) async {
    // Make an API call to fetch the details of a specific animal
    // Replace this with your actual API call implementation
    try {
      final response = await http.get(
          Uri.parse('$baseUrl/animals/getoneanimal?animalid=$animalid'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        Animal fetchedData = Animal.fromJson(jsonData);
        return fetchedData;
      } else {
        throw Exception('Failed to fetch animal details');
      }
    } catch (e) {
      throw Exception('Failed to fetch animal details: $e');
    }
  }
}
