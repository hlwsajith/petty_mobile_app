class Sellers {
  final String sellername;
  final String email;
  final String password;

  Sellers({
    required this.sellername,
    required this.email,
    required this.password
  });

  factory Sellers.fromJson(Map<String, dynamic> json) {
    return Sellers(
        sellername: json['sellername'],
        email: json['email'],
        password: json['password']
    );
  }
}
