class Chat {
  final String sender;
  final String receiver;
  final String text;
  final String timestamp;
  final bool isUserMessage;
  final bool isSellerMessage;
  final bool isVetMessage;

  Chat({
    required this.sender,
    required this.receiver,
    required this.text,
    required this.timestamp,
    required this.isUserMessage,
    required this.isSellerMessage,
    required this.isVetMessage,
  });

  // Add a factory method to deserialize JSON data
  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      sender: json['sender'],
      receiver: json['receiver'],
      text: json['text'],
      timestamp: json['timestamp'],
      isUserMessage: json['isUserMessage'],
      isSellerMessage: json['isSellerMessage'],
      isVetMessage: json['isVetMessage'],// Make sure 'isMyMessage' is present in your JSON data
    );
  }
}
