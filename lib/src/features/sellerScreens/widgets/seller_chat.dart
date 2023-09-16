import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;

class SellerChat extends StatefulWidget {
  final String sellerName;
  final String authenticatedUserId; // Add this variable to store the authenticated user's ID


  SellerChat({
    required this.sellerName,
    required this.authenticatedUserId,
  });

  @override
  _SellerChatState createState() => _SellerChatState();
}

class _SellerChatState extends State<SellerChat> {
  late IO.Socket socket;
  List<String> messages = [];
  TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Establish the socket.io connection with authentication
    socket = IO.io(
      'http://your-node-js-server-url',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setQuery({'token': widget.authenticatedUserId})
          .build(),
    );

    socket.on('connect', (_) {
      print('Socket connected');
    });

    socket.on('message', (data) {
      setState(() {
        messages.add(data['content']);
      });
    });

    // Fetch previous messages for the selected seller from the backend
    _fetchPreviousMessages();
  }

  @override
  void dispose() {
    // Remember to disconnect the socket when no longer needed
    socket.disconnect();
    super.dispose();
  }

  void _sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.6:8000/message/savemessage'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'content': message,
          'receiver': widget.sellerName,
        }),
      );

      if (response.statusCode == 201) {
        final messageData = json.decode(response.body);
        socket.emit('message', messageData);
      } else {
        print('Failed to send message. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error while sending message: $e');
    }
  }

  Future<void> _fetchPreviousMessages() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.6:8000/message/getmessages/${widget.sellerName}'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<String> fetchedMessages =
        data.map((message) => message['content'].toString()).toList();
        setState(() {
          messages = fetchedMessages;
        });
      } else {
        print('Failed to fetch messages. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error while fetching messages: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.sellerName}'),
      ),
      body: Column(
        children: [
          // Chat messages display
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return _buildMessageTile(message);
              },
            ),
          ),
          // Input field for typing messages
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    onChanged: (value) {
                      // You can handle input changes if needed
                    },
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        _sendMessage(value);
                        setState(() {
                          messages.add('You: $value');
                        });
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    final message = _messageController.text;
                    if (message.trim().isNotEmpty) {
                      _sendMessage(message);
                      setState(() {
                        messages.add('You: $message');
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageTile(String message) {
    final isYou = message.startsWith('You: ');

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment:
        isYou ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isYou) ...[
            CircleAvatar(
              radius: 20.0,
              backgroundImage: AssetImage('assets/seller_avatar.jpg'),
            ),
            SizedBox(width: 8.0),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: isYou ? Colors.blue : Colors.grey[300],
              ),
              child: Text(
                message,
                style: TextStyle(
                  color: isYou ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
