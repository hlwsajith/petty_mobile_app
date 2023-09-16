class ChatUser {
  final String userName;
  final String userImageUrl;

  ChatUser({
    required this.userName,
    required this.userImageUrl
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      userName: json['userName'],
      userImageUrl: json['userImageUrl']
    );
  }
}
