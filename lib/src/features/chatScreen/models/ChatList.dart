class ChatList {
  final String receiverName; // The name of the receiver
  final String lastTimestamp; // Timestamp of the last message

  ChatList({
    required this.receiverName,
    required this.lastTimestamp,
  });

  factory ChatList.fromJson(Map<String, dynamic> json) {
    return ChatList(
      receiverName: json['receiverName'],
      lastTimestamp: json['lastTimestamp'],
    );
  }
}
