import 'dart:convert';
import 'package:adopt_v2/src/features/chatScreen/models/Chat.dart';
import 'package:adopt_v2/src/features/chatScreen/models/ChatList.dart';
import 'package:adopt_v2/src/features/chatScreen/models/ChatUser.dart';
import 'package:adopt_v2/src/features/chatScreen/models/Sellers.dart';
import 'package:adopt_v2/src/features/chatScreen/models/Vets.dart';
import 'package:http/http.dart' as http;

class ChatRepository {
  final String baseUrl = 'http://192.168.1.6:8000';

  Future<List<Chat>> fetchParticularChats(String sellerName, String username) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/message/fetchParticularChats?receiver=$sellerName&username=$username'));
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

  Future<List<ChatList>> fetchData(String username) async {
    final response = await http.get(Uri.parse('$baseUrl/message/fetchChatLists?username=$username')); // Update the API endpoint

    if (response.statusCode == 200) {

      final jsonData = json.decode(response.body);
      final List<ChatList> chatLists = [];

      for (var chatData in jsonData) {
        chatLists.add(ChatList.fromJson(chatData));
      }

      return chatLists;
    } else {
      throw Exception('Failed to load data');
    }
  }


  // static Future<Map<String, dynamic>> _fetchSellerList(String userId) async {
  //   try {
  //     // Call your backend API function to fetch data for the selected user
  //     final response = await YourApiService.fetchUserData(userId); // Replace with your API call
  //
  //     // Return the fetched data as a Map
  //     return response as Map<String, dynamic>;
  //   } catch (error) {
  //     // Handle any errors that occur during the API call
  //     print('Error fetching data from the backend: $error');
  //     // You can throw an exception or return an error message as needed.
  //     throw Exception('Failed to fetch data from the backend');
  //   }
  // }

  Future<List<ChatUser>> fetchSellerList(String username) async {
    try {
      final encodedQuery = Uri.encodeComponent(username);
      final response = await http.get(Uri.parse('$baseUrl/sellers/getallproducts?query=$encodedQuery'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData != null && jsonData is List) {
          List<ChatUser> fetchedData = jsonData.map((json) => ChatUser.fromJson(json)).toList();

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

  Future<List<Sellers>> fetchAllSellers() async {
    try {
      // final encodedQuery = Uri.encodeComponent(username);
      final response = await http.get(Uri.parse('$baseUrl/sellers/getallsellers'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData != null && jsonData is List) {
          List<Sellers> fetchedData = jsonData.map((json) => Sellers.fromJson(json)).toList();

          return fetchedData;
        } else {
          throw Exception('Invalid Sellers data format');
        }
      } else {
        throw Exception('Failed to fetch Sellers data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch Sellers data: $e');
    }
  }

  Future<List<Vets>> fetchAllVets() async {
    try {
      // final encodedQuery = Uri.encodeComponent(username);
      final response = await http.get(Uri.parse('$baseUrl/vets/getallvets'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData != null && jsonData is List) {
          List<Vets> fetchedData = jsonData.map((json) => Vets.fromJson(json)).toList();

          return fetchedData;
        } else {
          throw Exception('Invalid Vets data format');
        }
      } else {
        throw Exception('Failed to fetch Vets data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch Vets data: $e');
    }
  }


}
