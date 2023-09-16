class SellerChatLists {
  final String receiverName; // The name of the receiver
  final String lastTimestamp; // Timestamp of the last message

  SellerChatLists({
    required this.receiverName,
    required this.lastTimestamp,
  });

  factory SellerChatLists.fromJson(Map<String, dynamic> json) {
    return SellerChatLists(
      receiverName: json['receiverName'],
      lastTimestamp: json['lastTimestamp'],
    );
  }
}
