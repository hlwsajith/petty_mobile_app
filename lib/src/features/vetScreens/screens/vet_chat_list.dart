import 'package:adopt_v2/src/core/widgets/vet_bottombar.dart';
import 'package:adopt_v2/src/features/chatScreen/models/ChatList.dart';
import 'package:adopt_v2/src/features/chatScreen/models/ChatUser.dart';
import 'package:adopt_v2/src/features/chatScreen/repositories/chat_repository.dart';
import 'package:adopt_v2/src/features/chatScreen/screens/chat_screen.dart';
import 'package:adopt_v2/src/features/vetScreens/models/VetChatLists.dart';
import 'package:adopt_v2/src/features/vetScreens/repositories/vet_repository.dart';
import 'package:adopt_v2/src/features/vetScreens/screens/vet_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class VetChatList extends StatefulWidget {
  @override
  _VetChatListState createState() => _VetChatListState();
}

class _VetChatListState extends State<VetChatList> {
  final storage = FlutterSecureStorage();
  final VetRepository _chatRepository = VetRepository();
  List<VetChatLists> chatData = [];
  TextEditingController _searchController = TextEditingController();
  late String vetname;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _initializeData().then((_) {
      fetchData();
    });
  }

  Future<void> _initializeData() async {
    vetname = await storage.read(key: 'vetname') ?? '';
  }

  Future<void> fetchData() async {
    final chatItems = await _chatRepository.fetchData(vetname); // Use the function from chat_repository.dart

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
        title: Text('Vet Chat List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: 'Search',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _isLoading = true; // Start loading
                            _triggerSearch(); // Trigger the search function with a delay
                          });
                        },
                      ),
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
                SizedBox(width: 16.0),
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => SellerListScreen()),
                    // );
                  },
                  icon: Icon(Icons.add), // Replace with your desired icon
                  label: Text('Add Pet'), // Replace with your desired text
                  style: ElevatedButton.styleFrom(
                    // You can customize the button's appearance here
                    primary: Color(0xff4FC9E0), // Change the button's background color
                    onPrimary: Colors.white, // Change the text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0), // Adjust the button's corner radius
                    ),
                  ),
                ),
                // DropdownButton<String>(
                //   value: _selectedUserId,
                //   onChanged: (newValue) {
                //     setState(() {
                //       _selectedUserId = newValue!;
                //       fetchSellerList(newValue);
                //       navigateToChatScreen(newValue);
                //       // Fetch data for the selected user here
                //       // You can use _selectedUserId to identify the selected user
                //     });
                //   },
                //   items: usersList.map((user) {
                //     return DropdownMenuItem<String>(
                //       value: user.userName,
                //       child: Row(
                //         children: [
                //           CircleAvatar(
                //             radius: 20,
                //             backgroundImage: NetworkImage(user.userImageUrl),
                //           ),
                //           SizedBox(width: 10),
                //           Text(user.userName),
                //         ],
                //       ),
                //     );
                //   }).toList(),
                // ),
              ],
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
                            VetChatScreen(userName: chat.receiverName, vetname: vetname),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: VetBottomBar(),
    );
  }
}
