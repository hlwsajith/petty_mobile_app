class Vets {
  final String vetId;
  final String vetname;
  final String email;
  final String password;
  final String location;
  final String vetcategory;

  Vets({
    required this.vetId,
    required this.vetname,
    required this.email,
    required this.password,
    required this.location,
    required this.vetcategory
  });

  factory Vets.fromJson(Map<String, dynamic> json) {
    return Vets(
        vetId: json['vetId'],
        vetname: json['vetname'],
        email: json['email'],
        password: json['password'],
        location: json['location'],
        vetcategory: json['vetcategory']
    );
  }
}
