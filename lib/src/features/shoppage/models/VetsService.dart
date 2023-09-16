// service.dart
class VetsService {
  final String vetId;
  final String vetname;
  final String email;
  final String password;
  final String location;
  final String vetcategory;

  VetsService({required this.vetId, required this.vetname, required this.email, required this.password, required this.location, required this.vetcategory});

  factory VetsService.fromJson(Map<String, dynamic> json) {
    return VetsService(
      vetId: json['vetId'],
      vetname: json['vetname'],
      email: json['email'],
      password: json['password'],
      location: json['location'],
      vetcategory: json['vetcategory']
    );
  }
}
