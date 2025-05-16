import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../../../data/models/user.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  User? _user;
  bool _loading = false;
  String? _error;

  User? get user => _user;
  bool get loading => _loading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  Future<bool> login(String username, String password, BuildContext context) async {
  _loading = true;
  _error = null;
  notifyListeners();

  try {
    _user = await _authService.login(username, password);
    debugPrint('Login successful, user: ${_user?.username}');
    
    if (_user != null && context.mounted) {
      // Determine route based on user role
      String route = _getInitialRoute();
      
      // Navigate to appropriate dashboard
      await Navigator.pushNamedAndRemoveUntil(
        context,
        route,
        (route) => false,
      );
    }
    
    return true;
  } catch (e) {
    debugPrint('Login error in provider: $e');
    _error = _getErrorMessage(e);
    _user = null;
    return false;
  } finally {
    _loading = false;
    notifyListeners();
  }
}

String _getInitialRoute() {
  if (_user == null) return '/login';
  
  if (_user!.roles.any((role) => role.contains('SUPERADMIN'))) {
    return '/admin/dashboard';
  } else if (_user!.roles.any((role) => role.contains('RH'))) {
    return '/hr/dashboard';
  } else if (_user!.roles.any((role) => role.contains('MANAGER'))) {
    return '/manager/dashboard';
  } else if (_user!.roles.any((role) => role.contains('EMPLOYEE'))) {
    return '/employee/dashboard';
  }
  
  return '/dashboard';
}

  Future<void> logout(BuildContext context) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.logout();
      _user = null;
      
      // Navigate to login screen
      if (context.mounted) {
        await Navigator.pushNamedAndRemoveUntil(
          context,
          '/login',
          (route) => false,
        );
      }
    } catch (e) {
      _error = _getErrorMessage(e);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> loadUser() async {
    if (!await _authService.isAuthenticated()) {
      _user = null;
      notifyListeners();
      return;
    }

    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _authService.getCurrentUser();
    } catch (e) {
      debugPrint('Load user error: $e');
      _error = _getErrorMessage(e);
      _user = null;
      await _authService.logout(); // Clear invalid session
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> _navigateToUserDashboard(BuildContext context) async {
    if (_user == null) return;

    String route = '/dashboard'; // Default route

    if (_user!.roles.any((role) => role.contains('SUPERADMIN'))) {
      route = '/dashboard';
    } else if (_user!.roles.any((role) => role.contains('RH'))) {
      route = '/hr/dashboard';
    } else if (_user!.roles.any((role) => role.contains('MANAGER'))) {
      route = '/manager/dashboard';
    } else if (_user!.roles.any((role) => role.contains('EMPLOYEE'))) {
      route = '/employee/dashboard';
    }

    if (context.mounted) {
      await Navigator.pushNamedAndRemoveUntil(
        context,
        route,
        (route) => false,
      );
    }
  }

  String _getErrorMessage(dynamic error) {
    if (error is String) return error;
    return 'An unexpected error occurred. Please try again.';
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}