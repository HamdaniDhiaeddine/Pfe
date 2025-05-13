import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../../../data/models/user.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  bool _loading = false;

  User? get user => _user;
  bool get loading => _loading;
  bool get isAuthenticated => _user != null;

  Future<void> login(String username, String password) async {
    _loading = true;
    notifyListeners();

    try {
      final authResponse = await _authService.login(username, password);
      _user = authResponse.user;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _loading = true;
    notifyListeners();

    try {
      await _authService.logout();
      _user = null;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> loadUser() async {
    if (await _authService.isAuthenticated()) {
      _loading = true;
      notifyListeners();

      try {
        _user = await _authService.getCurrentUser();
      } finally {
        _loading = false;
        notifyListeners();
      }
    }
  }
}