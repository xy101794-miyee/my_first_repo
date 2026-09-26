class Store {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double rating;
  final String category;
  final String address;

  Store({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.category,
    required this.address,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'imageUrl': imageUrl,
        'rating': rating,
        'category': category,
        'address': address,
      };

  factory Store.fromMap(Map<String, dynamic> map) => Store(
        id: map['id'] ?? '',
        name: map['name'] ?? '',
        description: map['description'] ?? '',
        imageUrl: map['imageUrl'] ?? '',
        rating: (map['rating'] ?? 0).toDouble(),
        category: map['category'] ?? '',
        address: map['address'] ?? '',
      );
}
