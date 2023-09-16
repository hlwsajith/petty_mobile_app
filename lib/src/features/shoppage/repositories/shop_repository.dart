// shop_repository.dart
import 'dart:convert';
import 'package:adopt_v2/src/features/shoppage/models/Product.dart';
import 'package:adopt_v2/src/features/shoppage/models/Services.dart';
import 'package:adopt_v2/src/features/shoppage/models/VetsService.dart';
import 'package:http/http.dart' as http;

class ShopRepository {

  final String baseUrl = 'http://192.168.1.6:8000';

  Future<List<Product>> fetchAllProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products/getallproducts'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData != null && jsonData is List) {
          List<Product> fetchedData = jsonData.map((json) => Product.fromJson(json)).toList();

          return fetchedData;
        } else {
          throw Exception('Invalid Product data format');
        }
      } else {
        throw Exception('Failed to fetch Product data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch Product data: $e');
    }
  }

  Future<List<VetsService>> fetchAllServices() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/vets/getallvets'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData != null && jsonData is List) {
          List<VetsService> fetchedData = jsonData.map((json) => VetsService.fromJson(json)).toList();
          return fetchedData;
        } else {
          throw Exception('Invalid Services data format');
        }
      } else {
        throw Exception('Failed to fetch Services data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch Services data: $e');
    }
  }

  Future<List<Product>> searchProducts(String searchQuery) async {
    try {
      final encodedQuery = Uri.encodeComponent(searchQuery); // Encode the searchQuery parameter

      final response = await http.get(Uri.parse('$baseUrl/products/searchproducts?query=$encodedQuery'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        List<Product> fetchedData = List<Product>.from(jsonData.map((json) => Product.fromJson(json)));
        return fetchedData;
      } else {
        throw Exception('Failed to search Products');
      }
    } catch (e) {
      throw Exception('Failed to search Products: $e');
    }
  }

  Future<List<VetsService>> searchServices(String searchQuery) async {
    try {
      final encodedQuery = Uri.encodeComponent(searchQuery); // Encode the searchQuery parameter

      final response = await http.get(Uri.parse('$baseUrl/vets/searchvetservices?query=$encodedQuery'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        List<VetsService> fetchedData = List<VetsService>.from(jsonData.map((json) => VetsService.fromJson(json)));
        return fetchedData;
      } else {
        throw Exception('Failed to search Services');
      }
    } catch (e) {
      throw Exception('Failed to search Services: $e');
    }
  }

  // fetchOneProductDetails(String productId) {}

  Future<Product?> fetchOneProductDetails(String productId) async {
    // Make an API call to fetch the details of a specific animal
    // Replace this with your actual API call implementation
    try {
      final response = await http.get(
          Uri.parse('$baseUrl/products/getoneproduct?productId=$productId'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        Product fetchedData = Product.fromJson(jsonData);
        return fetchedData;
      } else {
        throw Exception('Failed to fetch product details');
      }
    } catch (e) {
      throw Exception('Failed to fetch product details: $e');
    }
  }

  Future<int?> deleteProduct(String productId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/products/deleteproduct?productId=$productId'),
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
        print('Failed to delete product: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error deleting product: $e');
      return null;
    }
  }
}
