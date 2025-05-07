import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  String? _token;
  String? _role;
  bool _isAuthenticated = false;

  String? get token => _token;
  String? get role => _role;
  bool get isAuthenticated => _isAuthenticated;

  /// Load Token and Role from Secure Storage
  Future<void> loadToken() async {
    final savedToken = await AuthService.getToken();
    if (savedToken != null && !JwtDecoder.isExpired(savedToken)) {
      _token = savedToken;
      _isAuthenticated = true;

      // Decode the token to extract the role
      final decodedToken = JwtDecoder.decode(savedToken);
      _role = decodedToken['role']; // Ensure your backend includes 'role' in the token payload

      // Automatically log out when the token expires
      final expirationDate = JwtDecoder.getExpirationDate(savedToken);
      Future.delayed(expirationDate.difference(DateTime.now()), () {
        logout(); // Log out the user
      });
    } else {
      logout(); // Clear invalid/expired token
    }
    notifyListeners();
  }

  /// Login
  Future<bool> login(String username, String password) async {
    try {
      final token = await AuthService.login(username, password);
      if (token != null && !JwtDecoder.isExpired(token)) {
        _token = token;
        _isAuthenticated = true;

        await AuthService.saveToken(token); // Save token securely

        // Decode the token to extract the role
        final decodedToken = JwtDecoder.decode(token);
        _role = decodedToken['role'];

        // Automatically log out when the token expires
        final expirationDate = JwtDecoder.getExpirationDate(token);
        Future.delayed(expirationDate.difference(DateTime.now()), () {
          logout();
        });

        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Logout
  void logout() async {
    _token = null;
    _role = null;
    _isAuthenticated = false;

    await AuthService.removeToken(); // Remove token securely

    notifyListeners();
  }
}