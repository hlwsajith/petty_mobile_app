class Donation {
  final String type;
  final String location;
  final String availability;

  Donation({required this.type, required this.location, required this.availability});

  factory Donation.fromJson(Map<String, dynamic> json) {
    return Donation(
      type: json['type'],
      location: json['location'],
      availability: json['availability'],
    );
  }
}