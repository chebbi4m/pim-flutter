class Product {
  final String id;
  final String sellerId;
  final String productName;
  final String description;
  final double price;
  final String type;

  Product({
    required this.id,
    required this.sellerId,
    required this.productName,
    required this.description,
    required this.price,
    required this.type,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      sellerId: json['sellerId'],
      productName: json['productName'],
      description: json['description'],
      price: json['price'].toDouble(),
      type: json['type'],
    );
  }
}
