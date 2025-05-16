import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/services/api_service.dart';
import '../../../core/constants/constants.dart';
import '../../../data/models/user.dart';

class AuthService {
  final ApiService _api = ApiService();
  final _storage = const FlutterSecureStorage();

  Future<User> login(String username, String password) async {
    try {
      debugPrint('Attempting login for user: $username');
      
      final loginResponse = await _api.post(
        ApiConstants.login,
        {
          'username': username,
          'password': password,
        },
      );

      debugPrint('Login response: ${loginResponse.data}');

      // Store token
      final token = loginResponse.data['token'] as String;
      await _storage.write(key: 'jwt_token', value: token);
      
      // Verify token was stored
      final storedToken = await _storage.read(key: 'jwt_token');
      debugPrint('Stored token: $storedToken'); // Debug log

      // Get user profile
      final userResponse = await _api.get(ApiConstants.currentUser);
      debugPrint('User response: ${userResponse.data}'); // Debug log
      
      return User.fromJson(userResponse.data);
    } catch (e) {
      debugPrint('Login error: $e');
      rethrow;
    }
  }

  Future<bool> isAuthenticated() async {
    try {
      final token = await _storage.read(key: 'jwt_token');
      debugPrint('Checking authentication, token: $token'); // Debug log
      return token != null;
    } catch (e) {
      debugPrint('Auth check error: $e');
      return false;
    }
  }

  Future<User> getCurrentUser() async {
    try {
      // Verify token exists before making request
      final token = await _storage.read(key: 'jwt_token');
      if (token == null) {
        throw 'No authentication token found';
      }
      
      debugPrint('Getting current user with token: $token'); // Debug log
      final response = await _api.get(ApiConstants.currentUser);
      return User.fromJson(response.data);
    } catch (e) {
      debugPrint('Get current user error: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _storage.delete(key: 'jwt_token');
    } catch (e) {
      debugPrint('Logout error: $e');
      rethrow;
    }
  }
}