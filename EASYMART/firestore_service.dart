import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';
import '../models/store_model.dart';
import '../models/order_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- Stores ---
  Stream<List<Store>> getStores() {
    return _db.collection('stores').snapshots().map((snap) => snap.docs
        .map((d) => Store.fromMap({...d.data(), 'id': d.id}))
        .toList());
  }

  // --- Products ---
  Stream<List<Product>> getProducts() {
    return _db.collection('products').snapshots().map((snap) => snap.docs
        .map((d) => Product.fromMap({...d.data(), 'id': d.id}))
        .toList());
  }

  Stream<List<Product>> getProductsByStore(String storeId) {
    return _db
        .collection('products')
        .where('storeId', isEqualTo: storeId)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => Product.fromMap({...d.data(), 'id': d.id}))
            .toList());
  }

  Future<void> addProduct(Product p) =>
      _db.collection('products').doc(p.id).set(p.toMap());

  Future<void> updateProduct(Product p) =>
      _db.collection('products').doc(p.id).update(p.toMap());

  Future<void> deleteProduct(String id) =>
      _db.collection('products').doc(id).delete();

  // --- Orders ---
  Future<String> createOrder(Order o) async {
    final ref = await _db.collection('orders').add(o.toMap());
    return ref.id;
  }

  Stream<List<Order>> getUserOrders(String userId) {
    return _db
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => Order.fromMap({...d.data(), 'id': d.id}))
            .toList());
  }

  Stream<List<Order>> getStoreOrders(String storeId) {
    return _db
        .collection('orders')
        .where('storeId', isEqualTo: storeId)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => Order.fromMap({...d.data(), 'id': d.id}))
            .toList());
  }

  Future<void> updateOrderStatus(String orderId, String status) =>
      _db.collection('orders').doc(orderId).update({'status': status});
}
