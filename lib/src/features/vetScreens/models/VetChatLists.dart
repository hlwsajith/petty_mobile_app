class VetChatLists {
  final String receiverName; // The name of the receiver
  final String lastTimestamp; // Timestamp of the last message

  VetChatLists({
    required this.receiverName,
    required this.lastTimestamp,
  });

  factory VetChatLists.fromJson(Map<String, dynamic> json) {
    return VetChatLists(
      receiverName: json['receiverName'],
      lastTimestamp: json['lastTimestamp'],
    );
  }
}
