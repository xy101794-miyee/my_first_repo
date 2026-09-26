class Order {
  final String id;
  final String userId;
  final String storeId;
  final List<Map<String, dynamic>> items;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final String address;
  final String paymentMethod;
  final String
      status; // pending, accepted, preparing, delivering, completed, rejected
  final DateTime createdAt;

  Order({
    required this.id,
    required this.userId,
    required this.storeId,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.address,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'userId': userId,
        'storeId': storeId,
        'items': items,
        'subtotal': subtotal,
        'deliveryFee': deliveryFee,
        'total': total,
        'address': address,
        'paymentMethod': paymentMethod,
        'status': status,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Order.fromMap(Map<String, dynamic> map) => Order(
        id: map['id'] ?? '',
        userId: map['userId'] ?? '',
        storeId: map['storeId'] ?? '',
        items: List<Map<String, dynamic>>.from(map['items'] ?? []),
        subtotal: (map['subtotal'] ?? 0).toDouble(),
        deliveryFee: (map['deliveryFee'] ?? 0).toDouble(),
        total: (map['total'] ?? 0).toDouble(),
        address: map['address'] ?? '',
        paymentMethod: map['paymentMethod'] ?? '',
        status: map['status'] ?? 'pending',
        createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      );
}
