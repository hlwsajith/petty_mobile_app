class Donation {
  final String center;
  final String location;
  final String availability;

  Donation({required this.center, required this.location, required this.availability});

  factory Donation.fromJson(Map<String, dynamic> json) {
    return Donation(
      center: json['center'],
      location: json['location'],
      availability: json['availability'],
    );
  }
}