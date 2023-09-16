import 'dart:convert';
import 'package:adopt_v2/src/features/chatScreen/models/Chat.dart';
import 'package:adopt_v2/src/features/sellerScreens/models/Product.dart';
import 'package:adopt_v2/src/features/sellerScreens/models/SellerChatList.dart';
import 'package:adopt_v2/src/features/shoppage/models/Product.dart';
import 'package:http/http.dart' as http;

class SellerRepository {
  final String baseUrl = 'http://192.168.1.6:8000';

  Future<int?> saveProduct(ProductData productData) async {
    try {

      final response = await http.post(
        Uri.parse('$baseUrl/products/createproduct'),
        body: {
          'imageUrl': productData.imageUrl,
          'name': productData.name,
          'category': productData.category,
          'price': productData.price.toString(),
          'description': productData.description,
          'condition': productData.condition,
          'sellerName': productData.sellerName,
          'sellerContact': productData.sellerContact,
          'ratingCount': productData.ratingCount,
        },
      );
      print("=================================================================");
      print(response);
      print("=================================================================");
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

  Future<List<Product>> fetchAllUserProducts(String username) async {
    try {
      final encodedQuery = Uri.encodeComponent(username);
      final response = await http.get(Uri.parse('$baseUrl/sellers/getalluserproducts?query=$encodedQuery'));

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

  Future<List<Product>> fetchAllProducts(String username) async {
    try {
      final encodedQuery = Uri.encodeComponent(username);
      final response = await http.get(Uri.parse('$baseUrl/sellers/getallproducts?query=$encodedQuery'));

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

  Future<List<Product>> searchProducts(String searchQuery,String username) async {
    try {
      final encodedQuery = Uri.encodeComponent(searchQuery); // Encode the searchQuery parameter
      final encodedUsername = Uri.encodeComponent(username);

      final response = await http.get(Uri.parse('$baseUrl/sellers/searchproducts?query=$encodedQuery&username=$encodedUsername'));

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

  Future<List<SellerChatLists>> fetchData(String username) async {
    final response = await http.get(Uri.parse('$baseUrl/message/fetchsvChatLists?username=$username')); // Update the API endpoint

    if (response.statusCode == 200) {

      final jsonData = json.decode(response.body);
      final List<SellerChatLists> chatLists = [];

      for (var chatData in jsonData) {
        chatLists.add(SellerChatLists.fromJson(chatData));
      }

      return chatLists;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Chat>> fetchParticularSellerChats(String sellerName, String username) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/message/fetchParticularsvChats?receiver=$sellerName&sender=$username'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData != null && jsonData is List) {
          List<Chat> fetchedData = List<Chat>.from(jsonData.map((json) {
            return Chat.fromJson(json as Map<String, dynamic>);
          }));
          print(fetchedData);
          return fetchedData;
        } else {
          throw Exception('Invalid Chat data format');
        }
      } else {
        throw Exception('Failed to fetch Chat data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch Chat data: $e');
    }
  }

  Future<int?> editProduct(ProductData productData) async {
    try {

      final response = await http.patch(
        Uri.parse('$baseUrl/products/editproduct'),
        body: {
          'productId': productData.productId,
          'imageUrl': productData.imageUrl,
          'name': productData.name,
          'category': productData.category,
          'price': productData.price.toString(),
          'description': productData.description,
          'condition': productData.condition,
          'sellerName': productData.sellerName,
          'sellerContact': productData.sellerContact,
          'ratingCount': productData.ratingCount,
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
      print('Error saving product: $e');
      return null; // Or handle error accordingly
    }
  }
}