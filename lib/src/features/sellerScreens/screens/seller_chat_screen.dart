import 'package:adopt_v2/src/features/chatScreen/models/Chat.dart';
import 'package:adopt_v2/src/features/chatScreen/repositories/chat_repository.dart';
import 'package:adopt_v2/src/features/sellerScreens/repositories/seller_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:convert';

class SellerChatScreen extends StatefulWidget {
  final String userName;
  final String sellerName;

  const SellerChatScreen({
    required this.userName,
    required this.sellerName,
  });

  @override
  _SellerChatScreenState createState() => _SellerChatScreenState();
}

class _SellerChatScreenState extends State<SellerChatScreen> {
  final TextEditingController _textController = TextEditingController();
  late final IO.Socket socket;
  final storage = FlutterSecureStorage();
  List<Chat> chat = []; // Change to List<Chat> to store Chat messages
  String username = '';
  String userimage = '';

  @override
  void initState() {
    super.initState();
    // _initializeData().then((_) {
      _initializeSocket();
      fetchAllChats();
    // });
  }

  // Initialize user data from secure storage

  Future<void> _initializeData() async {
    username = await storage.read(key: 'username') ?? '';
    userimage = await storage.read(key: 'userimage') ?? '';

  }

  // Initialize the WebSocket connection
  void _initializeSocket() {
    _initializeData();
    print("*************************************");
    print(username);
    print(widget.userName);
    print("***************************************");
    socket = IO.io('http://192.168.1.6:8000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();
    socket.on('connect', (_) {
      print('Socket connected');
    });
    socket.on('message', (data) {
      setState(() {
        chat.add(Chat(
          sender: widget.sellerName,
          receiver: widget.userName,
          text: data,
          timestamp: DateTime.now().toString(),
          isUserMessage: true,
          isSellerMessage: false,
          isVetMessage: false,
        ));
      });
    });
    socket.on('disconnect', (_) {
      print('Socket disconnected');
    });
  }

  // Fetch old chats with the particular user
  Future<void> fetchAllChats() async {
    SellerRepository repository = SellerRepository();
    List<Chat> fetchedData = (await repository.fetchParticularSellerChats(widget.sellerName,widget.userName)).cast<Chat>();
    setState(() {
      chat.addAll(fetchedData);
    });
  }

  // Send a new message
  // void _sendMessage() {
  //   if (_textController.text.isNotEmpty) {
  //     final newMessage = Chat(
  //       sender: username,
  //       receiver: widget.userName,
  //       text: _textController.text,
  //       timestamp: DateTime.now().toString(),
  //       isMyMessage: true, // It's the user's message
  //     );
  //     socket.emit('message', newMessage);
  //     _textController.clear();
  //     setState(() {
  //       chat.add(newMessage);
  //     });
  //   }
  // }

  void _sendMessage() {
    if (_textController.text.isNotEmpty) {
      final newMessage = Chat(
        sender: widget.sellerName,
        receiver: widget.userName,
        text: _textController.text,
        timestamp: DateTime.now().toString(),
        isUserMessage: false,
        isSellerMessage: true,
        isVetMessage: false,// It's the user's message
      );

      // Convert the Chat object to a JSON-serializable Map
      final messageData = {
        'sender': newMessage.sender,
        'receiver': newMessage.receiver,
        'text': newMessage.text,
        'timestamp': newMessage.timestamp,
        'isUserMessage': newMessage.isUserMessage,
        'isSellerMessage': newMessage.isSellerMessage,
        'isVetMessage': newMessage.isVetMessage,
      };

      // Convert the Map to a JSON string
      final jsonString = json.encode(messageData);

      // Send the JSON string to the server
      socket.emit('message', jsonString);

      _textController.clear();
      setState(() {
        chat.add(newMessage);
      });
    }
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: chat.length,
              itemBuilder: (BuildContext context, int index) {
                final message = chat[index];
                return ChatMessageWidget(
                  message: message,
                );
              },
            ),
          ),
          _buildMessageComposer(),
        ],
      ),
    );
  }

  Widget _buildMessageComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                controller: _textController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: Colors.lightBlue,
            ),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}

class ChatMessageWidget extends StatelessWidget {
  final Chat message;

  ChatMessageWidget({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isSellerMessage = message.isSellerMessage;

    return Align(
      alignment: isSellerMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: isSellerMessage ? Colors.green[400] : Colors.grey[300],
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: isSellerMessage ? Colors.white : Colors.black,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}

// class Chat {
//   final String sender;
//   final String receiver;
//   final String text;
//   final String timestamp;
//   final bool isMyMessage;
//
//   Chat({
//     required this.sender,
//     required this.receiver,
//     required this.text,
//     required this.timestamp,
//     required this.isMyMessage,
//   });
// }
