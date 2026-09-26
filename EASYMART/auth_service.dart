import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Future<AppUser?> signUp({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    String role = 'user',
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final user = AppUser(
        id: cred.user!.uid,
        fullName: fullName,
        email: email,
        phone: phone,
        role: role,
      );
      await _db.collection('users').doc(user.id).set(user.toMap());
      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<AppUser?> login({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    final doc = await _db.collection('users').doc(cred.user!.uid).get();
    if (doc.exists) return AppUser.fromMap(doc.data()!);
    return null;
  }

  Future<void> logout() => _auth.signOut();

  Future<void> resetPassword(String email) =>
      _auth.sendPasswordResetEmail(email: email);
}
