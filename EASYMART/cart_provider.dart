import 'package:flutter/material.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';
import '../services/cart_service.dart';

class CartProvider extends ChangeNotifier {
  final CartService _service = CartService();

  List<CartItem> get items => _service.items;
  int get itemCount => _service.itemCount;
  double get subtotal => _service.subtotal;
  double get deliveryFee => _service.deliveryFee;
  double get total => _service.total;
  bool get isEmpty => items.isEmpty;

  void add(Product p) {
    _service.addItem(p);
    notifyListeners();
  }

  void remove(String id) {
    _service.removeItem(id);
    notifyListeners();
  }

  void updateQty(String id, int qty) {
    _service.updateQuantity(id, qty);
    notifyListeners();
  }

  void clear() {
    _service.clear();
    notifyListeners();
  }
}
