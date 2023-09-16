import 'package:adopt_v2/src/features/chatScreen/models/ChatList.dart';
import 'package:adopt_v2/src/features/chatScreen/models/ChatUser.dart';
import 'package:adopt_v2/src/features/chatScreen/models/Sellers.dart';
import 'package:adopt_v2/src/features/chatScreen/repositories/chat_repository.dart';
import 'package:adopt_v2/src/features/chatScreen/screens/chat_screen.dart';
import 'package:adopt_v2/src/features/chatScreen/screens/product_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class SellerListScreen extends StatefulWidget {

  @override
  _SellerListScreenState createState() => _SellerListScreenState();
}

class _SellerListScreenState extends State<SellerListScreen> {
  final ChatRepository _chatRepository = ChatRepository();
  final storage = FlutterSecureStorage();
  List<ChatList> chatData = [];
  TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  // late String _selectedUserId;
  List<Sellers> usersList = [];
  String username = '';


  @override
  void initState() {
    super.initState();
    _initializeData().then((_) {
      fetchSellerList();
    });

  }

  Future<void> _initializeData() async {
    username = await storage.read(key: 'username') ?? '';
    setState(() {
      username = username;
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

  Future<void> fetchSellerList() async {
    try {
      List<Sellers> fetchedData;
      fetchedData = await ChatRepository().fetchAllSellers();
      setState(() {
        usersList = fetchedData;
      });
    } catch (e) {
      print('Failed to fetch users: $e');
    }
  }

  void navigateToChatScreen(String userId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatScreen(userName: userId,userImageUrl: 'userImageUrl'), // Pass the selected user's data as a parameter
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sellers List'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: usersList.length, // Replace with your actual data
              itemBuilder: (BuildContext context, int index) {
                final chat = usersList[index];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/duser.png'), // User's profile image
                  ),
                  title: Text(
                    chat.sellername,
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
                    'chat with user',
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
                            ProductChat(userName: username, sellerName: chat.sellername),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
