class ProductData {
  final String productId;
  final String name;
  final String category;
  final double price;
  final String description;
  final String condition;
  final String imageUrl;
  final String sellerName;
  final String sellerContact;
  final String ratingCount;

  ProductData({
    required this.productId,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.condition,
    required this.imageUrl,
    required this.sellerName,
    required this.sellerContact,
    required this.ratingCount
  });

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      productId: json['productId'],
      name: json['name'],
      category: json['category'],
      price: json['price'].toDouble(),
      imageUrl: json['imageUrl'],
      description: json['description'],
      condition: json['condition'],
      sellerName: json['sellerName'],
      sellerContact: json['sellerContact'],
      ratingCount: json['ratingCount'],
    );
  }
}
