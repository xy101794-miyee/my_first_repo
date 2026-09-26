class Grocery {
  int? id;
  String name;
  int quantity;
  String category;
  bool isPurchased;
  double price; // price per unit (for summary totals)

  Grocery({
    this.id,
    required this.name,
    required this.quantity,
    required this.category,
    this.isPurchased = false,
    this.price = 0.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'category': category,
      'isPurchased': isPurchased ? 1 : 0,
      'price': price,
    };
  }

  factory Grocery.fromMap(Map<String, dynamic> map) {
    return Grocery(
      id: map['id'],
      name: map['name'],
      quantity: map['quantity'],
      category: map['category'],
      isPurchased: (map['isPurchased'] ?? 0) == 1,
      price: (map['price'] ?? 0).toDouble(),
    );
  }

  Grocery copyWith({
    int? id,
    String? name,
    int? quantity,
    String? category,
    bool? isPurchased,
    double? price,
  }) {
    return Grocery(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
      isPurchased: isPurchased ?? this.isPurchased,
      price: price ?? this.price,
    );
  }
}
