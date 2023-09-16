import 'dart:convert';
import 'package:adopt_v2/src/core/widgets/seller_bottombar.dart';
import 'package:adopt_v2/src/features/chatScreen/screens/chat_list_screen.dart';
import 'package:adopt_v2/src/features/chatScreen/screens/chat_screen.dart';
import 'package:adopt_v2/src/features/sellerScreens/models/SellerChatList.dart';
import 'package:adopt_v2/src/features/sellerScreens/repositories/seller_repository.dart';
import 'package:adopt_v2/src/features/sellerScreens/screens/seller_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class SellerChatList extends StatefulWidget {
  @override
  _SellerChatListState createState() => _SellerChatListState();
}

class _SellerChatListState extends State<SellerChatList> {
  final storage = FlutterSecureStorage();
  final SellerRepository _chatRepository = SellerRepository();
  List<SellerChatLists> chatData = [];
  TextEditingController _searchController = TextEditingController();
  late String sellername;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _initializeData().then((_) {
      fetchData();
    });
  }

  Future<void> _initializeData() async {
    sellername = await storage.read(key: 'sellername') ?? '';
  }

  Future<void> fetchData() async {
    final chatItems = await _chatRepository.fetchData(sellername); // Use the function from chat_repository.dart

    setState(() {
      chatData = chatItems;
    });

  }

  void _triggerSearch() async {
    // Add a delay of 1 second before triggering the search
    await Future.delayed(Duration(seconds: 1));

    if (mounted) {
      // Check if the widget is still mounted before updating the state
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seller Chat List'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
      Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          prefixIcon: Icon(Icons.search),

          hintText: 'What are you looking for?',
        ),
        onChanged: (value) {
          setState(() {
            _isLoading = true; // Start loading
            _searchController.text = value;
            _triggerSearch(); // Trigger the search function with a delay
          });
        },
      ),
    ),
          Expanded(
            child: ListView.builder(
              itemCount: chatData.length, // Replace with your actual data
              itemBuilder: (BuildContext context, int index) {
                final chat = chatData[index];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/duser.png'), // User's profile image
                  ),
                  title: Text(
                    chat.receiverName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(
                    'lastMessage',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    DateFormat('yyyy-MM-dd HH:mm').format(
                      DateTime.parse(chat.lastTimestamp).toLocal(),
                    ),
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  onTap: () {
                    // Navigate to the individual chat screen with chat.userDetails
                    // You can pass relevant user details to the chat screen.
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SellerChatScreen(userName: chat.receiverName, sellerName: sellername),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: SellerBottomBar(),
    );
  }
}
