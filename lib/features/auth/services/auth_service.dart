import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/services/api_service.dart';
import '../../../data/models/user.dart';

class AuthService {
  final ApiService _api = ApiService();
  final _storage = const FlutterSecureStorage();

  Future<User> login(String username, String password) async {
    try {
      debugPrint('Attempting login for user: $username');
      
      final loginResponse = await _api.post('/auth/login', {
        'username': username,
        'password': password,
      });

      debugPrint('Login response: ${loginResponse.data}');

      // Store the token
      final token = loginResponse.data['token'] as String;
      await _storage.write(key: 'jwt_token', value: token);

      // After successful login and token storage, fetch user profile
      final userResponse = await _api.get('/users/profile');
      debugPrint('User profile response: ${userResponse.data}');

      return User.fromJson(userResponse.data);
    } catch (e) {
      debugPrint('Login error: $e');
      throw 'Invalid username or password';
    }
  }

  Future<void> logout() async {
    try {
      await _storage.delete(key: 'jwt_token');
    } catch (e) {
      debugPrint('Logout error: $e');
      throw 'Failed to logout';
    }
  }

  Future<bool> isAuthenticated() async {
    final token = await _storage.read(key: 'jwt_token');
    return token != null;
  }

  Future<User> getCurrentUser() async {
    try {
      final response = await _api.get('/users/profile');
      return User.fromJson(response.data);
    } catch (e) {
      debugPrint('Get current user error: $e');
      throw 'Failed to fetch user profile';
    }
  }
}