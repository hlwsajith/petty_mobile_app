// service.dart
class Services {
  final String serviceId;
  final String name;
  final String imageUrl;
  final String description;
  final double price;
  final String sellerName;
  final String sellerContact;

  Services({required this.serviceId, required this.name, required this.imageUrl, required this.description, required this.price, required this.sellerName, required this.sellerContact});

  factory Services.fromJson(Map<String, dynamic> json) {
    return Services(
      serviceId: json['serviceId'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      description: json['description'],
      price: json['price'].toDouble(),
      sellerName: json['sellerName'],
      sellerContact: json['sellerContact'],
    );
  }
}
