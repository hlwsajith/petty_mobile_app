import 'package:adopt_v2/src/features/chatScreen/models/ChatList.dart';
import 'package:adopt_v2/src/features/chatScreen/models/ChatUser.dart';
import 'package:adopt_v2/src/features/chatScreen/repositories/chat_repository.dart';
import 'package:adopt_v2/src/features/chatScreen/screens/chat_screen.dart';
import 'package:adopt_v2/src/features/chatScreen/widgets/sellers_list.dart';
import 'package:adopt_v2/src/features/chatScreen/widgets/vets_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class ChatListScreen extends StatefulWidget {
  final String username;

  const ChatListScreen({
    required this.username
  });

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final ChatRepository _chatRepository = ChatRepository();
  List<ChatList> chatData = [];
  TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  // late String _selectedUserId;
  List<ChatUser> usersList = [];


  @override
  void initState() {
    super.initState();

    fetchData(); // Fetch data when the widget is initialized
  }



  Future<void> fetchData() async {
    final chatItems = await _chatRepository.fetchData(widget.username); // Use the function from chat_repository.dart

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

  Future<void> fetchSellerList(String username) async {
    try {
      List<ChatUser> fetchedData;
        fetchedData = await ChatRepository().fetchSellerList(username);
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
        title: Text('Chat List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center, // Center the buttons horizontally
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SellerListScreen(),
                          ),
                        );
                      },
                      icon: Icon(Icons.chat_bubble_outline), // Replace with your desired icon
                      label: Text('Seller List'), // Replace with your desired text
                      style: ElevatedButton.styleFrom(
                        // You can customize the button's appearance here
                        primary: Color(0xff4FC9E0), // Change the button's background color
                        onPrimary: Colors.white, // Change the text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0), // Adjust the button's corner radius
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                VetsListScreen(),
                          ),
                        );
                      },
                      icon: Icon(Icons.chat_bubble_outline), // Replace with your desired icon
                      label: Text('Vet List'), // Replace with your desired text
                      style: ElevatedButton.styleFrom(
                        // You can customize the button's appearance here
                        primary: Color(0xff4FC9E0), // Change the button's background color
                        onPrimary: Colors.white, // Change the text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0), // Adjust the button's corner radius
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
                            ChatScreen(userName: chat.receiverName, userImageUrl: 'assets/images/duser.png'),
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
