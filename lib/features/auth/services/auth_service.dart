import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/services/api_service.dart';
import '../../../data/models/auth/authentication_request.dart';
import '../../../data/models/auth/authentication_response.dart';
import '../../../data/models/user.dart';

class AuthService {
  final ApiService _api = ApiService();
  final _storage = const FlutterSecureStorage();

  Future<AuthenticationResponse> login(String username, String password) async {
    try {
      final request = AuthenticationRequest(
        username: username,
        password: password,
      );

      final response = await _api.post('/auth/login', request.toJson());
      final authResponse = AuthenticationResponse.fromJson(response.data);
      
      // Store the token
      await _storage.write(key: 'jwt_token', value: authResponse.token);
      
      return authResponse;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _storage.delete(key: 'jwt_token');
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> isAuthenticated() async {
    final token = await _storage.read(key: 'jwt_token');
    return token != null;
  }

  Future<User> getCurrentUser() async {
    try {
      final response = await _api.get('/users/me');
      return User.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}