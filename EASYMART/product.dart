class Product {
  final String id;
  final String storeId;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final bool isAvailable;

  Product({
    required this.id,
    required this.storeId,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.isAvailable = true,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'storeId': storeId,
        'name': name,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
        'category': category,
        'isAvailable': isAvailable,
      };

  factory Product.fromMap(Map<String, dynamic> map) => Product(
        id: map['id'] ?? '',
        storeId: map['storeId'] ?? '',
        name: map['name'] ?? '',
        description: map['description'] ?? '',
        price: (map['price'] ?? 0).toDouble(),
        imageUrl: map['imageUrl'] ?? '',
        category: map['category'] ?? '',
        isAvailable: map['isAvailable'] ?? true,
      );
}
