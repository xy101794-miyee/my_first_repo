import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _service = AuthService();
  AppUser? _user;
  bool _loading = false;

  AppUser? get user => _user;
  bool get loading => _loading;
  bool get isLoggedIn => _user != null;

  Future<bool> login(String email, String password) async {
    _loading = true;
    notifyListeners();
    try {
      _user = await _service.login(email: email, password: password);
      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    String role = 'user',
  }) async {
    _loading = true;
    notifyListeners();
    try {
      _user = await _service.signUp(
        fullName: fullName,
        email: email,
        phone: phone,
        password: password,
        role: role,
      );
      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _service.logout();
    _user = null;
    notifyListeners();
  }

  Future<void> resetPassword(String email) => _service.resetPassword(email);
}
