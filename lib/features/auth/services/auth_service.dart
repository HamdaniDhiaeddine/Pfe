import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/services/api_service.dart';
import '../../../core/constants/constants.dart';
import '../../../data/models/user.dart';
import 'package:dio/dio.dart';

class AuthService {
  final ApiService _api = ApiService();
  final _storage = const FlutterSecureStorage();

  Future<User> login(String username, String password) async {
    try {
      debugPrint('🔑 Attempting login for user: $username');
      
      final loginResponse = await _api.post(
        ApiConstants.login,
        {
          'username': username,
          'password': password,
        },
      );

      debugPrint('✅ Login response received');

      if (loginResponse.data == null || loginResponse.data['token'] == null) {
        throw 'Invalid server response';
      }

      // Store token
      final token = loginResponse.data['token'] as String;
      await _storage.write(key: 'jwt_token', value: token);
      debugPrint('🔐 Token stored successfully');

      // Get user profile
      final userResponse = await _api.get(ApiConstants.currentUser);
      if (userResponse.data == null) {
        throw 'Failed to fetch user profile';
      }

      debugPrint('👤 User profile fetched successfully');
      return User.fromJson(userResponse.data);
    } on DioException catch (e) {
      debugPrint('❌ API Error: ${e.message}');
      if (e.response?.statusCode == 401) {
        throw 'Invalid username or password';
      } else if (e.response?.statusCode == 403) {
        throw 'Account is locked or disabled';
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw 'Connection timeout. Please check your internet connection';
      }
      throw 'Failed to login. Please try again';
    } catch (e) {
      debugPrint('❌ Login error: $e');
      rethrow;
    }
  }

  Future<bool> isAuthenticated() async {
    try {
      final token = await _storage.read(key: 'jwt_token');
      if (token == null) return false;

      // Verify token by making a request
      try {
        await _api.get(ApiConstants.currentUser);
        return true;
      } catch (e) {
        await _storage.delete(key: 'jwt_token');
        return false;
      }
    } catch (e) {
      debugPrint('Auth check error: $e');
      return false;
    }
  }

  Future<User> getCurrentUser() async {
    try {
      final token = await _storage.read(key: 'jwt_token');
      if (token == null) {
        throw 'No authentication token found';
      }

      final response = await _api.get(ApiConstants.currentUser);
      if (response.data == null) {
        throw 'Failed to fetch user profile';
      }

      return User.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('API Error: ${e.message}');
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        await _storage.delete(key: 'jwt_token');
        throw 'Session expired. Please login again';
      }
      throw 'Failed to fetch user profile';
    } catch (e) {
      debugPrint('Get current user error: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      // Call logout endpoint if available
      try {
        await _api.post(ApiConstants.logout, {});
      } catch (e) {
        debugPrint('Logout API call failed: $e');
      }

      // Always clear local storage
      await _storage.delete(key: 'jwt_token');
    } catch (e) {
      debugPrint('Logout error: $e');
      rethrow;
    }
  }
}