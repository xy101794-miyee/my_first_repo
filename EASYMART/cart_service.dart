import '../models/cart_model.dart';
import '../models/product_model.dart';

class CartService {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (sum, i) => sum + i.quantity);

  double get subtotal => _items.fold(0.0, (sum, i) => sum + i.subtotal);

  double get deliveryFee => _items.isEmpty ? 0 : 3.99;

  double get total => subtotal + deliveryFee;

  void addItem(Product product) {
    final idx = _items.indexWhere((i) => i.product.id == product.id);
    if (idx >= 0) {
      _items[idx].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
  }

  void removeItem(String productId) {
    _items.removeWhere((i) => i.product.id == productId);
  }

  void updateQuantity(String productId, int qty) {
    final idx = _items.indexWhere((i) => i.product.id == productId);
    if (idx >= 0) {
      if (qty <= 0) {
        _items.removeAt(idx);
      } else {
        _items[idx].quantity = qty;
      }
    }
  }

  void clear() => _items.clear();
}
